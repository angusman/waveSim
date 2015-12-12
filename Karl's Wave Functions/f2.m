function [ y ] = f2( x )
%triangle wave
%   simple triangle wave nothing more

a = abs(x);

if a < 1
    y = 1 - a;
else
    y = 0;
end

end

