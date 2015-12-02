function [ y ] = f2( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

a = abs(x);

if a < 1
    y = 1 - a;
else
    y = 0;
end

end

