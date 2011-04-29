function[p] = all_inputs(varnames,defaults,validators,varargin)
% all_inputs -- Sorts `varargin's lists
%
% [p] = all_inputs(varnames,defaults,validators,{'key','value','key','value'...})
%
%     Identical to input_schema -- this function will superscede input_schema.
%     In particular, this is the complement to strict_inputs, and thus this
%     function returns all given inputs in varargin, not just those specified by
%     varnames.

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
    p.(varargin{2*n-1}) = varargin{2*n};
  end
end
