function[is] = ind_expand(is,Nmax);

% [is] = ind_expand(is,Nmax)
% Expands the index vector is, whose entries are integers in the range 1..Nmax
% by 1 in left and right directions. Thus, the output has the same number of
% rows as is, and two columns.
%
% 20080818 -- acn

is = is(:);

imin = is - 1;
imax = is + 1;

flag = imax>Nmax;
imax(flag) = Nmax;
imin(flag) = imin(flag)-1;
flag = imin<1;
imin(flag) = 1;
imax(flag) = imax(flag)+1;

is = [imin imax];
