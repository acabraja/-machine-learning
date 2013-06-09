Automatsko prepoznavanje tablica metodama strojnog učenja
=================

1. Problem klasifikacije
2. Neuronske mreže
3. Odabir značajki
4. Prikupljanje podataka
5. Testiranje

## Struktura datoteka

* src (izvorni kod)
 + ocr
 + createFeature
 + runClassification
 + sigmoidFunction
 + neuralNetwork
 * ostali pomocne datoteke
* static
  + baza slika
  + kod za sql bazu podataka
  + neka testiranja


## Kako koristiti 

 Korištenje je predviđeno pokretanjem skripte run_classification

#### Onovni koraci skripte i čitanje baze
 Nakon pokretanja skripte potrebno je pratiti nekoliko koraka.
 Prvi bitni korak da se odabere učitavanje iz baze ili se koriste već učitani primjeri.
 U slučaju da niste instalirali bazu podataka na prvi upit odgovorite sa 0.
 Nastavak korištenja je jednostavno prema uputama nekoliko puta stisnuti enter.

#### Evaluacijski koraci općenito
 * Nakon što se u 2. koraku evaliraju značajke na ekranu bi se trebala prikazati slika nekih odabranih značajki
 * Nakon što se u 3. koraku evaluira neuronska mreža na zaslonu se treba ponuditi GUI sučelje sa iscrtavanjem grafova
 i greškama u učenju, kao i matrica konfuzije.
 * Zadnji korak prije kraja programa je početak razvoja novog algoritma baziranog na linearnoj regresiji između manjeg
 broja značajki.

## O funkcijama za značajke i kreiranju neuronske mreže

