function x = picture_corresponding(image)
    I1 = rgb2gray(image);
    p = corner(I1);
    x = size(p,1);
end

