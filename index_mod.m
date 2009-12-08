function[z] = index_mod(z,N)
% index_mod -- Mod function in range 1,2,...,N
%
% z = index_mod(z,N)
%
%     A mod function for natural-number indices. Examples:
%
%         mod([3,4,5], 5) ----> [3,4,5]
%
%         mod([4,5,6], 5) ----> [4,5,1]
%
% TODO: roundoff can become a problem with the current implementation.

z = 1 + mod(z-1,N);
