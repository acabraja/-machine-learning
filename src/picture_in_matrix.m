% Vraca sliku u obliku matrice citanjem pomocu imread
% u sucaju potrebe za analizom matrice konverirati u double
% vraca i crno bjelu sliku kao drugi argument 

function [ standard_format, gray_format ] = picture_in_matrix(name, set, ext)
    full_name = '../static/test-set/' + set + '/' + name + '.' + ext;
    standard_format = imread(full_name, ext);
    gray_format = rgb2gray(standard_format);
end
 