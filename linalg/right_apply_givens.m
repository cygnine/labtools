function[A] = right_apply_givens(A, G, m, n)
% right_apply_givens -- Right-applies a Givens rotation to a matrix A
%
% A = right_apply_givens(A, G, m, n)
%
%     Right multiplies a Givens rotation matrix G to columns m and n of the full
%     matrix A.  

%[A(:,m), A(:,n)] = deal(G(1,1)*A(:,m) + G(2,1)*A(:,n), G(1,2)*A(:,m) + G(2,2)*A(:,n));

% Which doesn't require matlab to create a new array?
A(:,[m,n]) = A(:, [m,n])*G;
