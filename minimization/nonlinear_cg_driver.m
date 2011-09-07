function[z,cg_state,varargout] = nonlinear_cg_driver(obj, grad, z, varargin)
% nonlinear_cg_driver -- `Inline' nonlinear conjugate gradient minimzation
%
% [z, cg_state] = nonlinear_cg_driver(obj, grad, z)
% [z, cg_state] = nonlinear_cg_driver(obj, grad, z, cg_state)
% [z, cg_state] = nonlinear_cg_driver(obj, grad, z, {method='pr', 
%                                                    maxiter=1e6, 
%                                                    gradtol=1e-10, 
%                                                    updatetol=1e-8, 
%                                                    objtol=0})
%
%     Performs one iteration of a nonlinear cg optimization method. See
%     labtools.minimization.nonlinear_cg for details on the nonlinear cg options
%     and methods. To specify the cg method for this function, use the third
%     syntax -- use the first syntax to use the default method. Use the second
%     syntax to continue an iteration.
%
%     obj is a function handle of one input of size z0 and one scalar output.
%     grad is a z-sized vector, and cg_state contains information about the type
%     of cg method as well as previous iteration information. If empty, the
%     default cg method from labtools.minimization.nonlinear_cg is adopted.  The
%     outputs of this function are (1) the single-iteration update z, and (2)
%     the updated method-state struct, cg_state.
%
%     This function is meant to be an 'inline' type of minimization -- i.e. it
%     can be used in an iteration loop that is external to this function. The
%     reason one may want to do this that the objective function handle obj may
%     change at each iteration step, or the new gradient may be complicated to
%     compute.

persistent min_linesearch cg_init
if isempty(min_linesearch)
  from labtools.minimization import min_linesearch
  from labtools.minimization import nonlinear_cg_state_initialization as cg_init
end

if (nargin ~= 4)
  cg_state = cg_init(varargin{:});
else
  cg_state = varargin{1};
end

if cg_state.current_state.converged
  warning('This optimization has already converged, but I''m running another iteration as requested.');
end
if cg_state.current_state.iteration_count > cg_state.maxiter
  warning('More iterations than maxiter have been completed, but I''m running another one as requested anyway.');
end

% Now we're going to parse the current state and perform one iteration
switch cg_state.method

% Polak-Ribiere conjugate gradient with gradient descent reset
case 'pr'

  naout = max([nargout - 2, 1]);

  % If this is not the initial run, then update value of beta 
  if not(cg_state.current_state.initial_run)
    %cg_state.current_state.beta = grad(:).'*(grad(:) - ...
    %    cg_state.current_state.previous_grad(:));
    cg_state.current_state.beta = cg_state.gradient_ip(grad, ...
       grad - cg_state.current_state.previous_grad);
    %cg_state.current_state.beta = cg_state.current_state.beta./...
    %    (sum(abs(cg_state.current_state.previous_grad(:)).^2));
    cg_state.current_state.beta = cg_state.current_state.beta./...
       cg_state.gradient_ip(cg_state.current_state.previous_grad, ...
                            cg_state.current_state.previous_grad);

    % Reset if necessary
    if cg_state.current_state.beta < 0;
      cg_state.current_state.beta = 0;
      if cg_state.verbosity
        fprintf('CG reset (negative beta)\n');
      end
      cg_state.current_state.initial_run = true;
    end
  else  % Then this is the first run, setup variables
    cg_state.current_state.lambdaz = zeros(size(z));
    cg_state.current_state.beta = 0;
    cg_state.current_state.initial_run = false;
  end

  % Update lambdaz, the true update vector
  cg_state.current_state.lambdaz = grad + cg_state.current_state.beta*cg_state.current_state.lambdaz;

  % Find step size to take
  temp = norm(cg_state.current_state.lambdaz(:))/sqrt(numel(cg_state.current_state.lambdaz)); % To normalize gradient
  [cg_state.current_state.step_eps, varargout{1:naout}] = min_linesearch(z, -cg_state.current_state.lambdaz/temp, obj, ...
                          2*cg_state.current_state.step_eps);
 
  cg_state.current_state.step_eps = cg_state.current_state.step_eps/temp; % the real stepsize

  % Update current vector, even if step_eps is miniscule
  z = z - cg_state.current_state.step_eps*cg_state.current_state.lambdaz;

  % Update variables
  cg_state.current_state.previous_grad = grad;
  cg_state.current_state.iteration_count = cg_state.current_state.iteration_count + 1;
  cg_state.current_state.gradnorm = norm(grad(:))/sqrt(numel(grad));
  cg_state.current_state.stepnorm = norm(cg_state.current_state.lambdaz(:))/sqrt(numel(cg_state.current_state.lambdaz));
  temp = obj(z);
  cg_state.current_state.objective_improvement = (cg_state.current_state.objective - temp)/temp;
  cg_state.current_state.objective = temp;

  convergence_exception = false;
  
  if (cg_state.current_state.step_eps < cg_state.step_min) | ...
     (cg_state.current_state.objective_improvement < cg_state.objtol) | ...
     (cg_state.current_state.gradnorm < cg_state.gradtol) | ...
     (cg_state.current_state.step_eps < cg_state.updatetol)
    % If we have a nonzero lambdaz, maybe we should try resetting
    %if not(cg_state.current_state.initial_run) 
    if abs(cg_state.current_state.beta) > 0
      cg_state.current_state.beta = 0;
      cg_state.current_state.lambdaz = 0*cg_state.current_state.lambdaz;
      cg_state.current_state.initial_run = true;
      convergence_exception = true;
      if cg_state.verbosity
        fprintf('CG reset (small stepsize/improvement)\n');
      end

    else % We have converged
      if cg_state.verbosity
        fprintf('Convergence: update step or objective improvement was too small\n');
      end
      cg_state.current_state.converged = true;
      return
    end
  end

  % convergence tests:
  if (cg_state.current_state.objective_improvement < cg_state.objtol) | ...
     (cg_state.current_state.gradnorm < cg_state.gradtol) | ...
     (cg_state.current_state.step_eps < cg_state.updatetol) | ...
     (cg_state.current_state.iteration_count >= cg_state.maxiter);
    if not(convergence_exception)
      cg_state.current_state.converged = true;
    end
  end

% Gradient descent with (1/p)-adic multiplicative increase/decrease of step
% size.
case 'gdp'

  naout = max([nargout - 2, 1]);

  if cg_state.current_state.increase_count >= cg_state.increase_period
    cg_state.current_state.step_eps = (1/cg_state.p)*cg_state.current_state.step_eps;
    cg_state.current_state.increase_count = 0;
  end

  [varargout{1:naout}] = obj(z - cg_state.current_state.step_eps*grad);
  cg_state.current_state.increase_count = cg_state.current_state.increase_count + 1;

  while not(isfinite(varargout{1})) || (varargout{1} - cg_state.current_state.objective) >= 0
    cg_state.current_state.step_eps = cg_state.p*cg_state.current_state.step_eps;
    [varargout{1:naout}] = obj(z - cg_state.current_state.step_eps*grad);
    cg_state.current_state.increase_count = 0;
  end
  z = z - cg_state.current_state.step_eps*grad;

  cg_state.current_state.iteration_count = cg_state.current_state.iteration_count+1;

  cg_state.current_state.objective_improvement = (cg_state.current_state.objective - varargout{1})/varargout{1};
  cg_state.current_state.objective = varargout{1};
  cg_state.current_state.gradnorm = norm(grad(:))/sqrt(numel(grad));

  % convergence tests:
  if (cg_state.current_state.objective_improvement < cg_state.objtol) | ...
     (cg_state.current_state.gradnorm < cg_state.gradtol) | ...
     (cg_state.current_state.step_eps < cg_state.updatetol)
     (cg_state.current_state.iteration_count >= cg_state.maxiter);
    cg_state.current_state.converged = true;
  end

otherwise
  error(['Unknown nonlinear CG method ''' cg_state.method '''']);
end

if cg_state.verbosity==1
  fprintf(cg_state.short_string, cg_state.current_state.iteration_count, ...
          cg_state.current_state.objective');
elseif cg_state.verbosity==2
  fprintf(cg_state.long_string, cg_state.current_state.iteration_count, ...
          cg_state.current_state.objective, cg_state.current_state.gradnorm, ...
          cg_state.current_state.step_eps/cg_state.current_state.gradnorm, ...
          cg_state.current_state.objective_improvement);
end
