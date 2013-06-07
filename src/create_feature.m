function [ X, y ] = create_feature( db_data )
% Puni matricu podataka X (feature) i y(1 ili 0)
% Prima podatke iz baze
% Vraca kreirane matrice X i y

    % osnovne varijable
    M = 6; % broj featura
    N = length(db_data); % broj podataka koje treba obraditi
    y = zeros(N,1);
    x1 = zeros(N,1);
    x2 = zeros(N,1);
    X = zeros(N,M+1);

    % varijable za 1.
    black_interval = [25,25,25];
    white_interval = [155,155,155];
    precision = [10,5,10];
    
    % varijable za 2.
    x3 = zeros(N,1);
    x4 = zeros(N,1);
    
    % varijable za 3.
    x5 = zeros(N,1);
    x6 = zeros(N,1);
    
    % za svaku sliku odredi feature 
    for i =1:N;
        slika = picture_in_matrix(db_data(i,1),'tablice',db_data(i,2));
    
        % 1. broj tamnih i svijetlih pixela
        [~,x1(i),x2(i)] = ...
            ratio_black_white(slika,black_interval,white_interval,precision);
        %------------------------------------------------------------------
        % 2. broj slova i brojeva 
        [x3(i), x4(i)] = ocr(slika);
        %------------------------------------------------------------------
        %3. slika kao binarana (0,1)
        [x5(i), x6(i)] = bw(slika);
        %------------------------------------------------------------------
        
        % Binarni vektor y za ispravno neispravno
        ispravnost = char(db_data(i,3));
        if  (strcmp(ispravnost,'ispravna'))
            y(i) = 1;
        end
    end
    
    %regulacija nekih featura (normalizacija)
    for j=1:N
        x1(j) = (x1(j) - min(x1))/(max(x1) - min(x1));
        x2(j) = (x2(j) - min(x2))/(max(x2) - min(x2));
        x5(j) = (x5(j) - min(x5))/(max(x5) - min(x5));
        x6(j) = (x6(j) - min(x6))/(max(x6) - min(x6));
    end
    
    % Kreiranje matrice X sa sredjenim featurima
    X = [ones(N,1), x1, x2, x3, x4, x5, x6];
end
