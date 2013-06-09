function [J, grad] = costFunction(theta, X, y, lambda)
%Funkcija koja racuna gresku pomocu log funkcije
% Ulazni parametri -> theta : tezine
%                  -> X     : primjeri
%                  -> y     : target
%                  -> lambda: regulacijski faktor
% Izlazni parametri-> J : greska za theta
%                  -> grad : updatani gradijent

    % Inicijalizacija vrijednosti
    m = length(y); 
    J = 0;
    grad = zeros(size(theta));
    %size(theta);
    %size(X)
    
    pred = sigmoid(X*theta); % funkcija h
    % Regularizacija
    reg = theta'*theta;   
    reg = reg - theta(1)^2;
    reg = (lambda*reg)/(2*m);
    % Greska
    delta = y' *log(pred) + (1-y)'*log(1-pred);
    J = sum(delta);
    J = (-1*J)/m + reg;
    % Gradijent
    errMartix = sigmoid(X*theta) - y;
    grad(1) = 1/m * sum(errMartix.*X(:,1));
    for i = 2:size(theta)
        grad(i) = 1/m * sum(errMartix.*X(:,i)) + lambda/m * theta(i);
    end
end
%end-----------------------------------------------------------------------
