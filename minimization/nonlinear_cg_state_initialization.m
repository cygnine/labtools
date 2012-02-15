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
%       4.) the relative objective function improvement falls below reltol

persistent input_parser parser
persistent pr_parser gdp_parser
if isempty(parser)
  from labtools import input_parser
  [temp, parser] = input_parser({'method'}, {'pr'}, [], varargin{:});

  %%%%%%%%%%%% Inputs for PR method
  inputs = {'maxiter', ...
             'gradtol', ...
             'updatetol', ...
             'reltol', ...
             'verbosity', ...
             'gradient_ip', ...
             'objtol', ...
             'step_min'};

  default_ip = @(a,b) a(:).'*b(:);

  defaults = {1e6, ...          % 'maxiter'
              1e-10, ...        % 'gradtol'
              1e-8, ...         % 'updatetol'
              1e-8, ...         % 'reltol'
              1, ...            % 'verbosity'
              default_ip, ...   % 'gradient_ip'
              eps, ...          % 'objtol'
              1e-16};           % 'step_min'

  [garbage, pr_parser] = input_parser(inputs, defaults, [], varargin{:});

  %%%%%%%%%%%% Inputs for GDP method
  inputs = {'maxiter', ...
            'gradtol', ...
            'reltol', ...
            'updatetol', ...
            'verbosity', ...
            'step_min', ...
            'objtol', ...
            'p', ...
            'increase_period'};
  defaults = {1e6, ...      % 'maxiter'
              1e-10, ...    % 'gradtol'
              1e-8, ...     % 'reltol'
              1e-8, ...     % 'updatetol'
              1, ...        % 'verbosity'
              1e-16, ...    % 'step_min'
              1e-8, ...     % 'objtol'
              0.50, ...     % 'p'
              5};           % 'increase_period'


  [garbage, gdp_parser] = input_parser(inputs, defaults, [], varargin{:});
else
  parser.parse(varargin{:});
  temp = parser.Results;
end

divline = '--------------------------------------------------------------------------------\n';

switch temp.method
case 'pr'
  pr_parser.parse(varargin{:});
  cg_state = pr_parser.Results;

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
  gdp_parser.parse(varargin{:});
  cg_state = gdp_parser.Results;

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
