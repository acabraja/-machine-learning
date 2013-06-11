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
5. [Testiranje](#lanak)
6. [Pokretanje u matlabu](#pokretanje-u-matlabu)
7. [Pisanje članka](#lanak)

## Struktura datoteka
* src (izvorni kod)
 + [ocr klasifikator](#ocr)
 + [create_feature.m](#odabir-znaajki)
 + [run_classification.m](#odabir-znaajki)
 + [neuralNetwork.m](#neuronska-mrea)
 + [picture_corresponding.m](#odabir-znaajki)
 + [ratio_picture_center.m](#odabir-znaajki)
 + [pixel_interval_count.m](#odabir-znaajki)
 + [bw.m](#odabir-znaajki)
 + [side_ratio](#odabir-znaajki)
 + [db_class.m](#baza)
 + [picture_in_matrix.m]()
 + [make_model.m]()
 + [sigmoid.m]()
 + [costFunction.m]()
 + [plotData.m]()
 + [sql_data.mat](#ubaza)
 + [X.mat i y.mat](#baza)
* static
  + [baza sa slikama]()
  + [kod za sql bazu podataka]()
  + [primjeri testiranja](#lanak)
  + [dokumentacija](#lanak)


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
Svaka slika je reprezentirna trodimenzionalnom matricom koja predstavlja rgb format slike. Kako je svaka slika minimalno 60X150 pixela te kako svaki pixel predstavlaju 3 broja, slijedi da je 
je svaka slika reprezentirana sa otprilike 1500 brojeva. Takva reprezentacija nije pogodna za učenje jer bi vjerojatnost od prenaučenosti bila prevelika. Stoga smo implementirali funkcije koje
će iz dane matrice za svaku sliku izvući najbitnije podatke. Konkretno za svaku sliku određujemo 12 značajki to jest u našem modelu sliku predstavlja 12 dimenzionalni vektro realnih brojeva.
Funkcije koje određuju značajke nećemo detaljno opisivati jer su dokumentiranje sa detaljnim objašnjenjem. Navest ćemo značajke i njihovu ulogu, a detaljnije o značajkama možete pronaći 
u [članku](#lanak).

###### Broj svijetlih i tamnih pixela
Funkcija <code> pixel_interval_count</code> vraća dvije značajke. Uloga ovih značajki jest u tome što su neke slike "prljave" što znači da 
ako želimo vidjeti odnose neke dvije boje ovdje konkretno crna i bijela(nisu prave boje ali u ovom kontekstu ćemo govorit da jesu). Sami određujemo
koliko širok interval neke boje želimo gledati te nam funkcija vrati broj takvih pojavljivanja na slici. Crna i bijela te siva se najčešće javljaju na tablicama dok su 
ostali objekti šareniji te je broj pojavljivanja ovakvih intervala manji.

###### Broj crvenih, plavih i zelenih pixela
Koristimo istu funkciju kao i za prethodne značajke samo sada tražimo 3 osnovne boje. Primjetili smo da se na stranim tablicama četo pojavljuje jedna od ove 3 boje
ali gotovo nikad u kombinaciji. Također smo primjetili da se na slikama gdje nisu tablice ove 3 boje gotovo uvijek pojavljuju u svim kombinacijama. Stoga ovau značajku smatramo 
jako bitnom.

###### Pojavljivanje kutova na slici
Funkcija <code> picture_corresponding </code> je zadužena za ovaj posao. Vraća broj detektiranih kutova na slici. Razlog uvrštavanja ove značajke je što se na tablicama automobila slova registracija pojavljuju u krupnom planu, te stoga na slikama gdje su tablice uvijek je detektirano više kutova nego na nekim drugim slikama sa obićnim tekstom.

###### Dimenzije slike
Pošto predpostavljamo da imamo ekstrahirane slike onda možemo reći da je slika približno istih dimenzija ili barem istog oblika kao i objekt na njoj. Ova značajka nije jaka
ali je korisna kako bi detektirali neke čudne oblike kao što su veći kvadratni oblici koji nikako ne mogu biti tablica. Glavna predpostavka je da su objekti dobro izdvojeni.
Funkcija koja obavlja traženi posao je <code>side_ratio</code>.

###### Binarna slika
Funkcija <code>bw</code> pretvara sliku u binarni oblik iz kojeg onda čita broj 0 i broj 1 te traži omjer bjela/crna. Razlog je to što su na tablicama bijela i crna podjednako zastupljene
a kod odtalih slika prevladava crna kada se pretvori u binarnu sliku. Stoga ova značajka je bitna i jako korisna.

###### OCR
Određivanje broja slova i broja brojeva koji se pojavljuju na slici. Ovo je najjača značajka koju smo koristili. Tablice u principu imaju odnos brojevi slova 3:4 ili 4:4 ili 4:5 dok je kod svih ostalih objekata ili 0 ili neki veći broj kada se radi o tekstu. Problem kod ove značajke je što funkcija za ekstrahiranje podataka nije jednostavna te sama koristi metode strojnog učenja.
Nismo implementirali ovaj algoritam nego smo preuzeli gotovo riješenje. Kao moguću nadogradnju našeg projekta želimo stvoriti vlastiti ocr koji će bit specijaliziran za naš slučaj. Naišli smo na mali problem prilikom korištenja OCR-a jer nije točno prepoznavao slova i brojeve. Stoga smo se u konačnici odlučili na predpostavku da imamo savršeni OCR te da su nam podaci koje je vratio potpuno točni. S takvim podacima smo stvorili jaku značaju. Zbog toga nam je prvi korak u daljnjem razvoju projekta naš vlastit OCR.

### Pokretanje u matlabu 

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

#### Članak
O radu je napisan članak u kojem su detaljnije iznesei podaci i testiranja algoritama. Članak možete preuzeti u <code>static/clanak</code> direktoriju: U istom
direktoriju se nalaze i slike istraživanja, neuronske mreže, krivulja učenja i svi korisni podaci do kojih smo došli istraživanjem. Kako aktivno provodimo
istraživanja mogu će su promjene trenutnog stanja u ovom direktoriju.

> ####Baza 
> U direktorijima je instaliran software pisat u javi koji radi virtualnu konekciju mysql-a i matlaba. Taj software je složen i koristimo ga bez eksplicitnog tedaljnog znanja o njemu
> U slučaju da se želite uklučiti u razvoj u direktoriju baza možete naći sql datoteku za učitavanje cijele baze u mysql.


> Sve uočene greške možete nam proslijediti na mail
> A.Čabraja i A.Grbić
