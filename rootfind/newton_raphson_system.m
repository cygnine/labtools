function[x_out,varargout] = newton_raphson_system(x0,f,df,varargin)
% newton_raphson_system -- Solves a nonlinear system of equations
% [x,termination_reason] = newton_raphson_system(x0,f,df,{F=zeros(size(x)),fx_tol=1e-12, x_tol=0, maxiter=100})
%
%     Finds the roots of the function (handle) f given the initial guesses x0
%     (array). df is the function handle for the Jacobian matrix. This routine
%     performs the Newton-Raphson root-finding algorithm until one of the
%     following three criterion is met:
%
%     1.) The maximum number of iterations (maxiter) is reached
%     2.) f(x) is less than fx_tol for every x
%     3.) The change in x at the current iteration is less than x_tol for every
%         x
%
%     The optional output termination_reason is set to 1, 2, or 3 depending on
%     which of the above criterion terminated the iteration.
%
%     The function handle f should return a vector of size N x 1. In addition,
%     this should be the size of the initial condition x0 as well. The
%     derivative function df should return the N x N Jacobian matrix. 
%
%     If you wish to disable the fx_tol and/or x_tol termination requirements,
%     set one (or both) of them to 0. Similarly, you can set maxiter to Inf. If
%     you do all three, this function will never terminate.

persistent strict_inputs
if isempty(strict_inputs)
  from labtools import strict_inputs
end

inputs = {'maxiter', 'fx_tol', 'x_tol', 'F'};
defaults = {100, 1e-12, 0, zeros(size(x0))};

opt = strict_inputs(inputs, defaults, [], varargin{:});

% setup
x_out = x0;
x = x0;
fx = f(x0) - opt.F;
x_converged = false(size(x));
fx_converged = norm(fx)<opt.fx_tol;
to_compute = find(not(fx_converged | x_converged));
compute = length(to_compute)>0;
N_iter = 0;

x = x(to_compute);
fx = fx(to_compute);
F = opt.F(to_compute);

% iteration
while compute
  delta_x = inv(df(x))*fx;
  x = x - delta_x;

  fx = f(x) - F;

  N_iter = N_iter + 1;
  fx_converged = norm(fx)<opt.fx_tol;
  too_many_iterations = N_iter>=opt.maxiter;
  x_converged = norm(delta_x./x)<opt.x_tol;

  %flags = fx_converged | x_converged;
  % output
  %x_out(to_compute(flags)) = x(flags);
  % update
  %x(flags) = [];
  %fx(flags) = [];
  %F(flags) = [];
  %to_compute(flags) = [];

  % matlab convention: any([]) = false
  if x_converged | fx_converged | too_many_iterations;
    compute = false;
  end
end

% output termination flag
if fx_converged
  varargout{1} = 2;
  x_out = x;
elseif x_converged
  varargout{1} = 3;
  x_out = x;
elseif too_many_iterations
  x_out(to_compute) = x;
  varargout{1} = 1;
else
  varargout{1} = NaN;
end
