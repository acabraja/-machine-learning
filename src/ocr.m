function [letters,number] = ocr(imagen)
% Funcija koja pokusava prepoznati slova i brojke sa slike
% Ulazni parametri -> image : slika u rgb formatu
% Izlazni parametri -> letters : broj slova
%                   -> number  : broj brojeva

    % ako je u boji konvertiraj u crno-bjelo
    if size(imagen,3)==3 % ako je ovo onda je crno-bjela
        imagen=rgb2gray(imagen);
    end

    % konvertiraj u BW
    threshold = graythresh(imagen);
    imagen =~im2bw(imagen,threshold);

    % Obrise sve objekte manje od 30 pixela
    imagen = bwareaopen(imagen,30);

    %Inicijalizacija varijabli
    word=[ ];
    re=imagen;

    % ucitaj template
    %load templates
    global templates
    load templates
    % zbroj znakova u testnom skupu
    num_letras=size(templates,2);

    while 1
        % Analiza svake prepoznate rijeci
        [fl,re]=lines(re);
        imgn=fl;
        [L,Ne] = bwlabel(imgn);    
        for n=1:Ne
            [r,c] = find(L==n);
            % izdvoji slovo
            n1=imgn(min(r):max(r),min(c):max(c));  
            % reskaliraj znak tako da se slaže sa testnim velicinam
            img_r=imresize(n1,[42 24]);
            % prebaci iz slike u znak
            letter=read_letter(img_r,num_letras);
            % spoji u rjec
            word=[word letter];
        end
        
        % uvjet za brojanje slova
        number = 0;
        letters = 0;
        for i=1:length(word)
            if(strcmp(word(i),'0') || ...
                    strcmp(word(i),'1') || strcmp(word(i),'2') || ...
                    strcmp(word(i),'3') || strcmp(word(i),'4') || ...
                    strcmp(word(i),'5') || strcmp(word(i),'6') || ...
                    strcmp(word(i),'7') || strcmp(word(i),'8') || ...
                    strcmp(word(i),'9'))
                number = number + 1;
            else
                letters = letters + 1;
            end
        end
        % Clear 'word' variable
        word=[ ];
    
        %*When the sentences finish, breaks the loop
        if isempty(re)  %See variable 're' in Fcn 'lines'
            break
        end    
    end
end
%end-----------------------------------------------------------------------