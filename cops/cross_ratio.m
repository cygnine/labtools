function[C] = cross_ratio(z1, z2, z3, z4)
% cross_ratio -- computes cross-ratios
%
% C = cross_ratio(z)
%
%     If z is a vector of length 4, computes the cross-ratio of the entries,
%     defined as
%            [z(1) - z(2)] * [z(2) - z(4)]
%       C =  -----------------------------
%            [z(2) - z(3)] * [z(1) - z(4)]
%
%     If z is a matrix of size (N x 4) or (4 x N), returns a vector of the
%     appropriate size with the cross-ratio computed across the size-4
%     dimension. If z is (4 x 4), the cross-ratio is computed across the first
%     dimension.
%
% C = cross_ratio(z1, z2, z3, z4)
%
%     If z1, z2, z3, and z4 are scalars, computes the cross-ratio as defined
%     above.
%
%     The inputs z1, z2, z3, and z4 may be arrays, but then either they must all
%     be of the same size, or some of them can be scalars.

persistent cross_ratio
if isempty(cross_ratio)
  from labtools.cops import cross_ratio
end

if nargin == 1
  % called as cross_ratio(z)
  [M,N] = size(z1);
  if M==4
    C = cross_ratio(z1(1,:), z1(2,:), z1(3,:), z1(4,:));
  elseif N==4
    C = cross_ratio(z1(:,1), z1(:,2), z1(:,3), z1(:,4));
  else
    error('The input matrix z must have one dimension of size 4');
  end
elseif nargin == 4
  C = (z1-z3).*(z2-z4)./((z2-z3).*(z1-z4));
else
  error('Invalid number of inputs')
end
