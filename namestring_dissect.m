function[names] = namestring_dissect(name)
% namestring_dissect -- dissects 'name.strings' into {'name', 'strings'}
%
% names = namestring_dissect(name)
% 
%     Performs the operation:
%        'name.string.example' --->  {'name', 'string', 'example'}
%
%     The input name is a single string, the output names is a cell array with
%     length equal to the (number of periods ('.') found in name) + 1.

periods = strfind(name, '.');
N = length(periods);
names = cell([N+1 1]);

if N==0
  names = {name};
  return;
end

names{1} = name(1:(periods(1)-1));

if N>1
  for q = 2:N
    names{q} = name((periods(q-1)+1):(periods(q)-1));
  end
end

names{N+1} = name(periods(N)+1:end);
