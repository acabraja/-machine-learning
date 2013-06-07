function [ nBlack, nWhite ] = bw( image )
    Image  = rgb2gray(image);
    BW     = im2bw(Image);
    nBlack = sum(BW(:));
    nWhite = numel(BW) - nBlack;
end

