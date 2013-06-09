function x = ratio_picture_center( image, margine)
% Funkcija koja se pozicionira na dio slike i trazi omjer bijelo/crno
% Ulazni parametri -> image : slika u rgb formatu
%                  -> margine : udaljenost od ruba postotak <0,0.5>
% Izlazni parametri -> x = omjer binarnih crnih i bijelih pixela

    [a,b,~] = size(image); % uzmi sirinu i visinu
    % Izrezi zeljeni dio slike
    crop = image(round(a*margine):round(a*(1-margine)),...
        round(b*margine):round(b*(1-margine)),:);
    
    % Vrati broj crnih i broj bjelih pixela
    [m,n] = bw(crop);
    
    % ako nema crnih pixela stavi da je to omjer 0 (gotovo nikada)
    if( m == 0)
        x = 0;
    else
        x = n/m; %bijelo/crno
    end
end
%end-----------------------------------------------------------------------
