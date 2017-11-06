% clc
% clearvars
% close all
%%
function [err1, err2, err12] = sugeno_yasukawa(x11, x12, x21, x22, testData, func, showfigs)
% np = 400;
% percentile = 1;
% func = @rotary_sinc;
% func = @saddle;
% x11 = [-rand(np / 4, 1), -rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
y11 = func(x11(:, 1), x11(:, 2));
% x12 = [-rand(np / 4, 1), rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
y12 = func(x12(:, 1), x12(:, 2));
% x21 = [rand(np / 4, 1), -rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
y21 = func(x21(:, 1), x21(:, 2));
% x22 = [rand(np / 4, 1), rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
y22 = func(x22(:, 1), x22(:, 2));
%%
% p11 = multipolyfit(x11, y11);
% p12 = multipolyfit(x12, y12);
% p21 = multipolyfit(x21, y21);
% p22 = multipolyfit(x22, y22);
% %%
% st = newfis('model', 'sugeno', 'min', 'max', 'prod', 'max', 'wtaver');
% % st = addvar(st, 'output', 'y', [-inf, inf]);  
% st = addvar(st, 'output', 'y', [-10, 10]);
% 
% for cnt = 1:4
% 
% %     st = addvar(st, 'input', ['x', num2str(cnt)], [-inf, inf]);
% st = addvar(st, 'input', ['x', num2str(cnt)], [-1, 1]);
%     st = addmf(st, 'input', cnt, 'all', 'trapmf',...
%         [-inf, -inf, inf, inf]);   
% end
% %%
% st = addmf(st, 'input', 1, 'small', 'trapmf',...
%         [-inf, -inf, -1, percentile]);
% st = addmf(st, 'input', 1, 'big', 'trapmf',...
%     [-percentile, 1, inf, inf]);
% 
% st = addmf(st, 'input', 2, 'small', 'trapmf',...
%     [-inf, -inf, -1, percentile]);
% st = addmf(st, 'input', 2, 'big', 'trapmf',...
%     [-percentile, 1, inf, inf]);
% 
% st1 = addmf(st, 'output', 1, '11', 'linear',...
%         p11);
% st1 = addmf(st1, 'output', 1, '12', 'linear',...
%         p12);
% 
% st1 = addmf(st1, 'output', 1, '21', 'linear',...
%     	p21);
% st1 = addmf(st1, 'output', 1, '22', 'linear',...
%         p22);
%    
% st1 = addrule(st1, [2, 2, 1, 1, 1, 1, 1]);
% st1 = addrule(st1, [2, 3, 1, 1, 2, 1, 1]);
% st1 = addrule(st1, [3, 2, 1, 1, 3, 1, 1]);
% st1 = addrule(st1, [3, 3, 1, 1, 4, 1, 1]);
% h = figure; gensurf(st1, [1, 2], 1), shading interp; colorbar;
% hgsave(['ts', num2str(h)]);
% %%
% X1m = [x11; x12];
% X1p = [x21; x22];
% Y1m = [y11; y12];
% Y1p = [y21; y22];
% p1m = multipolyfit(X1m, Y1m);
% p1p = multipolyfit(X1p, Y1p);
% 
% st2 = addmf(st, 'output', 1, '11', 'linear',...
%         p1m);
% st2 = addmf(st2, 'output', 1, '12', 'linear',...
%         p1p);
%    
% st2 = addrule(st2, [2, 1, 1, 1, 1, 1, 1]);
% st2 = addrule(st2, [3, 1, 1, 1, 2, 1, 1]);
% h = figure; gensurf(st2, [1, 2], 1), shading interp; colorbar;
% hgsave(['ts', num2str(h)]);
% %%
% X2m = [x11; x21];
% X2p = [x12; x22];
% Y2m = [y11; y21];
% Y2p = [y12; y22];
% p2m = multipolyfit(X2m, Y2m);
% p2p = multipolyfit(X2p, Y2p);
% 
% st3 = addmf(st, 'output', 1, '11', 'linear',...
%         p2m);
% st3 = addmf(st3, 'output', 1, '12', 'linear',...
%         p2p);
%    
% st3 = addrule(st3, [1, 2, 1, 1, 1, 1, 1]);
% st3 = addrule(st3, [1, 3, 1, 1, 2, 1, 1]);
% h = figure; gensurf(st3, [1, 2], 1), shading interp; colorbar;
% hgsave(['ts', num2str(h)]);
%%
% X = 2 * rand(np, 4) - 1;
% Y = rotary_sinc(X(:, 1), X(:, 2));
X = [x11; x12; x21; x22];
Y = [y11; y12; y21; y22];
% rng = [-1, 1]; %range
% ndat = size(X, 1); %np   
% ndim = size(X, 2); %4
% p = multipolyfit(X, Y);
% st4 = addmf(st, 'output', 1, '11', 'linear',...
%         p);
% st4 = addrule(st4, [1, 1, 1, 1, 1, 1, 1]);
% h = figure; gensurf(st4, [1, 2], 1), shading interp; colorbar;
% hgsave(['ts', num2str(h)]);
%%
% no_test = 500;
% testData = 2 * rand(no_test, 4) - 1;
targetData = func(testData(:, 1), testData(:, 2));
% out_fis1 = evalfis(testData, st1);
% out_fis2 = evalfis(testData, st2);
% out_fis3 = evalfis(testData, st3);
% out_fis4 = evalfis(testData, st4);
% rms((targetData - out_fis1) ./ targetData)
% rms((targetData - out_fis2) ./ targetData)
% rms((targetData - out_fis3) ./ targetData)
% rms((targetData - out_fis4) ./ targetData)
%%
% Sugeno Yasukawa
options = [2;	% exponent for the partition matrix U
		100;	% max. number of iteration
		1e-5;	% min. amount of improvement
		0];
min_no_clusters = 2;
[min_center, min_U, ~] = fcm(Y, min_no_clusters, options);
min_obj_fcn = sum(sum((min_U.^ 2) .* (distfcm(min_center, Y) .^ 2))) - sum(sum((min_center - mean(Y)).^ 2));
for no_clusters = 3:100
    [center, U, ~] = fcm(Y, no_clusters, options);
    obj_fcn = sum(sum((U .^ 2) .* (distfcm(center, Y) .^ 2))) - sum(sum((center - mean(Y)).^ 2));
    if (obj_fcn >= min_obj_fcn)
        break;
    else
        min_no_clusters = no_clusters;
%         min_center = center;
        min_U = U;
        min_obj_fcn = obj_fcn;
    end
end
%%
st = newfis('model', 'mamdani', 'min', 'max', 'min', 'max', 'centroid');
% st = addvar(st, 'output', 'y', [-inf, inf]);  
st = addvar(st, 'output', 'y', [-10, 10]);

for cnt = 1:4

%     st = addvar(st, 'input', ['x', num2str(cnt)], [-inf, inf]);
st = addvar(st, 'input', ['x', num2str(cnt)], [-1, 1]);
    st = addmf(st, 'input', cnt, 'all', 'trapmf',...
        [-inf, -inf, inf, inf]);   
end
%%
for cnt_cluster = 1:min_no_clusters
    memfunc = [Y, min_U(cnt_cluster, :).'];
    memfunc = sortrows(memfunc);
    
    if (showfigs)
    yplotfig = figure; plot(memfunc(:, 1), memfunc(:, 2));
    xlabel('y');
    ylabel(['output cluster membership function #', num2str(cnt_cluster)]);
    hgsave(['ycl', num2str(cnt_cluster), 'plot', num2str(yplotfig)]);
    end
    
    tmp = [memfunc(:, 1); memfunc(:, 2)].';
%     size(tmp)
    %output_mem_func{cnt_cluster} = @(x, ~) interp1(memfunc(:, 1), memfunc(:, 2), x);
    st = addmf(st, 'output', 1, ['outmf', num2str(cnt_cluster)], 'put_mem_func', tmp);  
    
    for cnt_dim = 1:4
%         size(min_U, 2)
        memfunc = [X(:, cnt_dim), min_U(cnt_cluster, :).'];
        memfunc = [-1.0000001, 0; sortrows(memfunc); 1.0000001, 0];
        tmp = [memfunc(:, 1); memfunc(:, 2)].';
%         size(tmp)
        %input_mem_func{cnt_dim, cnt_cluster} = @(x, ~) interp1(memfunc(:, 1), memfunc(:, 2), x);
        st = addmf(st, 'input', cnt_dim, ['inmf', num2str(cnt_cluster)],  'put_mem_func', tmp);
        if showfigs
        xplotfig = figure; plot(memfunc(:, 1), memfunc(:, 2));
        xlabel(['x', num2str(cnt_dim)]);
        ylabel(['output cluster membership function #', num2str(cnt_cluster)]);
        hgsave(['x', num2str(cnt_dim), 'cl',  num2str(cnt_cluster), 'plot', num2str(xplotfig)]);
        end
%         scatterfig = figure; scatter(memfunc(:, 1), memfunc(:, 2));
%         xlabel(['x', num2str(cnt_dim)]);
%         ylabel(['output cluster membership function #', num2str(cnt_cluster)]);
%         rule = ones(1, 7);
%         rule(cnt_dim) = cnt_cluster + 1;
%         rule(5) = cnt_cluster;
%         if (cnt_dim == 1 || cnt_dim == 2)
% %             st = addrule(st, rule);
%         end
    end
%     st = addrule(st, [cnt_cluster + 1, cnt_cluster + 1, 0 + 1, 0 + 1, cnt_cluster, 1, 1]);
end
st1 = st;
st2 = st;
st3 = st;
for cnt_cluster = 1:min_no_clusters
    for cnt_dim = 1:4
        rule = ones(1, 7);
        rule(cnt_dim) = cnt_cluster + 1;
        rule(5) = cnt_cluster;
        if (cnt_dim == 1)
             st1 = addrule(st1, rule);
        end
        if (cnt_dim == 2)
             st2 = addrule(st2, rule);
        end
    end
    st3 = addrule(st3, [cnt_cluster + 1, cnt_cluster + 1, 0 + 1, 0 + 1, cnt_cluster, 1, 1]);
end

out_fis_sy1 = evalfis(testData, st1, 8000);
out_fis_sy2 = evalfis(testData, st2, 8000);
out_fis_sy3 = evalfis(testData, st3, 8000);

if showfigs
sysurffig = figure; gensurf(st1, [1, 2], 1);shading interp; colorbar;
hgsave(['sysurf', num2str(sysurffig), '.fig']);
sysurffig = figure; gensurf(st2, [1, 2], 1);shading interp; colorbar;
hgsave(['sysurf', num2str(sysurffig), '.fig']);
sysurffig = figure; gensurf(st3, [1, 2], 1);shading interp; colorbar;
hgsave(['sysurf', num2str(sysurffig), '.fig']);
end


err1 = rms((targetData - out_fis_sy1));
err2 = rms((targetData - out_fis_sy2));
err12 = rms((targetData - out_fis_sy3));
% ruleview(st1)
% ruleview(st2)
% ruleview(st3)
% err = rms((targetData - out_fis_sy) ./ targetData);
end