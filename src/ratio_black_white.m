function [feature_value, countBlack, countWhite] = ratio_black_white(A, interval_black, interval_white, precision)
%Vraca omjer tamnih i svijetlih pixela (crno-bjelo) gleda sve pixele u
%zadanom intervalu.
%povratni parametri: feature_value : vrijednost omjera (double)
%                    countBlack    : broj tamnih pixela -> crna
%                    countWhite    : broj svijetlih pixela -> bijela
%ulazni parametri:   A : rgb matrica dimenzija x,y,3 x*y pixela
%                    interval_black : vektor koji odeduje koja vrijednost
%                                     za svaku od 3 osnovne boje uzimamo
%                                     kao default vrijednost
%                    interval_white : identicno kao za interval_black
%                    precision      : sirina intervala promatranih boja 
%                                     kojeg cemo uzeti u obzir
%Primjer koristenja:
%        A = imread(picture)
%        interval_black = [20,25,20]    /najcesca za crnu
%        interval_white = [160,155,155] /najcesca za svikasto bjelu
%        precision = 5*ones(1,3)          /interval sirine 5 oko zadanog
%        [x, bc, wc] = ratio_black_white(A, interval_black,.....)

    blackPixelMask = abs(A(:,:,1) - interval_black(1)) < precision(1) & abs(A(:,:,2) - interval_black(2)) < precision(2) & abs(A(:,:,3) - interval_black(3)) < precision(3);
    whitePixelMask = abs(A(:,:,1) - interval_white(1)) < precision(1) & abs(A(:,:,2) - interval_white(2)) < precision(2) & abs(A(:,:,3) - interval_white(3)) < precision(3);
    
    countBlack = nnz(blackPixelMask);
    countWhite = nnz(whitePixelMask);
    
    feature_value = countWhite/countBlack;
end