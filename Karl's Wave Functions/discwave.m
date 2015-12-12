function [ x, tn, y ] = discwave( a, b, N, t0, tf, dt, v, f0, g0, bc )
%DISCWAVE Solve wave equation and simulate continuous time solutions.
%   

%converting params to intital values
dx = (b - a)/N;
x = zeros(N + 2, 1);
t = t0:dt:tf;
tn = length(t);
y = zeros(N + 2, tn);
c = (v^2 * dt^2)/(dx^2);


%setting the intial conditions of the wave
for k = 1:(N + 2)
    x(k) = a + k * dx;
    y(k, 1) = f0(x(k)) - dt * g0(x(k));
    y(k, 2) = f0(x(k));
end

%running the formula to produce the wave simulation
for n = 3:tn
    for k = 2:(N + 1)
        yknm = 2 * y(k, n - 1);
        y(k, n) = yknm - y(k, n - 2) + ...
            c * (y(k + 1, n - 1) - yknm + y(k - 1, n - 1));
    end
    
    %switiching over boundary conditions
    switch bc
        case 'dir'
            y(1, n) = 0;
            y(N + 2, n) = 0;
        case 'neu'
            y(1, n) = y(2, n);
            y(N + 2, n) = y(N + 1, n);
        case 'nd'
            y(1, n) = y(2, n);
            y(N + 2, n) = 0;
        case 'dn'
            y(1, n) = 0;
            y(N + 2, n) = y(N + 1, n);
    end
end


$ploting and such
figure;
for n = 1:tn
    plot(x, y(:, n), 'LineWidth', 4);
    axis([-20 20 -1 1]);
    M(n) = getframe(gcf);
end

%producing a .avi movie is results
ntimes = 3;
fps = 1;
movie(gcf, M, ntimes, fps);

myVideo = VideoWriter('q2.avi');
open(myVideo);
writeVideo(myVideo, M);
close(myVideo);

end