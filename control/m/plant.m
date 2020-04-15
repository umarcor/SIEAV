% https://ctms.engin.umich.edu/CTMS/index.php?example=CruiseControl&section=SystemModeling
% https://en.wikipedia.org/wiki/State-space_representation

% State-space model

m = 1000;
b = 50;

A = -b/m;
B = 1/m;
C = 1;
D = 0;

sys = ss(A, B, C, D)

% Transfer function

s = tf('s');
psys = 1/(m*s+b)

% Discretized state space and transfer function

Ts = 1/50;
dsys = c2d(sys, Ts, 'zoh')
dpsys = tf(dsys)
