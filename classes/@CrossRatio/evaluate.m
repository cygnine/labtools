function[C] = evaluate(self, z1, z2, z3, z4)
% evaluate -- Evaluates cross ratios
%
% C = CrossRatio.evaluate(self, z)
%     If z is a matrix of size (N x 4) or (4 x N), returns a vector of the
%     appropriate size with the cross-ratio computed across the size-4
%     dimension. If z is (4 x 4), the cross-ratio is computed across the first
%     dimension.
%
% C = CrossRatio.evaluate(self, z1, z2, z3, z4)
%
%     If z1, z2, z3, and z4 are scalars, computes the cross-ratio as defined
%     above.
%
%     The inputs z1, z2, z3, and z4 may be arrays, but then either they must all
%     be of the same size, or some of them can be scalars.


if nargin == 2
  % called as cross_ratio(z)
  [M,N] = size(z1);
  if M==4
    C = self.evaluate(z1(1,:), z1(2,:), z1(3,:), z1(4,:));
  elseif N==4
    C = self.evaluate(z1(:,1), z1(:,2), z1(:,3), z1(:,4));
  else
    error('The input matrix z must have one dimension of size 4');
  end
elseif nargin == 5
  C = (z1-z3).*(z2-z4)./((z2-z3).*(z1-z4));
else
  error('Invalid number of inputs')
end
