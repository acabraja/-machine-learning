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
3. [Prikupljanje podataka](#prikupljanje-podataka)
4. [Odabir značajki](#odabir-znaajki)
5. [Testiranje](#testiranje)
6. [Pokretanje u matlabu](#pokretanje-u-matlabu)
7. [Pisanje članka](#lanak)

## Struktura datoteka
* src (izvorni kod)
 + [ocr klasifikator](#ocr)
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
 + [make_model.m]()
 + [sigmoid.m]()
 + [costFunction.m]()
 + [plotData.m](#crtanje)
 + [sql_data.mat](#ucitani podaci)
 + [X.mat i y.mat](#mat-znacajke)
* static
  + [baza sa slikama](#podaci)
  + [kod za sql bazu podataka]()
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
 Kako možete primjetiti prilikom inicijalizacije potrebno je samo zadati broj skrivenih slojeva jer po predpostavci mreža mora sadržavati ulazni i izlazni sloj. 
 Treba istaknuti da ulazni sloj neuronske mreže ne može računati. Računanje kreće tek u skrivenom sloju. 
  Za skrivene slojeve te za izlazni sloj potrebno je definirati aktivacijsku funkciju. To u MATLABU možemo ostvariti sljedećim kodom:<br/>
 <code> net.layers{1}.transferFcn = 'purelin';</code>. Ovdje 1 predstavlja koji je to sloj te mu dodjeljujemo neku od definiranih funkcija u MATLABU kao što je linearna funkcija (purelin).
 Također potrebno je odrediti težina za ulaz u svaki neuron neuronske mreže, no u ovom slučaju to će MATLABU riješti postavljanjem na neke slučajne vrijednosti. Postoje i druge metode kako se
 mogu postaviti početne vrijednosti, ali nama je odgovarala ova unaprijed definirana varijanta. Sintaksa je ista kao i za postavljanje aktivacijske funkcije.
  Nakon ovih nekoliko jednostavnih koraka već imamo izgrađenu osnovnu neuronsku mrežu. Sada je potrebno pridružiti mreži podatke za učenje, validaciju i testiranje. Kao i za prethodne probleme
 MATLABU u svojoj strukturi nudi neke od modela podjele podataka na potrebne skupove. Zanimljiva mogućnost je podjela na slučanjan način prema unaprijed definiranom omjeru. Upravo ovaj model 
 smo prvo koristili. Drugi model koji nam je bio od interesa jest da ručno odredimo koji podaci spadaju u koju grupu. Za ovakav model koristi se funkcija <code> divideint </code>.
  Ta je funkcija također ugrađena u matlab alat za rad s neuronskim mrežama te smo ju uključili u našu strukturu sljedećim kodoma <code>net.divideFcn = 'divideind';</code>.
  Kako su podaci spremljeni u veliku matricu X, nas funkcija traži indekse redaka te matrice(kasnije objašnjavamo da su redci primjeri). Ovako definirana neuronska mreža sa funkcijom 
  <code> divideind </code> je pogodna za kreiranje modela koji koristi [cross-validaciju](http://en.wikipedia.org/wiki/Cross-validation_(statistics)), što će nam  također biti potrebno.
   Konačno sada imamo mrežu koju možemo trenirati. No kako bi se mreža trenirala potrebno je u svakoj etapi treninga procijeniti grešku i korigirati težine. Podsjetimo se težine su na početku određene na slučajan način i vjerojatnost da su optimalne je vrlo mala stoga nam treba neki algoritam koji će trenirati i koji će procjenjivati grešku. Algoritam kojeg koristimo za treniranje 
  je [Gradient descent backpropagation.](http://en.wikipedia.org/wiki/Backpropagation). MATLABU nam nudi još mnogo funkcija za treniranje, navedena metoda nam je osnovna metoda i na neuronskoj mreži sa ovom trening funkcijom je provedeno većina istraživanja. No tokom testiranja smo pokušali i sa nekim drugim metodama testiranja kako bi stekli dojam brzine učenja ovisno o algoritmu.
   Sada je potpuno određena neuronska mreža te ju možemo početi trenirati. To je u MATLABU dosta jednostavno jer postoji funkcija <code> train </code> kojom treniramo mrežu te kao izlaz dobijemo podatke o greški ukupno, o greški na svakom od definiranih skupova posebno, te naravno dobijemo i skup težina za koje je mreža u treningu postigla najbolje rezutlate. Sve navedeno nam je potrebno da bi mogli procijenit preciznost i kontrolirati prenaučenost što su nam glavni ciljevi.<br/>
   Cijelovit kod za neuronsku mrežu se nalazi u src direktoriju i unutar matlaba se poziva jednostavom komandom <code> neuralNetwork </code>

### Prikupljanje podataka
Svi primjeri , nih 150 se nalazi u direktoriju <code>static/test-set/tablice </code>. Podaci su većinom mormalizirani što znači ekstrahirani su iz većih slika te je na većini njih okolni 
šum sveden na minimum. U bazi se nalazi oko 100 slika na kojima se nalaze tablice te 50-ak slika na kojima su razni drugi objekti sličnih karakteristikam kao naprimjer, reklame, putokazi, znakovi. Svi podaci su prikupljeni ručno i prema vlastitom navođenu podjeljeni u skup za cross-Validaciju i testni skup. Podjela je takva da u testni skup spadaju one slike čiji je indeks > 128.
Sve slike u bazi su numerirane od 1 do 150 i to im ujedno predstavlja i ime i id odnosno indeks. Prilikom prikupljanja podataka najveći problem je bio kut slikanja te tako imamo slike iz različitih kutova ali otprilike iste kvalitete. SA određenim značajkama ćemo pokušati taj problem svesti na jednu značajku reprezentiranu sa jednom realnom vrijednošću.

### Odabir značajki


## Pokretanje u matlabu 

 Korištenje je predviđeno pokretanjem skripte run_classification. Postoji i mogućnost pokretanja dijelova koda odnosno zasebno pokretanje svih funkcija. 
 Da pi se korištenje bez predviđene skripte ostvarilo potrebno je loadati podatke iz <code> X.mat, y.mat, sql_data.mat</code>.

#### Skripta run_classification
Prilikom pokretanja skripta nudi dvije mogućnosti. Prva mogućnost je da upisete 0 ili samo pritisnete enter čime pokrećete čitanje svih pdataka iz .mat datoteka. Ovo je jednostaviji
način korištenja i ne zahtijeva [instaliranje](#baza) baze. Instalacija baze i spajanje na bazu je za potrebe daljnjeg razvoja. Mogućnost spajanja na bazu ostvaruje se upisivanjem 1 u prvom koraku skripte nakon čega je potrebno unijeti neke podatke za spajanje na mysql bazu. Nakon nekoliko trenutaka podaci će biti učitani i spremni za korištenje. Skripta je dizajnirana tako da 
između koraka očekuje da korisnik pritisne neku tipku na tipkovnici. Nakon učitavnja podatka sljedeći korak je računanje i traženje značajki za sve slike u bazi te vizualizacija nekih podataka u obliku matlab plot figure. <br/>
Nakon inicjalizacije i upoznavanjem sa podacima sljedi inicijalizacija modela neuronske mreže i pokretanje učenja neuronske mreže. Postoje dvije verzije na kojima je testirano te će se one izvoditi redom. Prva verzija je neuronska mreža sa slučajnim odabirom skupa za validaciju testiranje i učenje na osnovu zadanog postotka . 70% učenje po 15% validacija i test. Korisnik samo treba pričekati dok mu se ne pojavi sučelje i pratitit događanja u iteracijama algoritma. Na kraju sučelje nudi i mogućnosti iscrtavanja svih korisnih grafova što omogućuje pregled sposobnosti danog modela. Nakon toga moguće je pokrenuti i drugu verziju sa cross-validacijom. Kao i u prvom slučaju korisnik treba samo pričekati i poslije će sučelje biti dovoljno jasno za upotrebu. Sučelje će kao i u prvom slučaju iscrtati sve grafove koji će se prikazati na zaslonu te će se lako moći vidjeti kako se odnosi mjenjaju sa mjenjanjem skupa za učenje i validaciju.
Zadnja mogućnost koju skripta nudi, trenutno nije završena, bazira se na modelu procijene odnosa između dvije značajke pomoću linearne regresije. Ovoj korak je u skripti jer služi za daljni razvoj algoritama van okvira kolegija zbog kojeg je projekt nastao.

#### Preuzimanje
Preuzeti zip direktorij sa github-a te ga raspakirati. S matlabom se pozicionirati u src direktorij unutar projekta i nakon toga je sve spremno za korištenje.

#### Kreiranje neuronske mreže

 U ovo mrežu je potrebno postaviti određene parametre da bi se mogle koristiti metode.
 U matlab datoteci <code> neuralNetwork.m </code> je dokumentirani primjer sa svim popunjenim parametrima 

#### OCR
> također smo koristili gotovo OCR rješenje za prepoznavanje slova i brojeva na tablici. 
> Sa algoritmom smo dobili <code> template.m </code> podatkovnu datoteku u kojoj su značajke za model slova i brojeva.
> Naš zadatak je bio implementirati OCR strukturu korištenjem kodovih algoritama.
> Sljedeći kod predstavlja realizaciju ocr-a preko gotovih funkcija preuzetih sa interneta

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
