function[x] = lse(A, b, B, d)
% lse -- Solves a least-squares equality-constrained problem
%
% x = lse(A, b, B, d)
%
%     Solves the following problem:
%
%       Minimize || A x - b ||_2 subject to B x = d
%
%     If a solution does not exist (i.e. B x = d is inconsistent) then an empty
%     vector is returned. If many solutions exist, the one with smallest
%     Euclidean norm is returned.

persistent lsmin
if isempty(lsmin)
  from labtools.linalg import lsmin
end

[m,p] = size(A);
[n,p2] = size(B);

assert(p==p2, 'Matrices A and B must have the same number of columns');
assert(m==length(b), 'Sizes of inputs A and b are inconsistent');
assert(n==length(d), 'Sizes of inputs B and d are inconsistent');

% Use qr factorization to solve problem
[Q,L] = qr(B');
L = L';
rB = rank(B);

% We'll solve for z = Q^T*x
z = zeros([p 1]);
z(1:rB) = L(1:rB, 1:rB)\d(1:rB);

if rB < n
  % It's possible to have inconsistent constraints
  solution_tolerance = 1e-8;

  if norm(L*z - d) > solution_tolerance;
    x = []; 
    fprintf('System has no solution\n'); 
    return;
  else
    % Just ignore repeated constraints.
  end
end

AQ = A*Q;
btilde = b - AQ(:,1:rB)*z(1:rB);

% Now solve regular least squares, minnorm problem for z(rB+1:end)
%z(rB+1:end) = pinv(AQ(:,rB+1:end))*btilde;
z(rB+1:end) = lsmin(AQ(:,rB+1:end), btilde);

x = Q*z;
