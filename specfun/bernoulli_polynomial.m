function[B] = bernoulli_polynomial(x,n)
% bernoulli_polynomial -- Evaluates the Bernoulli polynomials
%
% B = bernoulli_polynomial(x,n)
%
%     Evaluates the degree-n Bernoulli polynomial at locations x. Is vectorized
%     in x and n. If n is a scalar, the returned variable B satisfies size(x) ==
%     size(B).
%
%     If n is a vector, then the returne variable B satisfies size(B) ==
%     [length(x(:)), length(n(:))].
%
%     TODO: make an actual implementation of this.

xsize = size(x);
x = x(:);
n = n(:).';
B = zeros([length(x), length(n)]);

for q = 1:length(n)
  ns = n(q);
  switch ns
  case 0
    B(:,q) = ones(size(x));
  case 1
    B(:,q) = x - 1/2;
  case 2
    B(:,q) = x.^2 - x + 1/6;
  case 3
    B(:,q) = x.^3 - 3/2*x.^2 + 1/2*x;
  case 4
    B(:,q) = x.^4 - 2*x.^3 + x.^2 - 1/30;
  case 5
    B(:,q) = x.^5 - 5/2*x.^4 + 5/3*x.^3 - 1/6*x;
  case 6
    B(:,q) = x.^6 - 3*x.^5 + 5/2*x.^4 - 1/2*x.^2 + 1/42;
  otherwise
    error('Not yet implemented');
  end
end

if length(n)==1
  B = reshape(B, xsize);
end
