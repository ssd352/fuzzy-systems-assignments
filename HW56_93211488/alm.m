% clc
% clearvars
% close all
%%
function [err, err1, err2, err12] = alm(x11, x12, x21, x22, testData, func, showfigs)
% np = 400;
percentile = 0.05;
% func = @rotary_sinc;
% func = @saddle;
y11 = func(x11(:, 1), x11(:, 2));
y12 = func(x12(:, 1), x12(:, 2));
y21 = func(x21(:, 1), x21(:, 2));
y22 = func(x22(:, 1), x22(:, 2));

% no_test = 10;
% testData = 2 * rand(no_test, 4) - 1;
no_test = size(testData, 1);
targetData = func(testData(:, 1), testData(:, 2));
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

st = addmf(st, 'input', 1, 'small', 'trapmf',...
        [-inf, -inf, -percentile, percentile]);
st = addmf(st, 'input', 1, 'big', 'trapmf',...
    [-percentile, percentile, inf, inf]);

st = addmf(st, 'input', 2, 'small', 'trapmf',...
    [-inf, -inf, -percentile, percentile]);
st = addmf(st, 'input', 2, 'big', 'trapmf',...
    [-percentile, percentile, inf, inf]);

%%
%IDS
rngX1 = cell(2, 2, 4);
np1 = cell(2, 2, 4);
sp1 = cell(2, 2, 4);

[rngX1{1, 1, 1}, np1{1, 1, 1}, sp1{1, 1, 1}] = ids(x11(:, 1), y11, showfigs);
[rngX1{1, 1, 2}, np1{1, 1, 2}, sp1{1, 1, 2}] = ids(x11(:, 2), y11, showfigs);
[rngX1{1, 1, 3}, np1{1, 1, 3}, sp1{1, 1, 3}] = ids(x11(:, 3), y11, showfigs);
[rngX1{1, 1, 4}, np1{1, 1, 4}, sp1{1, 1, 4}] = ids(x11(:, 4), y11, showfigs);

[rngX1{1, 2, 1}, np1{1, 2, 1}, sp1{1, 2, 1}] = ids(x12(:, 1), y12, showfigs);
[rngX1{1, 2, 2}, np1{1, 2, 2}, sp1{1, 2, 2}] = ids(x12(:, 2), y12, showfigs);
[rngX1{1, 2, 3}, np1{1, 2, 3}, sp1{1, 2, 3}] = ids(x12(:, 3), y12, showfigs);
[rngX1{1, 2, 4}, np1{1, 2, 4}, sp1{1, 2, 4}] = ids(x12(:, 4), y12, showfigs);

[rngX1{2, 1, 1}, np1{2, 1, 1}, sp1{2, 1, 1}] = ids(x21(:, 1), y21, showfigs);
[rngX1{2, 1, 2}, np1{2, 1, 2}, sp1{2, 1, 2}] = ids(x21(:, 2), y21, showfigs);
[rngX1{2, 1, 3}, np1{2, 1, 3}, sp1{2, 1, 3}] = ids(x21(:, 3), y21, showfigs);
[rngX1{2, 1, 4}, np1{2, 1, 4}, sp1{2, 1, 4}] = ids(x21(:, 4), y21, showfigs);

[rngX1{2, 2, 1}, np1{2, 2, 1}, sp1{2, 2, 1}] = ids(x22(:, 1), y22, showfigs);
[rngX1{2, 2, 2}, np1{2, 2, 2}, sp1{2, 2, 2}] = ids(x22(:, 2), y22, showfigs);
[rngX1{2, 2, 3}, np1{2, 2, 3}, sp1{2, 2, 3}] = ids(x22(:, 3), y22, showfigs);
[rngX1{2, 2, 4}, np1{2, 2, 4}, sp1{2, 2, 4}] = ids(x22(:, 4), y22, showfigs);

%np_tst = cell(2, 2);
%sp_tst = cell(2, 2);
out_fis1 = zeros(no_test, 1);
out_fis2 = zeros(no_test, 1);
out_fis3 = zeros(no_test, 1);
out_fis4 = zeros(no_test, 1);

for cnt = 1:no_test
    st1 = st;
    for ndim = 1:2
        for x1 = 1:2
            for x2 = 1:2
%                 testData(cnt, ndim) < rngX1{x1, x2, ndim}(1)
%                 testData(cnt, ndim) > rngX1{x1, x2, ndim}(end)
                np_tst = interp1(rngX1{x1, x2, ndim}, np1{x1, x2, ndim}, testData(cnt, ndim));
                sp_tst = interp1(rngX1{x1, x2, ndim}, sp1{x1, x2, ndim}, testData(cnt, ndim));    
                if ~isnan(np_tst) && ~isnan(sp_tst)
                    st1 = addmf(st1, 'output', 1, num2str(getfis(st1, 'numoutputmfs') + 1), 'constant', np_tst);
        %             st1 = addrule(st1, [x1 + 1, x2 + 1, 1, 1, end, sp_tst, 1]);
                    st1 = addrule(st1, [x1 + 1, x2 + 1, 1, 1, getfis(st1, 'numoutputmfs'), sp_tst, 1]);
                end
            end
        end
    end
    out_fis1(cnt) = evalfis(testData(cnt, :), st1); 
end
clearvars st1
% getfis(st, 'numoutputmfs')
% figure, gensurf(st1, [1, 2], 1), shading interp; colorbar;
% out_fis1 = evalfis(testData, st1);
% rms((targetData - out_fis1) ./ targetData)
%%
x1m = [x11; x12];
x1p = [x21; x22];
y1m = [y11; y12];
y1p = [y21; y22];
%%
% IDS
rngX2 = cell(2, 1, 4);
np2 = cell(2, 1, 4);
sp2 = cell(2, 1, 4);

[rngX2{1, 1, 1}, np2{1, 1, 1}, sp2{1, 1, 1}] = ids(x1m(:, 1), y1m, showfigs);
[rngX2{1, 1, 2}, np2{1, 1, 2}, sp2{1, 1, 2}] = ids(x1m(:, 2), y1m, showfigs);
[rngX2{1, 1, 3}, np2{1, 1, 3}, sp2{1, 1, 3}] = ids(x1m(:, 3), y1m, showfigs);
[rngX2{1, 1, 4}, np2{1, 1, 4}, sp2{1, 1, 4}] = ids(x1m(:, 4), y1m, showfigs);

[rngX2{2, 1, 1}, np2{2, 1, 1}, sp2{2, 1, 1}] = ids(x1p(:, 1), y1p, showfigs);
[rngX2{2, 1, 2}, np2{2, 1, 2}, sp2{2, 1, 2}] = ids(x1p(:, 2), y1p, showfigs);
[rngX2{2, 1, 3}, np2{2, 1, 3}, sp2{2, 1, 3}] = ids(x1p(:, 3), y1p, showfigs);
[rngX2{2, 1, 4}, np2{2, 1, 4}, sp2{2, 1, 4}] = ids(x1p(:, 4), y1p, showfigs);


for cnt = 1:no_test
    st2 = st;
    for ndim = 1:2
        for x1 = 1:2
            for x2 = 1:1
                np_tst = interp1(rngX2{x1, x2, ndim}, np2{x1, x2, ndim}, testData(cnt, ndim)); 
                sp_tst = interp1(rngX2{x1, x2, ndim}, sp2{x1, x2, ndim}, testData(cnt, ndim));    
                if ~isnan(np_tst) && ~isnan(sp_tst)
                    st2 = addmf(st2, 'output', 1, num2str(getfis(st2, 'numoutputmfs') + 1), 'constant', np_tst);
        %             st1 = addrule(st1, [x1 + 1, x2 + 1, 1, 1, end, sp_tst, 1]);
                    st2 = addrule(st2, [x1 + 1, 1, 1, 1, getfis(st2, 'numoutputmfs'), sp_tst, 1]);
                end
            end
        end
    end
        out_fis2(cnt) = evalfis(testData(cnt, :), st2);
end

% figure, gensurf(st2, [1, 2], 1), shading interp; colorbar;

%%
x2m = [x11; x21];
x2p = [x12; x22];
y2m = [y11; y21];
y2p = [y12; y22];
%%
% IDS
rngX3 = cell(1, 2, 4);
np3 = cell(1, 2, 4);
sp3 = cell(1, 2, 4);

[rngX3{1, 1, 1}, np3{1, 1, 1}, sp3{1, 1, 1}] = ids(x2m(:, 1), y2m, showfigs);
[rngX3{1, 1, 2}, np3{1, 1, 2}, sp3{1, 1, 2}] = ids(x2m(:, 2), y2m, showfigs);
[rngX3{1, 1, 3}, np3{1, 1, 3}, sp3{1, 1, 3}] = ids(x2m(:, 3), y2m, showfigs);
[rngX3{1, 1, 4}, np3{1, 1, 4}, sp3{1, 1, 4}] = ids(x2m(:, 4), y2m, showfigs);

[rngX3{1, 2, 1}, np3{1, 2, 1}, sp3{1, 2, 1}] = ids(x2p(:, 1), y2p, showfigs);
[rngX3{1, 2, 2}, np3{1, 2, 2}, sp3{1, 2, 2}] = ids(x2p(:, 2), y2p, showfigs);
[rngX3{1, 2, 3}, np3{1, 2, 3}, sp3{1, 2, 3}] = ids(x2p(:, 3), y2p, showfigs);
[rngX3{1, 2, 4}, np3{1, 2, 4}, sp3{1, 2, 4}] = ids(x2p(:, 4), y2p, showfigs);

for cnt = 1:no_test
    st3 = st;
    for ndim = 1:2
        for x1 = 1:1
            for x2 = 1:2
                np_tst = interp1(rngX3{x1, x2, ndim}, np3{x1, x2, ndim}, testData(cnt, ndim)); 
                sp_tst = interp1(rngX3{x1, x2, ndim}, sp3{x1, x2, ndim}, testData(cnt, ndim));    
                if ~isnan(np_tst) && ~isnan(sp_tst)
                    st3 = addmf(st3, 'output', 1, num2str(getfis(st3, 'numoutputmfs') + 1), 'constant', np_tst);
        %             st1 = addrule(st1, [x1 + 1, x2 + 1, 1, 1, end, sp_tst, 1]);
                    st3 = addrule(st3, [1, x2 + 1, 1, 1, getfis(st3, 'numoutputmfs'), sp_tst, 1]);
                end
            end
        end
    end
        out_fis3(cnt) = evalfis(testData(cnt, :), st3);
end

% figure, gensurf(st3, [1, 2], 1), shading interp; colorbar;

%%
% X = 2 * rand(np, 4) - 1;
% Y = rotary_sinc(X(:, 1), X(:, 2));
x = [x11; x12; x21; x22];
y = [y11; y12; y21; y22];
% rng = [-1, 1]; %range
% ndat = size(x, 1); %np   
% ndim = size(x, 2); %4

%%
%IDS
rngX4 = cell(4);
np4 = cell(4);
sp4 = cell(4);

[rngX4{1}, np4{1}, sp4{1}] = ids(x(:, 1), y, showfigs);
[rngX4{2}, np4{2}, sp4{2}] = ids(x(:, 2), y, showfigs);
[rngX4{3}, np4{3}, sp4{3}] = ids(x(:, 3), y, showfigs);
[rngX4{4}, np4{4}, sp4{4}] = ids(x(:, 4), y, showfigs);


for cnt = 1:no_test
    st4 = st;
    for ndim = 1:2
        
                np_tst = interp1(rngX4{ndim}, np4{ndim}, testData(cnt, ndim)); 
                sp_tst = interp1(rngX4{ndim}, sp4{ndim}, testData(cnt, ndim));    
                if ~isnan(np_tst) && ~isnan(sp_tst)
                    st4 = addmf(st4, 'output', 1, num2str(getfis(st4, 'numoutputmfs') + 1), 'constant', np_tst);
        %             st1 = addrule(st1, [x1 + 1, x2 + 1, 1, 1, end, sp_tst, 1]);
                    st4 = addrule(st4, [1, 1, 1, 1, getfis(st4, 'numoutputmfs'), sp_tst, 1]);
                end
    end
        out_fis4(cnt) = evalfis(testData(cnt, :), st4);
end

% figure, gensurf(st4, [1, 2], 1), shading interp; colorbar;

%%
% out_fis1 = evalfis(testData, st1);
% out_fis2 = evalfis(testData, st2);
% out_fis3 = evalfis(testData, st3);
% out_fis4 = evalfis(testData, st4);
err12 = rms((targetData - out_fis1));
err1 = rms((targetData - out_fis2));
err2 = rms((targetData - out_fis3));
err = rms((targetData - out_fis4));
% err12 = rms((targetData - out_fis1) ./ targetData);
% err1 = rms((targetData - out_fis2) ./ targetData);
% err2 = rms((targetData - out_fis3) ./ targetData);
% err = rms((targetData - out_fis4) ./ targetData);
% output = evalfis(X, st);
% rms(Y - output)
% std(Y - output)
% max(abs(Y - output))
% fvu = (rms(Y - output) .^ 2) / var(Y);
end