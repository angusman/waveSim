f0 = @(x) max(1 - abs(x - 2), 0);
f1 = @(x) sin(x);
g0 = @(x) 0;
g1 = @(x) cos(x);
ff = @(x) f2(x);

f3 = @(x) exp(-x.^2);
g3 = @(x) 2 * x .* exp(-x.^2);

discwave(-20, 20, 1000, 0, 5, 0.01, 1, f3, g3);

