function [ nBlack, nWhite ] = bw( image )
% Funkcija koja vraca broj crnih i bjelih pixela u binarnoj matrici slike
% Ulazni parametri  -> image : slika u rgb_formatu
% Izlazni parametri -> nBlack : broj crnih
%                   -> nWhite : broj bijelih
    
    Image  = rgb2gray(image); % pretvori sliku u gray format
    BW     = im2bw(Image);    % odredi binarne znacajke
    
    % odredi broj crnih do su 1
    nBlack = sum(BW(:));
    nWhite = numel(BW) - nBlack;
end
%end-----------------------------------------------------------------------

