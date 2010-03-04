function[G, r] = givens(c)
% givens -- Computes a Givens rotation for the 2-vector input
%
% [G, r] = givens(c)
%
%     Performs a stable computation of the 2 x 2 Givens rotation matrix G given
%     the length-2 vector c = [a; b]. In other words, computes G so that:
%
%          ( a )     ( r )
%      G * (   )  =  (   )
%          ( b )     ( 0 )
%
%     More or less shamelessly stolen from http://en.wikipedia.org/wiki/Givens_rotation

G = zeros(2);
a = c(1);
b = c(2);

if b==0
  r = abs(a);
  c = sign(a);
  s = 0;
elseif a==0
  c = 0;
  s = sign(b);
  r = abs(b);
elseif abs(b)>abs(a)
  t = a/b;
  u = sign(b)*sqrt(1+t^2);

  s = 1/u;
  c = s*t;
  r = b*u;
else
  t = b/a;
  u = sign(a)*sqrt(1+t^2);

  c = 1/u;
  s = c*t;
  r = a*u;
end

G = [c s; -s c];
