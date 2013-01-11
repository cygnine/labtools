function[c] = struct2fullcell(s);
% struct2fullcell -- Converts a struct to a one-dimensional cell array
%
% c = struct2fullcell(s)
%
%     If s is a (1 x 1) struct with N fields, this construct c as a
%     one-dimensional cell array with entries:
%
%       c = {s.fieldname1, s.fieldvalue1, s.fieldname2, s.fieldvalue2, ...}
%
%     If s is a cell array, returns the same array.

if isa(s, 'cell') || isempty(s)
  c = s;
  return
end

c = struct2cell(s);
N = length(c);
c = reshape([fieldnames(s) c]', [2*N 1]);
