function ratio = side_ratio(image)
%Function that receives image in RGB format. It converges it into Grayscale format and then
%returns the ratio of its sides.

I = rgb2gray(image);

[x,y] = size(I);

ratio = y/x;

end
