
%initialing anon functions to be used for problems 2-8
f0 = @(x) max(1 - abs(x - 2), 0);
f1 = @(x) sin(x);
g0 = @(x) 0;
g1 = @(x) cos(x);
ff = @(x) f2(x);
fff = @(a, b, k) (@(x) sin(k * pi * (x - a)/(b - a)));

f3 = @(x) exp(-x.^2);
g3 = @(x) 2 * x .* exp(-x.^2);

%use the discwave function for actaully running simulations
discwave(0, 10, 100, 0, 20, 0.1, 1, f3, g3, 'dir');

