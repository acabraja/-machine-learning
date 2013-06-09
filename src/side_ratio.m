function ratio = side_ratio(image)
% Funnkcija koja vraca omjer stranica
% Ulazni parameri -> image : slika u rgb formatu
% Izlazni parametri -> ratio : omjer stranica

    I = rgb2gray(image);
    [x,y] = size(I);
    ratio = y/x;
end
%end-----------------------------------------------------------------------
