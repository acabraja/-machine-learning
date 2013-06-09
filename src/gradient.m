function [ theta, J, exit_flag ] = gradient( X, y )
% Gradijentni spust sa nagradom uz koeficijent lambda
% Ulazni parametri -> X : primjeri
%                  -> y : target varijabla
% Izlazni parametir -> theta: najbolje tezine
%                   -> J : funkcija greske
%                   -> exit_flag : status

    %initial_theta = ones(size(X, 2), 1)*5;
    % regularizacijiski parametar
    lambda = 1;

    % Racuna inicijalnu gresku
    % regression
    %[cost, ~] = costFunction(initial_theta, X, y, lambda);

    %fprintf(' Greska na inicijalnoj theta %f\n', cost);

    %fprintf('\nZa nastavak pritisnite enter.\n');
    %pause;

    % Postavljanje varijabli za racunanje optimalnih theta parametara
    % ako je greska s dimenzijama ovo napravi
    % ako korisnimo sam gradijent
    X = [ones(size(X,1),1), X];
    initial_theta = zeros(size(X,2),1);
    % lambda = 0; % ne gledamo  regularizaciju za sada
    % opcije za fminunc
    options = optimset('GradObj', 'on', 'MaxIter', 400); % 400 ineracija

    % Optimizacija parametara
    [theta, J, exit_flag] = ...
        fminunc(@(t)(costFunction(t, X, y, lambda)), initial_theta, options);
end
% end ---------------------------------------------------------------------
