function[p] = input_schema(varnames,defaults,validators,varargin)
% input_schema -- Sorts `varargin's lists
%
% [p] = input_schema(varnames,defaults,validators,{'key','value','key','value'...})
%
%     Similar to Matlab's built-in input parser, except this method is more
%     built to emulate Python's keyword argument syntax. Optionally, the key-val
%     input sequence can be replaced by a single struct containing the key-vals.
%
%     Returns a struct of key-val pairs.

% If no validators are given, just return true as a validator.
if isempty(validators)
  validators = cell([length(varnames),1]);
  for n = 1:length(validators)
    validators{n} = @(x) not(isstruct(x));
  end
end

%%%% Don't use inputParser for Octave compatibility
p = struct();
for n=1:length(varnames);
  p = setfield(p,varnames{n},defaults{n});
end
if length(varargin)==0
elseif (length(varargin)==1) && isa(varargin{1},'struct')
  temp = fieldnames(varargin{1});
  for n=1:length(temp)
    p = setfield(p,temp{n},getfield(varargin{1},temp{n}));
  end
else
  N = length(varargin);
  if mod(N,2)==1
    error('I can''t parse an odd number of KEY-VALUE inputs');
  end

  for n = 1:(N/2)
    p = setfield(p,varargin{2*n-1},varargin{2*n});
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
