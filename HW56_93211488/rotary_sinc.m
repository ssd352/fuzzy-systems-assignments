function [ z ] = rotary_sinc( x, y )
%ROTARY_SINC Summary of this function goes here
%   Detailed explanation goes here
z = sinc(sqrt(x .* x + y .* y));
end

