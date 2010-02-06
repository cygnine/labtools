function[s] = biased_sign(z)
% biased_sign -- A sign function that is nonzero at 0
%
% s = biased_sign(z)
%
%     Identical to Matlab's sgn function, except returns s=+1 for z=0.

flags = z>=0;
s = 1*flags - 1*not(flags);
