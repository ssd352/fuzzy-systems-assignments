function [ y ] = put_mem_func( x, params )
% params
a = params(1:end / 2);
b = params(end / 2 + 1:end);
    y = interp1(a, b, x, 'spline', 0);
% cf = fit(a, b, 'linearinterp');
% y = feval(cf, x);
% figure, plot(x, y);
% pause
for cnt = 1:length(x)
    if (x(cnt) < a(1) || x(cnt) > a(end))
        y(cnt) = 0;
    % y
    elseif (isnan(y(cnt)))
    %     y
        y(cnt) = 0;    
    elseif y(cnt) <= 0
    %     y
        y(cnt) = 0;
    elseif y(cnt) >= 1
    %     y
        y(cnt) = 1;
    end
end
end

