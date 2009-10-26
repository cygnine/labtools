function[name] = namestring_construct(varargin)
% namestring_cosntruct -- constructs 'name','strings' into 'name.strings'
%
% name = namestring_construct(name1, name2, name3, ...)
%
%     Performs the operation:
%        'name', 'string', 'example' ----> 'name.string.example'
%
%     The input names are a comma-separated list of inputs into the function,
%     the output name is a single string.

switch length(varargin)
case 0
  name = '';
otherwise
  N = length(varargin);
  tempnames = cell([2*N-1 1]);
  tempnames{1} = varargin{1};
  for q = 2:N;
    tempnames{2*(q-1)} = '.';
    tempnames{2*q-1} = varargin{q};
  end
  name = strcat(tempnames{:});
end
