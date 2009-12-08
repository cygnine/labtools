function[p] = strict_inputs(varnames,defaults,validators,varargin)
% input_schema -- Sorts `varargin's lists
%
% [p] = strict_inputs(varnames,defaults,validators,{'key','value','key','value'...})
%
%     Identical to input_schema, except that this function discrards any inputs
%     that aren't listed in varnames.

% If no validators are given, just return true as a validator.
%if isempty(validators)
%  validators = cell([length(varnames),1]);
%  for n = 1:length(validators)
%    validators{n} = @(x) not(isstruct(x));
%  end
%end

%%%% Don't use inputParser for Octave compatibility
p = struct();
for n=1:length(varnames);
  p.(varnames{n}) = defaults{n};
end
if length(varargin)==0
elseif (length(varargin)==1) && isa(varargin{1},'struct')
  temp = fieldnames(varargin{1});
  for n=1:length(temp)
    if isfield(p, temp{n})
      p.(temp{n}) = getfield(varargin{1},temp{n});
      % p = setfield(p,temp{n},getfield(varargin{1},temp{n}));
    end
  end
else
  N = length(varargin);
  if mod(N,2)==1
    error('I can''t parse an odd number of KEY-VALUE inputs');
  end

  for n = 1:(N/2)
    if isfield(p, varargin{2*n-1})
      p.(varargin{2*n-1}) = varargin{2*n};
    end
  end
end

%%%%% OLD WAY %%%%%
%p = inputParser;
%for n = 1:length(varnames)
%  p.addParamValue(varnames{n},defaults{n},validators{n});
%end

% Prevents matlab from throwing an error if bad inputs are given
%p.KeepUnmatched = true;
%p.parse(varargin{:});
%p = p.Results;
