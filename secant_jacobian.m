function[J] = secant_jacobian(f, x, varargin)
% secant_jacobian -- Computes a Jacobian matrix using secant-line methods
%
% J = secant_jacobian(f, x, {fd_eps = 1e-6})
%
%     Returns the Jacobian of the function handle f with respect to the inputs
%     at the location x. The Jacobian has entries
%
%                    del f_m
%          J(m,n) = --------- (x).
%                    del x_n
%
%     Note that while f and/or x may be array-valued, a Jacobian is produced
%     nonetheless using linear indexing. A finite-difference secant-line method
%     is used to approximate the derivative. A central operator 
%
%       df = f(x+fd_eps/2*e) - f(x-fd_eps/2*e),
%
%     is used, where e the perturbation direction.

persistent parser
if isempty(parser)
  from labtools import input_parser
  [opt, parser] = input_parser({'fd_eps'}, {1e-6}, [], varargin{:});
else
  parser.parse(varargin{:});
  opt = parser.Results;
end

fx = f(x);
M = length(fx(:));
N = length(x(:));
J = zeros([M N]);

for q = 1:N
  z = x;
  z(q) = x(q) + opt.fd_eps/2;
  f_plus = f(z);

  z(q) = x(q) - opt.fd_eps/2;
  f_minus = f(z);

  J(:,q) = (f_plus - f_minus)/opt.fd_eps;
end
