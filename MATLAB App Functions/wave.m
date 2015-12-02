function [x,y] = wave(f0,g0,x,t,v,N,dt,boundary)
% WAVE Solves the wave equation with the following parameters:
%   x - Real interval specifiying single-dimension space
%       of the form [a,b]
%   t - Interval specifying time interval
%   v - Wave speed
%   N - Resolution of space
%  dt - Resolution of time
%  OPTIONAL: 'dir' 'neu'

% INITIAL WITH NO SPECIFICATIONS
if nargin < 1
    f0 = @(x) max(1-abs(x-2),0);
    g0 = @(x) 0*x;
    x = [0,5];
    t = [0,1];
    v = 1;
    N = 10;
    dt = 0.1;
    boundary = 'dir';
end

% SETTING UP SPACE...
dx = (x(end) - x(1))/N;
x = x(1):dx:x(end);     %redefining x according to interval size
t = t(1):dt:t(end);     %redefining t according to interval size

% INITIALIZING FUNCTION VALUES FOR TIME (ROW) AND SPACE (COLUMNS)...
% Form is y(t,x) rather than y(x,t).
%
%        < - - - - - - - - - - x domain - - - - - - - - >
%       [-dt    f0(x) - dt*g0(x)                        ] ROW 1
%       [ 0     f0(x)                                   ] ROW 2
%  y  = [ dt    FOR LOOP                                ] ROW 3
%       [ 2dt   FOR LOOP                                ] ROW 4
%       [ 3dt   FOR LOOP                                ] ROW 5

y = nan*zeros(length(t)+1,length(x));
y(-1+2,:) = f0(x) - dt*g0(x);  %back in time...
y(0+2,:) = f0(x);              %current position...

% SOLVING WAVE EQUATION...
for i = (0+2):1:(length(t)+1)
    for j = (0+2):1:(length(x)-1)
        y(i+1,j) = 2*y(i,j) - y(i-1,j) + ...
                  (v*dt/dx)^2 * (y(i,j+1) - 2*y(i,j) + y(i,j-1));
    end
    
    switch boundary
        case {'n','neu','Neumann'}
            y(i+1,0+1) = y(i+1,1+1);
            y(i+1,N+1) = y(i+1,N-1+1);
        case {'d','dir','Dirichlet'}
            y(i+1,0+1) = 0;                   
            y(i+1,N+1) = 0;
        case {'dn', 'Dirch/Neum'}
            y(i+1,0+1) = 0;
            y(i+1,N+1) = y(i+1,N-1+1);
        case {'nd', 'Neum/Dirch'}
            y(i+1,0+1) = y(i+1,1+1);
            y(i+1,N+1) = 0;
    end
    
end

end
