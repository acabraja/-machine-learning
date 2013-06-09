% Skripta za pokretanje svih funkcija za testiranje i kreiranje rezultata

% ciscenje i zatvaranje postojecih radnji
close all;
clear all;

% Pocetna pitanja
control = input('Za ucitavanje iz baze upisite 1, a za koristenje ucitanih podataka 0: ');
if (control == 1)
    % Ucitavanje podataka iz baze
    fprintf('Ucitavanje podataka iz baze ....\n');
    % fprintf('Podatke unosite sa navodnicima\n');
    % host = input('Unesite host za bazu: ');
    % user = input('Unesite username za bazu: ');
    % pass = input('Unesite password za bazu: ');
    % db = input('Unesite ime baze: ');
    %conn = db_class(host,user,pass,db);
    conn = db_class('localhost','root','0981655447','strojno');
    query = 'select * from tablice';
    db_data = conn.db_query(query);
    save ('sql_data','db_data');
    fprintf('Podaci su ucitani iz baze i nalaze se u sql_data.mat\n');
    fprintf('Za naknadno koristenje ucitati sa load sql_data\n');
    fprintf('Za nastavak pritisnite enter............\n');
    pause;
else
    load sql_data;
end

% Ucitavanje znacajki
fprintf('Detekcija znacajki iz slika .........\n');
if (control == 1)
    [X,y] = create_feature(db_data);
    save ('X.mat','X'); save('y.mat','y');
else
    load X; load y;
end
fprintf('Podaci su ucitani i spremnjeni u .mat datoteke');
fprintf('U sustavu se nelazi %d primjera svaki repreznetiran sa %d znacajki\n',size(X,1),size(X,2));
figure('name','Neki zanimljivi odnosi znacajki')
subplot(2,2,1)
xlabel('broj slova na slici');
ylabel('broj brojeva na slici');
plotData(X(:,3:4),y);
subplot(2,2,2)
xlabel('omjer dimenzija');
ylabel('broj svijetlih pixela');
plotData(X(:,[6,12]),y);
subplot(2,2,3);
xlabel('broj crvenih pixela');
ylabel('broj zelenih pixela');
plotData(X(:,[9,10]),y);
subplot(2,2,4);
xlabel('broj svijetlih pixela');
ylabel('broj slova na slici');
plotData(X(:,[3,12]),y);
fprintf('Za nastavak pritisnite enter..........\n');
pause;

% 1. verzija neuronske mreze
% Slucajno se bira skup za validaciju i skup za testiranje
fprintf('Testiranje neuronske mreze : 1.Verzija\n')
neuralNetwork
fprintf('Za nastavak pritisnite enter...........\n');
pause;
%2. verzija neuronske mreze 
% k-fold cross validacija 
% TODO treba implementirati

%ostala testiranja
%testiranje na 2 po 2 featura radi nekih korisnih podataka
fprintf('Testiranje linearnog regresijskog modela\n')
prvi_drugi = gradient(X(:,1:2),y)
treci_cetvrti = gradient(X(:,3:4),y)
peti_sesti = gradient(X(:,5:6),y)
sedmi_osmi = gradient(X(:,7:8),y)
deveti_deseti = gradient(X(:,9:10),y)
jed_dvan = gradient(X(:,11:12),y)
fprintf('Za kraj pritisnite enter\n');
pause;
close all;
%Testiranje ostalo
%