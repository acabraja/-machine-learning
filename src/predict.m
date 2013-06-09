function p = predict(theta, X)
% vraca izracunate vrijednosti kao 0,1
% Pomnozimo thetu sa svojim X i klasificiramo 1 ako >=0.5; 0 inaće

    m = size(X, 1); % broj primjera

    p = zeros(m, 1); %inicijalizacija

    rez = sigmoid(X*theta); % aktivacijska funkcija
    for I = 1:m
        if(rez(I) >=0.5) %ako je vece od 0.5 onda je to ispravno (1)
            p(I)=p(I)+1;
        end
    end
end
%end-----------------------------------------------------------------------