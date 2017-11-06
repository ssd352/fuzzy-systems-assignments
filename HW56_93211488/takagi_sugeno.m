% clc
% clearvars
% close all
%%
% np = 100;

% func = @rotary_sinc;
% func = @saddle;
% x11 = [-rand(np / 4, 1), -rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
% x12 = [-rand(np / 4, 1), rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
% x21 = [rand(np / 4, 1), -rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
% x22 = [rand(np / 4, 1), rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
function [err, err1, err2, err12] = takagi_sugeno(x11, x12, x21, x22, testData, func, percentile, showfigs)
% percentile = 1;
y11 = func(x11(:, 1), x11(:, 2));
y12 = func(x12(:, 1), x12(:, 2));
y21 = func(x21(:, 1), x21(:, 2));
y22 = func(x22(:, 1), x22(:, 2));
%np = size(x11, 1) + size(x12, 1) + size(x21, 1) + size(x22, 1); 
%%
p11 = multipolyfit(x11, y11);
p12 = multipolyfit(x12, y12);
p21 = multipolyfit(x21, y21);
p22 = multipolyfit(x22, y22);
%%
st = newfis('model', 'sugeno', 'min', 'max', 'prod', 'max', 'wtaver');
% st = addvar(st, 'output', 'y', [-inf, inf]);  
st = addvar(st, 'output', 'y', [-10, 10]);

for cnt = 1:4

%     st = addvar(st, 'input', ['x', num2str(cnt)], [-inf, inf]);
st = addvar(st, 'input', ['x', num2str(cnt)], [-1, 1]);
    st = addmf(st, 'input', cnt, 'all', 'trapmf',...
        [-inf, -inf, inf, inf]);   
end
%%
st = addmf(st, 'input', 1, 'small', 'trapmf',...
        [-inf, -inf, -1, percentile]);
st = addmf(st, 'input', 1, 'big', 'trapmf',...
    [-percentile, 1, inf, inf]);

st = addmf(st, 'input', 2, 'small', 'trapmf',...
    [-inf, -inf, -1, percentile]);
st = addmf(st, 'input', 2, 'big', 'trapmf',...
    [-percentile, 1, inf, inf]);

st1 = addmf(st, 'output', 1, '11', 'linear',...
        p11);
st1 = addmf(st1, 'output', 1, '12', 'linear',...
        p12);

st1 = addmf(st1, 'output', 1, '21', 'linear',...
    	p21);
st1 = addmf(st1, 'output', 1, '22', 'linear',...
        p22);
   
st1 = addrule(st1, [2, 2, 1, 1, 1, 1, 1]);
st1 = addrule(st1, [2, 3, 1, 1, 2, 1, 1]);
st1 = addrule(st1, [3, 2, 1, 1, 3, 1, 1]);
st1 = addrule(st1, [3, 3, 1, 1, 4, 1, 1]);
if showfigs
h = figure; gensurf(st1, [1, 2], 1), shading interp; colorbar;
hgsave(['ts', num2str(h)]);
end
%%
X1m = [x11; x12];
X1p = [x21; x22];
Y1m = [y11; y12];
Y1p = [y21; y22];
p1m = multipolyfit(X1m, Y1m);
p1p = multipolyfit(X1p, Y1p);

st2 = addmf(st, 'output', 1, '11', 'linear',...
        p1m);
st2 = addmf(st2, 'output', 1, '12', 'linear',...
        p1p);
   
st2 = addrule(st2, [2, 1, 1, 1, 1, 1, 1]);
st2 = addrule(st2, [3, 1, 1, 1, 2, 1, 1]);
if showfigs
h = figure; gensurf(st2, [1, 2], 1), shading interp; colorbar;
hgsave(['ts', num2str(h)]);
end
%%
X2m = [x11; x21];
X2p = [x12; x22];
Y2m = [y11; y21];
Y2p = [y12; y22];
p2m = multipolyfit(X2m, Y2m);
p2p = multipolyfit(X2p, Y2p);

st3 = addmf(st, 'output', 1, '11', 'linear',...
        p2m);
st3 = addmf(st3, 'output', 1, '12', 'linear',...
        p2p);
   
st3 = addrule(st3, [1, 2, 1, 1, 1, 1, 1]);
st3 = addrule(st3, [1, 3, 1, 1, 2, 1, 1]);
if showfigs
h = figure; gensurf(st3, [1, 2], 1), shading interp; colorbar;
hgsave(['ts', num2str(h)]);
end
%%
% X = 2 * rand(np, 4) - 1;
% Y = rotary_sinc(X(:, 1), X(:, 2));
X = [x11; x12; x21; x22];
Y = [y11; y12; y21; y22];
% rng = [-1, 1]; %range
% ndat = size(X, 1); %np   
% ndim = size(X, 2); %4
p = multipolyfit(X, Y);
st4 = addmf(st, 'output', 1, '11', 'linear',...
        p);
st4 = addrule(st4, [1, 1, 1, 1, 1, 1, 1]);
if showfigs
h = figure; gensurf(st4, [1, 2], 1), shading interp; colorbar;
hgsave(['ts', num2str(h)]);
end
%%
% no_test = 500;
% testData = 2 * rand(no_test, 4) - 1;
% no_test = size(testData, 1);
targetData = func(testData(:, 1), testData(:, 2));
out_fis1 = evalfis(testData, st1);
out_fis2 = evalfis(testData, st2);
out_fis3 = evalfis(testData, st3);
out_fis4 = evalfis(testData, st4);
err12 = rms((targetData - out_fis1));
err1 = rms((targetData - out_fis2));
err2 = rms((targetData - out_fis3));
err = rms((targetData - out_fis4));

% err12 = rms((targetData - out_fis1) ./ targetData);
% err1 = rms((targetData - out_fis2) ./ targetData);
% err2 = rms((targetData - out_fis3) ./ targetData);
% err = rms((targetData - out_fis4) ./ targetData);
end