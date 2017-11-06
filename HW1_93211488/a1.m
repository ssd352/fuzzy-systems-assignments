clc
close all
clear all
%%
x = -2:.01:2;
a = -2:.01:1;
b = -1:.01:2;
amf = gaussmf(x, [0.25, -0.5]);
bmf = gaussmf(x, [0.25, +0.5]);

figure
plot(x, amf, x, bmf);
legend('Af', 'Bf');
ylim([-.05, 1.05]);
savefig('AB.fig');

%%
lhs1 = min(1 - amf, 1 - bmf);
rhs1 = 1 - max(amf, bmf);

figure
plot(x, lhs1);
ylim([-.05, 1.05]);
title('~Af && ~Bf');
savefig('notAandnotB.fig');

figure
plot(x, rhs1);
ylim([-.05, 1.05]);
title('~(Af || Bf)');
savefig('notAorB.fig');

%%
lhs = max(1 - amf, 1 - bmf);
rhs = 1 - min(amf, bmf);

figure
plot(x, lhs);
ylim([0.85, 1.05]);
title('~Af || ~Bf');
savefig('notAornotB.fig');

figure
plot(x, rhs);
ylim([0.85, 1.05]);
title('~(Af && Bf)');
savefig('notAandB.fig');