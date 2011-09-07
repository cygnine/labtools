function[J] = jacobian(self, z1, z2, z3, z4)
% jacobian -- computes Jacobian of cross-ratio function
%
% J = CrossRatio.jacobian(z1, z2, z3, z4)
%
%     Computes the gradient of the cross-ratio of the four complex numbers. All
%     inputs should be of the same size, and for N = numel(z1), the output J is
%     an N x 4 Jacobian matrix.
%
% J = CrossRatio.jacobian(z)
%
%     Assumes that the array z has one dimension of size-4 and uses that to
%     parse z1, z2, z3, and z4 as above.

if nargin == 2
  % called as cross_ratio_gradient(z)
  [M,N] = size(z1);
  if M==4
    J = self.jacobian(z1(1,:), z1(2,:), z1(3,:), z1(4,:));
  elseif N==4
    J = self.jacobian(z1(:,1), z1(:,2), z1(:,3), z1(:,4));
  else
    error('The input matrix z must have one dimension of size 4');
  end
elseif nargin == 5
  N = numel(z1);
  J = zeros([N 4]);
  z12 = z1 - z2;
  z23 = z2 - z3;
  z34 = z3 - z4;
  z13 = z1 - z3;
  z14 = z1-z4;
  z24 = z2 -z4;
  J(:,1) = z24.*z34./(z23.*z14.^2);
  J(:,2) = -z13.*z34./(z14.*z23.^2);
  J(:,3) = z24.*z12./(z14.*(-z23).^2);
  J(:,4) = -z13.*z12./(z23.*(-z14).^2);
else
  error('Invalid number of inputs')
end
