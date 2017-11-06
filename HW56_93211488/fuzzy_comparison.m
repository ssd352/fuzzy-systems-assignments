clc
clearvars
close all
%%
np = 400;
showfigs = true;
% func = @rotary_sinc;
% func = @saddle;
x11 = [-rand(np / 4, 1), -rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
x12 = [-rand(np / 4, 1), rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
x21 = [rand(np / 4, 1), -rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];
x22 = [rand(np / 4, 1), rand(np / 4, 1), 2 * rand(np / 4, 2) - 1];

no_test = 400;
testData = 2 * rand(no_test, 4) - 1;
if showfigs
figure; ezsurf(@saddle, [-1, 1, -1, 1]);shading interp; colorbar;
hgsave('saddle function');
end
[sadtserr, sadtserr1, sadtserr2, sadtserr12] = takagi_sugeno(x11, x12, x21, x22, testData, @saddle, 1, showfigs)
[sadsyerr1, sadsyerr2, sadsyerr12] = sugeno_yasukawa(x11, x12, x21, x22, testData, @saddle, showfigs)
[sadalmerr, sadalmerr1, sadalmerr2, sadalmerr12] = alm(x11, x12, x21, x22, testData, @saddle, showfigs)

if showfigs
figure; ezsurf(@rotary_sinc, [-1, 1, -1, 1]);shading interp; colorbar;
hgsave('sinc function');
end
[rstserr, rstserr1, rstserr2, rstserr12] = takagi_sugeno(x11, x12, x21, x22, testData, @rotary_sinc, 0.05, showfigs)
[rssyerr1, rssyerr2, rssyerr12] = sugeno_yasukawa(x11, x12, x21, x22, testData, @rotary_sinc, showfigs)
[rsalmerr, rsalmerr1, rsalmerr2, rsalmerr12] = alm(x11, x12, x21, x22, testData, @rotary_sinc, showfigs)