function[eps, L] = padic_linesearch(v, Lv, w, obj, epsmax, ratio);
% padic_linesearch -- Gradient step via p-adic stepping
%
% [eps, L] = padic_linesearch(v, Lv, w, obj, epsmax)
% [eps, L] = padic_linesearch(v, Lv, w, obj, epsmax, ratio)
%
%     Given a starting point v, returns the positive scalar eps such that (v +
%     eps*w) returns an objective that is smaller than the objective at v. The
%     value of eps starts at epsmax and if the objective is increased, eps is
%     decreased multiplicatively by "ratio" until the objective is decreased.
%     The default value is ratio=0.5. obj is a function handle that takes in one
%     input of size size(v) and returns the value of the (scalar) objective. The
%     second output L is the value of the objective at the location v + eps*w.

% First determine if ratio was given
if nargin < 6
  ratio = 0.5;
end
epsmin = 1e-16;

objdiff = -1;
eps = 1/ratio*epsmax;
while objdiff < 0;
  eps = ratio*eps;
  L = obj(v + eps*w);
  objdiff = Lv - L;

  if eps < epsmin;
    eps = 0;
    break;
  end
end
