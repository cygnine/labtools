function[B] = bernoulli_number(n)
% bernoulli_number -- Returns the Bernoulli numbers
%
% B = bernoulli_number(n)
%
%     Evaluates the n'th Bernoulli number. Is vectorized in n.

persistent bpoly
if isempty(bpoly)
  from labtools.specfun import bernoulli_polynomial as bpoly
end

nsize = size(n);
B = bpoly(0, n);
B = reshape(B, nsize);
