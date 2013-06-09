
function g = sigmoid(z)
% aktivacijska funkcija sigmoid

    g = zeros(size(z));
    g = 1./(1+exp(-1.*z));
end
%end-----------------------------------------------------------------------
