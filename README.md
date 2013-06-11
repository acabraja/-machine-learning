Automatsko prepoznavanje tablica metodama strojnog učenja
=================
> Ovaj rad je nastao kao rješenje projektnog zadatka iz kolegija [strojno učenje](http://web.math.pmf.unizg.hr/nastava/su/) koji se održava na Prirodoslovno-matematičnom fakultetu u Zagrebu. 
> Naš problem spada u klasu problema prepoznavanja objekata na slikama. Konkretno ovaj rad je baziran na klasifikaciji ekstrahiranih podataka sa slike na kojima se nalaze tablice automobila 
> ili neki objekti sličnih osobina.Cilj nam je napraviti klasifikator koji će biti sposoban prema naučenom novu sliku uvrstiti u skup kojemu pripada(tablica automobila ili ostalo). 
> Dakle cilj nam je konstruirati klasifikator za zadani [skup podataka](#podaci). Podaci koje koristimo nisu dio nekog standardnog već proučavanog skupa, nego su
> ručno prikupljeni. Ovo je binarni klasifikacijski problem i može se svrstati u klasu poznatih problema [oneVsAll ili multi klasifikacije](http://en.wikipedia.org/wiki/Multiclass_classification).


## Podjela problema i koraci rješavanja
1. [Problem klasifikacije](#problem-klasifikacije)
2. [Neuronske mreže](#neuronska-mrea)
3. [Odabir značajki](#odabir-znaajki)
4. [Prikupljanje podataka](#prikupljanje-podataka)
5. [Testiranje](#testiranje)
6. [Korištenje](#koritenje)
7. [Pisanje članka](#lanak)

## Struktura datoteka
* src (izvorni kod)
 + [ocr klasifikator](#ocr)
    - [templates.mat](#ocr)
    - [lines.m](#ocr)
    - [read_letter](#ocr)
 + [create_feature.m](#znacajke)
 + [run_classification.m](#pokretanje)
 + [neuralNetwork.m](#nn)
 + [picture_corresponding.m](#znacajka1)
 + [ratio_picture_center.m](#znacajka2)
 + [pixel_interval_count.m](#znacajka3)
 + [bw.m](#znacajka4)
 + [side_ratio](#znacajka5)
 + [db_class.m](#klasa)
 + [picture_in_matrix.m](#citanje-slika)
 + make_model.m
 + sigmoid.m
 + costFunction.m
 + [plotData.m](#crtanje)
 + [sql_data.mat](#ucitani podaci)
 + [X.mat i y.mat](#mat-znacajke)
* static
  + [baza sa slikama](#podaci)
  + kod za sql bazu podataka
  + [primjeri testiranja](#testiranje)
  + [dokumentacija](#clanak)


### Problem klasifikacije 
 Kada promatramo dani problem lako je uočiti da se radi o binarnom klasifikacijskom problemu. To je problem svrstavanja objekta sa danim značajkama u klasu kojoj pripada.
 U teoriji strojnog učenja, u kojoj naš problem promatramo, ovaj tip spada pod metode nadzornog učenja. Razlog tomu je što će za sve testne i trening primjere biti zadana
 target varijabla ( u našem slučaju binarna).

### Neuronska mreža
  Metoda strojnog učenja koju smo odabrali za kreiranje našeg modela odnosno klasifikatora. Kako je kod realiziran u MATLABU, taj nam software pruža mogućnost izgradnje neuronske
 mreže kroz definiranje već gotove strukture. Prilikom kreiranja koristili smo izvornu [dokumentaciju](http://www.mathworks.com/help/nnet/functionlist.html).
 Ukratko ovdje ćemo navesti parametre koje smo postavili te koje smo još mogućnosti imali.
 Inicijalizacija mreže ostvarena je sljedećim kodom <code> net = network(broj_skrivenih slojeva) </code>. Svaka neuronska mreža se sastoji od ulaznog sloja, skrivenog sloja te izlaznog sloja.
 Kako možete primjetiti prilikom inicijalizacije potrebno je samo zadati broj skrivenih slojeva jer po predpostavci mreža mora zadržavati ulazni i izlazni sloj. 
 Treba istaknuti da ulazni sloj neuronske mreže ne može računati. Računanje kreće tek u skrivenom sloju. 
  Za skrivene slojeve te za izlazni sloj potrebno je definirati aktivacijsku funkciju. To u MATLABU možemo ostvariti sljedećim kodom:<br/>
 <code> net.layers{1}.transferFcn = 'purelin';</code>. Ovdje 1 predstavlja koji je to sloj te mu dodjeljujemo neku od definiranih funkcija u MATLABU kao što je linearna funkcija (purelin).
 Također potrebno je odrediti težina za ulaz u svaki neuron neuronske mreže, no u ovom slučaju to će MATLABU riješti postavljanjem na neke slučajne vrijednosti. Postoje i druge metode kako se
 mogu postaviti početne vrijednosti, ali nama je odgovarala ova unaprijed definirana varijanta. Sintaksa je ista kao i za postavljanje aktivacijske funkcije.
  Nakon ovih nekoliko jednostavnih koraka već imamo izgrađenu osnovnu neuronsku mrežu. Sada je potrebno pridružiti mreži podatke za učenje, validaciju i testiranje. Kao i za prethodne probleme
 MATLABU u svojoj strukturi nudi neke od modela podjele podataka na potrebne skupove. Zanimljiva mogućnost je podjela na slučanjan način prema unaprijed definiranom omjeru. Upravo ovaj model 
 smo prvo koristili. Drugi model koji nam je bio od interesa jest da ručno odredimo koji podaci spadaju u koju grupu. Za ovakav model koristi se funkcija <code> divideint </code>.
  Ta je funkcija također ugrađena u matlab alat za rad s neuronskim mrežama te smo ju uključili u našu strukturu sljedećim kodoma <code>net.divideFcn = 'divideind';</code>.
  Kako su podaci spremljeni u veliku matricu X, nas funkcija traži indekse redaka te matrice(kasnije objašnjavamo da su redci primjeri). Ovako definirana meuronska mreža sa funkcijom 
  <code> divideind </code> je pogodna za kreiranje modela koji koristi [cross-validaciju](http://en.wikipedia.org/wiki/Cross-validation_(statistics)), što će nam  također biti potrebno.
   Konačno sada imamo mrežu koju možemo trenirati. No kako bi se mreža trenirala potrebno je u svakoj etapi treninga procijeniti grešku i korigirati težine. Podsjetimo se težine su na početku određene na slučajan način i vjerojatnost da su optimalne je vrlo mala stoga nam treba neki algoritam koji će trenirati i koji će procjenjivati grešku. Algoritam kojeg koristimo za treniranje 
  je [Gradient descent backpropagation.](http://en.wikipedia.org/wiki/Backpropagation). MATLABU nam nudi još mnogo funkcija za treniranje, navedena metoda nam je osnovna metoda i na neuronskoj mreži sa ovom trening funkcijom je provedeno većina istraživanja. No tokom testiranja smo pokušali i sa nekim drugim metodama testiranja kako bi stekli dojam brzine učenja ovisno o algoritmu.
   Sada je potpuno određena neuronska mreža te ju možemo početi trenirati. To je u MATLABU dosta jednostavno jer postoji funkcija <code> train </code> kojom treniramo mrežu te kao izlaz dobijemo podatke o greški ukupno, o greški na svakom od definiranih skupova posebno, te naravno dobijemo i skup težina za koje je mreža u treningu postigla najbolje rezutlate. Sve navedeno nam je potrebno da bi mogli procijenit preciznost i kontrolirati prenaučenost što su nam glavni ciljevi.


## Kako koristiti 

 Korištenje je predviđeno pokretanjem skripte run_classification

#### Osnovni koraci skripte i čitanje baze
> Nakon pokretanja skripte potrebno je pratiti nekoliko koraka.
> Prvi bitni korak da se odabere učitavanje iz baze ili se koriste već učitani primjeri.
> U slučaju da niste instalirali bazu podataka na prvi upit odgovorite sa 0.
> Nastavak korištenja je jednostavno prema uputama nekoliko puta stisnuti enter.

#### Evaluacijski koraci općenito
 * Nakon što se u 2. koraku evaliraju značajke na ekranu bi se trebala prikazati slika nekih odabranih značajki
 * Nakon što se u 3. koraku evaluira neuronska mreža na zaslonu se treba ponuditi GUI sučelje sa iscrtavanjem grafova
 i greškama u učenju, kao i matrica konfuzije.
 * Zadnji korak prije kraja programa je početak razvoja novog algoritma baziranog na linearnoj regresiji između manjeg
 broja značajki.

## O funkcijama za značajke i kreiranju neuronske mreže
#### Kreiranje neuronske mreže
> 
> 
>    
>  U ovo mrežu je potrebno postaviti određene parametre da bi se mogle koristiti metode.
>  U matlab datoteci <code> neuralNetwork.m </code> je dokumentirani primjer sa svim popunjenim parametrima 

#### OCR
> također smo koristili gotovo OCR rješenje za prepoznavanje slova i brojeva na tablici. 
> Sa algoritmom smo dobili <code> template.m </code> podatkovnu datoteku u kojoj su značajke za model slova i brojeva.
> Naš zadatak je bio implementirati OCR strukturu korištenjem kodovih algoritama.
> Sljedeći kod predstavlja realizaciju ocr-a preko gotovih funkcija preuzetih sa interneta
<pre>
 <code>
    function [letters,number] = ocr(imagen)
    % Funcija koja pokusava prepoznati slova i brojke sa slike
  % Ulazni parametri -> image : slika u rgb formatu
  % Izlazni parametri -> letters : broj slova
  %                   -> number  : broj brojeva

    % ako je u boji konvertiraj u crno-bjelo
    if size(imagen,3)==3 % ako je ovo onda je crno-bjela
        imagen=rgb2gray(imagen);
    end

    % konvertiraj u BW
    threshold = graythresh(imagen);
    imagen =~im2bw(imagen,threshold);

    % Obrise sve objekte manje od 30 pixela
    imagen = bwareaopen(imagen,30);

    %Inicijalizacija varijabli
    word=[ ];
    re=imagen;

    % ucitaj template
    %load templates
    global templates
    load templates
    % zbroj znakova u testnom skupu
    num_letras=size(templates,2);

    while 1
        % Analiza svake prepoznate rijeci
        [fl,re]=lines(re);
        imgn=fl;
        [L,Ne] = bwlabel(imgn);    
        for n=1:Ne
            [r,c] = find(L==n);
            % izdvoji slovo
            n1=imgn(min(r):max(r),min(c):max(c));  
            % reskaliraj znak tako da se slaže sa testnim velicinam
            img_r=imresize(n1,[42 24]);
            % prebaci iz slike u znak
            letter=read_letter(img_r,num_letras);
            % spoji u rjec
            word=[word letter];
        end
        
        % uvjet za brojanje slova
        number = 0;
        letters = 0;
        for i=1:length(word)
            if(strcmp(word(i),'0') || ...
                    strcmp(word(i),'1') || strcmp(word(i),'2') || ...
                    strcmp(word(i),'3') || strcmp(word(i),'4') || ...
                    strcmp(word(i),'5') || strcmp(word(i),'6') || ...
                    strcmp(word(i),'7') || strcmp(word(i),'8') || ...
                    strcmp(word(i),'9'))
                number = number + 1;
            else
                letters = letters + 1;
            end
        end
        % Clear 'word' variable
        word=[ ];
    
        %*When the sentences finish, breaks the loop
        if isempty(re)  %See variable 're' in Fcn 'lines'
            break
        end    
    end
    end
    %end-----------------------------------------------------------------------
 </code>
</pre>

#### Značajke
> Postoje funkcije koje su implementacija značajki iz rgb formata slike. Ovaj format
> smo uzeli kao format iz kojeg ćemo ekstrahirati podatke. 

##### Traženje određenih boja i njihovih omjera
> Postoji funkcija <code> pixel_interval_count </code> koja za sliku u rgb formatu vraća. 
> koliko je koja boja zastupljena. Boju zadajemo u rgb formatu te zadajemo dozvoljeni interval 
> za koji smatramo da je zapravo ista boja.
> Korišteno za traženje crvene, plave, zelene, crne i bijel.

##### Pretvorba u BW format
> Poziv funkcije <code> bw </code>
> Binarni format dakle slika je sada 0 ili 1 i predstavlja broj crnih i bijelih pixela.
> vraća taj broj

##### Traženje značajki na suženoj slici
> Poziv funkcije <code> ratio_picture_center </code>
> Funkcija postavlja margine oko slike i sužava sliku za odrećeni postotak
> Iz slike ekstrahira bw format i omjer bjelih i crnih pixela


##Dokumentacija i preuzimanje ukratko
> Preuzeti zip direktorija. Taj zip dekompresirati i nakon pokretanja matlaba pozicionirati se u direktorij.
> Za jednostavno pokretanje pokrenuti u matlabu <code> run_classification </code>.
> Za naprednije korištenje pogledati prethodna objašnjenja i komentare u kodu. Komentari posebno bitni da se vide ulazni i povratni parametri.
> Za pregled teorijske pozadine i nekih rezultata na testnom skupu (koji se također nalazi u sklopu projekta) pogledati dokumentaciju.
> Dokumentacija se nalazi u <code> static/clanak </code>.


Sve uočene greške možete nam proslijediti na mail

A.Čabraja i A.Grbić
