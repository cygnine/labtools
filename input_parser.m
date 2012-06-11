function[results, parser] = input_parser(varnames,defaults,validators,varargin)
% input_parser -- The labtools implementation of Matlab's inputParser
%
% [p] = input_parser(varnames,defaults,validators,{'key','value','key','value'...})
%
%     Similar to Matlab's built-in input parser, except this method is more
%     built to emulate Python's keyword argument syntax. Optionally, the key-val
%     input sequence can be replaced by a single struct containing the key-vals. 
%
%     The current implementation of this is just a (less-verbose) wrapper of
%     inputParser. The default for KeepUnmatched is true to prevent errors for
%     other inputs. 

if (nargin < 3) || isempty(validators)
  validators = cell([length(varnames) 1]);
end

parser = inputParser;
for n = 1:length(varnames)
  if isempty(validators{n})
    parser.addParamValue(varnames{n},defaults{n});
  else
    parser.addParamValue(varnames{n},defaults{n},validators{n});
  end
end

% Prevents matlab from throwing an error if bad inputs are given
parser.KeepUnmatched = true;
parser.parse(varargin{:});
results = parser.Results;
