function [ standard_format, gray_format ] = picture_in_matrix(name, set, ext)
% Vraca sliku u obliku matrice citanjem pomocu imread
% u sucaju potrebe za analizom matrice konverirati u double
% vraca i crno bjelu sliku kao drugi argument 
% ulazni parametri:
%        name : tip cell id slike
%        set  : string koji govori o kojem se data set-u radi 
%            (za sada 'tablice')
%        ext  : extenzija slike cell tip pretvoren u char

    name = num2str(name{1});
    ext = char(ext);
    full_name = strcat('../static/test-set/',set, '/',name , '.' , ext);
    standard_format = imread(full_name, ext);
    gray_format = rgb2gray(standard_format);
end
 