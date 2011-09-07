function[cg_state] = nonlinear_cg_state_initialization(varargin)
% nonlinear_cg_state_initialization -- Initializes state struct for cg iteration
%
% cg_state = nonlinaer_cg_state_initialization(...)
%
%     Initializes the struct cg_state to be used to drive a cg iteration scheme.
%     The algorithm terminates when one of the following is satisfied: 
%
%       1.) the maximum number of iterations (maxiter) is reached
%       2.) the 2-norm of the gradient falls below gradtol
%       3.) the 2-norm of the update stepsize falls below updatetol
%       4.) the relative objective function improvement falls below objtol

persistent strict_inputs
if isempty(strict_inputs)
  from labtools import strict_inputs
end

% First determine method
temp = strict_inputs({'method'}, {'pr'}, [], varargin{:});

divline = '--------------------------------------------------------------------------------\n';

switch temp.method
case 'pr'
   inputs = {'maxiter', ...
             'gradtol', ...
             'updatetol', ...
             'objtol', ...
             'verbosity', ...
             'gradient_ip', ...
             'step_min'};

  default_ip = @(a,b) a(:).'*b(:);

  defaults = {1e6, ...          % 'maxiter'
              1e-10, ...        % 'gradtol'
              1e-8, ...         % 'updatetol'
              1e-8, ...         % 'objtol'
              1, ...            % 'verbosity'
              default_ip, ...  % 'gradient_ip'
              1e-16};           % 'step_min'
          
  cg_state = strict_inputs(inputs, defaults, [], varargin{:});
  cg_state.short_string = ['Iteration # %d, objective value %1.3e'];
  cg_state.long_string = [divline 'Iteration number: %d \n Objective value: ' ...
    '%1.6e \n Gradient norm: %1.6e \n Relative stepsize: %1.3e \n Relative objective ' ...
    'improvement: %1.3e \n' divline];

  current_state = struct('initial_run', true, ...
                         'iteration_count', 0, ...
                         'converged', false);

  current_state.objective = Inf;
  current_state.objective_improvement = Inf;
  current_state.step_eps = 1;
case {'gdp','gd'} % p-adic Gradient descent
  inputs = {'maxiter', ...
            'gradtol', ...
            'objtol', ...
            'updatetol', ...
            'verbosity', ...
            'step_min', ...
            'p', ...
            'increase_period'};
  defaults = {1e6, ...      % 'maxiter'
              1e-10, ...    % 'gradtol'
              1e-8, ...     % 'objtol'
              1e-8, ...     % 'updatetol'
              1, ...        % 'verbosity'
              1e-16, ...    % 'step_min'
              0.50, ...     % 'p'
              5};          % 'increase_period'

  cg_state = strict_inputs(inputs, defaults, [], varargin{:});
  if (cg_state.p <= 0) | (cg_state.p >= 1)
    error('Input ''p'' must be in the interval (0, 1)');
  end
  cg_state.short_string = ['Iteration # %d, objective value %1.3e\n'];
  cg_state.long_string = [divline 'Iteration number: %d \n Objective value: ' ...
    '%1.6e \n Gradient norm: %1.6e \n Stepsize: %1.3e \n Relative objective ' ...
    'improvement: %1.3e \n' divline];

  current_state.step_eps = 0.1;
  current_state.objective = Inf;
  current_state.increase_count = 0;
  current_state.converged = false;
  current_state.iteration_count = 0;
otherwise
  error(['Unrecognized method ''' temp.method '''']);
end

cg_state.method = temp.method;
cg_state.current_state = current_state;
