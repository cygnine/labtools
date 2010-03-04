function[A] = apply_givens(A, G, m, n, c, r)
% apply_givens -- Left-applies a Givens rotation to a matrix A
%
% A = apply_givens(A, G, m, n, [c, r])
%
%     Left multiplies a Givens rotation matrix G to rows m and n of the full
%     matrix A.  If the optional input r is given, then the appropriate location
%     in column c of A is set to r (to avoid cases of over/underflow.

%[A(m,:), A(n,:)] = deal(G(1,1)*A(m,:) + G(1,2)*A(n,:), G(2,1)*A(m,:) + G(2,2)*A(n,:));

% Which doesn't require matlab to create a new array?
A([m,n],:) = G*A([m n],:);

if nargin>4
  A(m,c) = r;
  A(n,c) = 0;
end
