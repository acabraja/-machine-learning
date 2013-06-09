function [ X, y ] = create_feature( db_data )
% Puni matricu podataka X (feature) i y(1 ili 0)
% Prima podatke iz baze koji su spremnjeni u db_data
% format db_data je ime_slike extension_slike ispravnost
% Vraca kreirane matrice X i y
% matrica X stupci su featuri a redci su primjeri

    % osnovne varijable
    %M = 12; % broj featura
    N = length(db_data); % broj podataka koje treba obraditi
    y = zeros(N,1);
    x1 = zeros(N,1);
    x2 = zeros(N,1);
    X = [];

    % varijable za 1.
    black_interval = [5,5,5];
    white_interval = [250,250,250];
    precision = [5,5,5];
    
    % varijable za 2.
    x3 = zeros(N,1);
    x4 = zeros(N,1);
    
    % varijable za 3.
    x5 = zeros(N,1);
    x6 = zeros(N,1);
    load_data = importdata('count_num_let.txt');
    
    % varijable za 4.
    x7 = zeros(N,1);
    
    % varijable za 5.
    x8 = zeros(N,1);
    
    % varijable za 6.
    x9 = zeros(N,1);
    x10 = zeros(N,1);
    x11 = zeros(N,1);
    red_interval = [255,0,0];
    gren_interval = [0,255,0];
    blue_interval = [0,0,255];
    rgb_precision = [2,2,2];
    
    %varijable ua 7.
    x12 = zeros(N,1);
    margine = 0.2; %oduzmi 20% sa svake strane
    
    % za svaku sliku odredi feature 
    for i =1:N;
        image = picture_in_matrix(db_data(i,1),'tablice',db_data(i,2));
    
        % 1. broj tamnih i svijetlih pixela
        [~,x1(i),x2(i)] = ...
            pixel_interval_count(image,black_interval,white_interval,precision);
        %------------------------------------------------------------------
        % 2. broj slova i brojeva 
        %[x3(i), x4(i)] = ocr(image);
        x3(i) = load_data(i,1);
        x4(i) = load_data(i,2);
        %------------------------------------------------------------------
        %3. slika kao binarana (0,1)
        [x5(i), x6(i)] = bw(image);
        %------------------------------------------------------------------
        %4. Omjer stranica 
        x7(i) = side_ratio(image);
        %------------------------------------------------------------------
        %5. Detekcija kutova ( kod vecih slova vise detektiranih kutova)
        x8(i) = picture_corresponding(image);
        %------------------------------------------------------------------
        %6. brojanje crvenih , plavih i zelenih nijansi
        [~,x9(i),x10(i)] = ...
            pixel_interval_count(image,red_interval,gren_interval,rgb_precision);
        [~,~,x11(i)] = ...
            pixel_interval_count(image,gren_interval,blue_interval,rgb_precision);
        %------------------------------------------------------------------
        %7. suzavanje slike prema sredini i gledanje omjera bijelo/crno
        x12(i) = ratio_picture_center(image,margine);
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
        x9(j) = (x9(j) - min(x9))/(max(x9) - min(x9));
        x10(j) = (x10(j) - min(x10))/(max(x10) - min(x10));
        x11(j) = (x11(j) - min(x11))/(max(x11) - min(x11));
        x12(j) = (x12(j) - min(x12))/(max(x12) - min(x12));
    end
    
    % Kreiranje matrice X sa sredjenim featurima
    X = [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12];
end
%end-----------------------------------------------------------------------