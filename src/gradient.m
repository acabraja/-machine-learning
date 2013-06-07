function [ theta, J, exit_flag ] = gradient( X, y )

%initial_theta = ones(size(X, 2), 1)*5;
% regularizacijiski parametar
%lambda = 1;

% Racuna inicijalnu gresku
% regression
%[cost, ~] = costFunction(initial_theta, X, y, lambda);

%fprintf(' Greska na inicijalnoj theta %f\n', cost);

%fprintf('\nZa nastavak pritisnite enter.\n');
%pause;

% Postavljanje varijabli za racunanje optimalnih theta parametara
initial_theta = [1;1;-0.2;0.7;0.6];
lambda = 1; % ne gledamo  regularizaciju za sada

% opcije za fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400); % 400 ineracija

% Optimizacija parametara
[theta, J, exit_flag] = ...
	fminunc(@(t)(costFunction(t, X, y, lambda)), initial_theta, options);

end

