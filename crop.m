function[m] = crop(m, msize)
% crop -- Crops an N-D array down to specified size
%
% m = crop(m, msize)
%
%     Truncates the matrix m so that it has size specified by msize. Does not
%     zero-pad if some elements in msize specify a larger number of entries than
%     m has.
%
%     Example:
%
%       m = eye(10);
%       m2 = crop(m, [6, 9]);

dims = length(msize);
for q = 1:dims
  m = m(1:msize(q),:);
  m = shiftdim(m, 1);
end
