function [ a ] = multipolyfit( x, y )
X = [x(:, 1:2), ones(size(x, 1), 1)];
% X = [ones(size(x, 1), 1), x];
% X = [x, ones(size(x, 1), 1)];
tmp = X \ y;
a = [tmp(1:2); 0; 0; tmp(end)];
% tmp = pinv(X) * y;
% a = tmp;
end

