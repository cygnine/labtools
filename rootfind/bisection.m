function[x_out,varargout] = bisection(x0,x1,f,varargin)
% [x,termination_reason] = bisection(x0,x1,f,{F=zeros(size(x)),fx_tol=0, x_tol=1e-12, maxiter=100})
%
%     Finds the roots of the function (handle) f given initial bounding
%     intervals defined as [x0, x1] (array). x0 MUST be less than x1, or else
%     bad things will happen. This routine performs the bisection root-finding
%     algorithm until one of the following three criterion is met:
%
%     1.) The maximum number of iterations (maxiter) is reached
%     2.) f(x) is less than fx_tol for every x
%     3.) The interval width is less than x_tol for every x
%
%     The optional output termination_reason is set to 1, 2, or 3 depending on
%     which of the above criterion terminated the iteration.
%
%     To support vector-valued iteration, the optional input F can be specified
%     so that this function solves for the root of f(x) - F = 0, where F must be
%     of the same size as x0 and x1. I.e., you can solve f(x_1)=F_1, f(x_2)=F_2,
%     etc. in parallel.
%
%     If you wish to disable the fx_tol and/or x_tol termination requirements,
%     set one (or both) of them to 0. Similarly, you can set maxiter to Inf. If
%     you do all three, this function will never terminate.

global handles;
inputs = {'maxiter', 'fx_tol', 'x_tol', 'F'};
defaults = {100, 0, 1e-12, zeros(size(x0))};
opt = handles.common.input_schema(inputs, defaults, [], varargin{:});

% setup
fx0 = f(x0) - opt.F;
fx1 = f(x1) - opt.F;
%if not(all(sign(fx0).*sign(fx1)<1))
%  error('You must give me a starting interval containing a simple root');
%end

x = (x0+x1)/2;
fx = f(x) - opt.F;
x_out = x;

fx_converged = abs(fx)<opt.fx_tol;
left_point = abs(fx0)<opt.fx_tol;
right_point = abs(fx1)<opt.fx_tol;
x_converged = abs((x1-x0)./x)<opt.x_tol;

x_out(left_point) = x0(left_point);
x_out(right_point) = x0(right_point);
flags = fx_converged | x_converged;
x_out(flags) = x(flags);
% The following is to deal with a crappy special case
fx_converged(left_point | right_point) = true; 

to_compute = find(not(flags | left_point | right_point));
compute = length(to_compute)>0;
N_iter = 0;

fx0 = fx0(to_compute);
fx1 = fx1(to_compute);
fx = fx(to_compute);
x0 = x0(to_compute);
x1 = x1(to_compute);
x = x(to_compute);
F = opt.F(to_compute);

% iteration
while compute
  move_left = sign(fx)==sign(fx1);
  move_right = not(move_left);

  x1(move_left) = x(move_left);
  x0(move_right) = x(move_right);
  x = (x0+ x1)/2;
  fx = f(x) - F;
  fx0(move_right) = f(x0(move_right)) - F(move_right);
  fx1(move_left) = f(x1(move_left)) - F(move_left);

  fx_converged = abs(fx)<=opt.fx_tol;
  x_converged = abs((x1- x0)./x)<opt.x_tol;
  N_iter = N_iter + 1;
  too_many_iterations = N_iter>opt.maxiter;

  flags = fx_converged | x_converged;
  % Output
  x_out(to_compute(flags)) = x(flags);
  % Update:
  x1(flags) = [];
  x0(flags) = [];
  fx1(flags) = [];
  fx0(flags) = [];
  x(flags) = [];
  fx(flags) = [];
  F(flags) = [];
  to_compute(flags) = [];

  % matlab convention: any([]) = false
  compute = any(to_compute) & not(too_many_iterations);
end

% output termination flag
if all(fx_converged)
  varargout{1} = 2;
elseif all(x_converged)
  varargout{1} = 3;
elseif too_many_iterations
  x_out(to_compute) = x;
  varargout{1} = 1;
else
  varargout{1} = NaN;
end
