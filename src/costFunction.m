function [J, grad] = costFunction(theta, X, y, lambda)
%Racunanje funkcije greske

    m = length(y); 
    J = 0;
    grad = zeros(size(theta));

    pred = sigmoid(X*theta);
    reg = theta'*theta;
    reg = reg - theta(1)^2;
    reg = (lambda*reg)/(2*m);
    delta = y' *log(pred) + (1-y)'*log(1-pred);
    J = sum(delta);
    J = (-1*J)/m + reg;

    errMartix = sigmoid(X*theta) - y;
    grad(1) = 1/m * sum(errMartix.*X(:,1));
    for i = 2:size(theta)
        grad(i) = 1/m * sum(errMartix.*X(:,i)) + lambda/m * theta(i);
    end
end

