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
#### Kreiranje neuronske mreže
> Neuronsku mrežu smo kreirali korištenjem gotovog matlab alata. Matlab posjeduje strukturu za neuronske mreže koja prilikom inicijalizacije izgleda ovako:
>  <pre>
>    <code>
>          
>              name: 'Custom Neural Network'
>        efficiency: .cacheDelayedInputs, .flattenTime,
>                    .memoryReduction
>          userdata: (your custom info)
> 
>        dimensions:
> 
>         numInputs: 0
>        numLayers: 0
>        numOutputs: 0
>        numInputDelays: 0
>        numLayerDelays: 0
>        numFeedbackDelays: 0
>        numWeightElements: 0
>        sampleTime: 1
> 
>        connections:
> 
>        biasConnect: []
>        inputConnect: []
>        layerConnect: []
>        outputConnect: []
> 
>        subobjects:
> 
>            inputs: {0x1 cell array of 0 inputs}
>            layers: {0x1 cell array of 0 layers}
>           outputs: {1x0 cell array of 0 outputs}
>            biases: {0x1 cell array of 0 biases}
>        inputWeights: {0x0 cell array of 0 weights}
>        layerWeights: {0x0 cell array of 0 weights}
> 
>        functions:
> 
>          adaptFcn: (none)
>        adaptParam: (none)
>          derivFcn: 'defaultderiv'
>         divideFcn: (none)
>        divideParam: (none)
>        divideMode: 'sample'
>           initFcn: 'initlay'
>        performFcn: 'mse'
>        performParam: .regularization, .normalization
>          plotFcns: {}
>        plotParams: {1x0 cell array of 0 params}
>          trainFcn: (none)
>        trainParam: (none)
> 
>        weight and bias values:
> 
>                IW: {0x0 cell} containing 0 input weight matrices
>                LW: {0x0 cell} containing 0 layer weight matrices
>                 b: {0x1 cell} containing 0 bias vectors
> 
>          methods:
> 
>             adapt: Learn while in continuous use
>           configure: Configure inputs & outputs
>            gensim: Generate Simulink model
>              init: Initialize weights & biases
>           perform: Calculate performance
>               sim: Evaluate network outputs given inputs
>             train: Train network with examples
>              view: View diagram
>          unconfigure: Unconfigure inputs & outputs
> 
>          evaluate:       outputs = net(inputs)
>    </code>
>  <pre>
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
>
