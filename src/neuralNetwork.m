% Kreiranje i treniranje neuronske mreze neuronskom mrežom

%ulazni parametri
inputs = X';
%size inputs
targets = y';
% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);
%net = newff(inputs,targets,hiddenLayerSize);
net.name = '0-1 classification';
%net.layers{1}.transferFcn = 'purelin';
%net.layers{2}.transferFcn = 'tansig';
% Izabrati input output preprocesing funkcije
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
K=1;
%K = 10; % k-fold cross validation
for k = 1:K
    if(  K == 1)
        % Postavljane parametra za djeljenje podataka na Test, Validaciju, Trening
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'dividerand';  % Divide rand
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainRatio = 0.7;
        net.divideParam.valRatio = 0.15;
        net.divideParam.testRatio = 0.15;
    else
        % Postavljane parametra za djeljenje podataka na Test, Validaciju, Trening
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'divideind';  % Divide data by index
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainInd = 1:100;
        net.divideParam.valInd = 101:128;
        net.divideParam.testInd = 129:150;
    end

    % algoritam za treniranje neuronske mreže
    % For a list of all training functions type: help nntrain
    %net.trainFcn = 'traingd'; % Bayesian Regulation backpropagation.

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
    figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, plotconfusion(targets,outputs)
%figure, ploterrhist(errors)
end