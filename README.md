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
* Kreiranje neuronske mreže
  + Neuronsku mrežu smo kreirali korištenjem gotovog matlab alata. Matlab posjeduje strukturu za neuronske mreže koja prilikom inicijalizacije izgleda ovako:
  <pre>
    <code>
    
    Neural Network
 
              name: 'Custom Neural Network'
        efficiency: .cacheDelayedInputs, .flattenTime,
                    .memoryReduction
          userdata: (your custom info)
 
    dimensions:
 
         numInputs: 0
         numLayers: 0
        numOutputs: 0
    numInputDelays: 0
    numLayerDelays: 0
 numFeedbackDelays: 0
 numWeightElements: 0
        sampleTime: 1
 
    connections:
 
       biasConnect: []
      inputConnect: []
      layerConnect: []
     outputConnect: []
 
    subobjects:
 
            inputs: {0x1 cell array of 0 inputs}
            layers: {0x1 cell array of 0 layers}
           outputs: {1x0 cell array of 0 outputs}
            biases: {0x1 cell array of 0 biases}
      inputWeights: {0x0 cell array of 0 weights}
      layerWeights: {0x0 cell array of 0 weights}
 
    functions:
 
          adaptFcn: (none)
        adaptParam: (none)
          derivFcn: 'defaultderiv'
         divideFcn: (none)
       divideParam: (none)
        divideMode: 'sample'
           initFcn: 'initlay'
        performFcn: 'mse'
      performParam: .regularization, .normalization
          plotFcns: {}
        plotParams: {1x0 cell array of 0 params}
          trainFcn: (none)
        trainParam: (none)
 
    weight and bias values:
 
                IW: {0x0 cell} containing 0 input weight matrices
                LW: {0x0 cell} containing 0 layer weight matrices
                 b: {0x1 cell} containing 0 bias vectors
 
    methods:
 
             adapt: Learn while in continuous use
         configure: Configure inputs & outputs
            gensim: Generate Simulink model
              init: Initialize weights & biases
           perform: Calculate performance
               sim: Evaluate network outputs given inputs
             train: Train network with examples
              view: View diagram
       unconfigure: Unconfigure inputs & outputs
 
    evaluate:       outputs = net(inputs)
    </code>
  <pre>
