function [] = nacrtaj_graf(net,X,y)

inputs = X(1:128,:)';
%size inputs
targets = y(1:128,:)';

net.divideFcn = 'divideind';  % Divide data by index
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainInd = 1:128;

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
%sumTest = sumTest + testPerformance;

% Uncomment these lines to enable various plots.
    figure, plotperform(tr)
%figure, plottrainstate(tr)
figure, plotconfusion(targets,outputs)
%figure, ploterrhist(errors)

end