function [Theta, result] = make_model(L,db_data)
%Adaboost algoritam koji za ulazni parametar L stvara L slabih klasifikatora da bi dobio jaki klasifikator.
%result je broj netočno klasificiranih primjera iz skupa za učenje

%load sql_data.mat
feature_size = 8; 
%db_data1 = zeros(size(db_data),1);
for j=1:length(db_data)
    r = randi([1,length(db_data)],1);
    db_data1(j,:) = db_data(r,:);
end

%greska svakog klasifikatora
error = zeros(L,1);
%Matrica u kojoj su spremljeni theta vektori svakog klasifikatora
Theta = zeros(feature_size,L);

%--------------------------------------------------------------------
%prvi klasifikator
[X,y] = create_feature(db_data1);
X = [ones(size(X,1),1), X];
[theta,J] = gradient(X,y);
m = nnz(y);
l = length(y) - m;

%postavljanje tezina
w = y;
for k=1:length(y)
    if (y(k) == 1)
        w(k) = 1/(2*m);
    elseif (y(k) == 0) 
        w(k) = 1/(2*l);
    end
end

w = repmat(w,1,L);

%racunanje greske za prvi klasifikator
for i=1:length(db_data1)
   error(1) = error(1) + w(i) * (abs((sigmoid(X(i,:) * theta)) - y(i))); 
end

S = predict(theta,X);
S = S-y;

%update-anje tezina 2.og klasifikatora
%mijenja i-tu tezinu ako je x_i klasificiran korektno
for i=1:length(y)
    if (S(i) == 0)
        w(i,2) = w(i,1)*(error(1)/(1-error(1)));
    end
end

Theta(:,1) = theta';

%------------------------------------------------------------------------

%Isti proces kao za prvi klasifikator samo za ostalih L-1
%Napomena: za i==L ne vršimo update tezina 
for i=2:L
 
    [X,y] = create_feature(db_data1);
    X = [ones(size(X,1),1), X];
    [theta,J] = gradient(X,y);
    
    if(i ~= L)
        for k=1:length(db_data1)
            error(i) = error(i) + w(k) * abs(sigmoid((X(k,:) * theta)) - y(k));
        end
        
        S = predict(theta,X);
        S = S-y;
        
        for k=1:length(y)
            if (S(k) == 0)
                w(k,i+1) = w(k,i)*(error(i)/(1-error(i)));
            end
        end
    else
        for k=1:length(db_data1)
            error(i) = error(i) + w(k) * abs(sigmoid((X(k,:) * theta)) - y(k));
        end
    end
    
    Theta(:,i) = theta';
    
end

%alpha parametri potrebni za stvaranje "jakog" klasifikatora
alpha =  (1-error) ./ error;
alpha = log(alpha);

%izracun za vrijednosti iz db_data stvorenog klasifikatora
[X,y] = create_feature(db_data);
X = [ones(size(X,1),1), X];
rez = zeros(length(y),1);

for i=1:length(db_data1)
    sum1=0;
    sum2=0.5*sum(alpha);
    
    for j=1:L
        theta = Theta(:,j);
        sum1 = sum1+alpha(j)*abs(sigmoid((X(i,:) * theta)));
    end
    
    if (sum1 >= sum2) rez(i) = 1;
    else rez(i) = 0;
    end
end

result = bitxor(rez,y);
result = sum(result);

end
