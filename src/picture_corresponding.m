function x = picture_corresponding(image)
% Funkcija koja vraca broj pronadenih kutova na slici
% Kratki opis : na slikama gdje su slova s tablica u krupnom planu  puno
% vise detektira kutova nego kad se radi o slovima koji na necemu slicnom
% Ulazni parametri -> image : slika u rgb formatu
% Izlazni parametri -> x : broj detektiranih kutova
    
    I1 = rgb2gray(image);
    p = corner(I1);
    x = size(p,1);
end
%end-----------------------------------------------------------------------
