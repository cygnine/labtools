function[z,gradnorm] = nonlinear_cg(obj, grad, z0, varargin)
% nonlinear_cg -- Nonlinear conjugate gradient minimzation
%
% [z, gradnorm] = nonlinear_cg(obj, grad, z0, {method='pr', maxiter=1e6, gradtol=1e-10, updatetol=1e-8, objtol=0})
%
%     Attempts to locate the minimum of the objective function obj, a function
%     of an N-dimensional vector z; z0 is the initial guess for the algorithm.
%     obj and grad are function handles for the objective and gradient,
%     respectively of the function. Therefore, obj returns a scalar and grad
%     returns a column vector of size equal to that of z0.
%     
%     The various methods are as follows:
%
%       pr (default): Polak-Ribiere (with automatic reset)
%       fr : fletcher-reeves (TODO)
%       hs : hestenes-stiefel (TODO)
%       gd : regular gradient descent
%
%     The algorithm terminates when one of the following is satisfied: 
%
%       1.) the maximum number of iterations (maxiter) is reached
%       2.) the 2-norm of the gradient falls below gradtol
%       3.) the 2-norm of the update vector falls below updatetol
%       4.) the objective function improvement falls below objtol
%
%     Set any of the above optional arguments to -Inf to disable termination
%     based on that criterion. (Set maxiter to +Inf instead)
%
%     If desired the 2-norm of the gradient (gradnorm) is given at termination.

persistent strict_inputs min_linesearch
if isempty(strict_inputs)
  from labtools import strict_inputs
  from labtools.minimization import min_linesearch
end

inputs = {'method', 'maxiter', 'gradtol', 'updatetol', 'objtol'};
defaults = {'pr', 1e6, 1e-10, 1e-8, 0};
opt = strict_inputs(inputs, defaults, [], varargin{:});

z0 = z0(:);
N = length(z0);

objval = Inf;           % value of objective
terminate = false;      % flag indicating when to terminate loop
iter = 0;               % iteration count
z = z0;                 % variable value
beta = 0;               % magnitude of step in CG direction
prevgradval = 0*z0;     % Previous gradient step direction
lambdaz = 0*z0;         % CG update direction
initial_run = true;     % flag for initial iteration

while not(terminate)

  gradval = grad(z);
  switch opt.method
  case 'pr'
    beta = gradval.'*(gradval - prevgradval);
    if initial_run
      initial_run = false;
    else
      beta = beta/(prevgradval.'*prevgradval);
    end
    beta = max([0, beta]);  % automatic reset
  case 'fr'
    error('TODO');
  case 'hs'
    error('TODO');
  case 'gd'
    beta = 0;
  end

  prevgradval = gradval;
  lambdaz = gradval + beta*lambdaz;

  update_step = min_linesearch(z, -lambdaz, obj, 0.1);
  z = z - update_step*lambdaz;

  temp = objval;
  objval = obj(z);

  % Termination checking
  iter = iter + 1;
  gradnorm = norm(gradval);
  stepnorm = norm(lambdaz);
  objdiff = temp - objval;

  if (iter>=opt.maxiter) | (gradnorm < opt.gradtol) | (stepnorm < opt.updatetol) | ...
     (objdiff < opt.objtol)
    terminate = true;
  end

end
