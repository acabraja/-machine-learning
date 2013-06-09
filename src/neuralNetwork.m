% Kreiranje i treniranje neuronske mreze neuronskom mrežom

%ulazni parametri
inputs = X';
%size inputs
targets = y';
% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);
net.name = '0-1 classification';
net.layers{1}.transferFcn = 'purelin';
%net.layers{2}.transferFcn = 'logsig';
% Izabrati input output preprocesing funkcije
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Postavljane parametra za djeljenje podataka na Test, Validaciju, Trening
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
%net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 75/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 10/100;

% algoritam za treniranje neuronske mreže
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm'; % Bayesian Regulation backpropagation.

% Funkcija greske
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Funkcije za crtanje 
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};


% Treniranje mreze
[net,tr] = train(net,inputs,targets);

% Testiranje mreze
outputs = net(inputs);
errorsnet = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, plotconfusion(targets,outputs)
%figure, ploterrhist(errors)
