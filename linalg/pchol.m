function[L,P] = pchol(A)
% pchol -- Full-pivoting Cholesky factorization
%
% [L,P] = pchol(A)
%
%     Computes pivot matrix P and lower-triangular matrix L so that PAP^T = LL^T.
%     The input matrix A must be square and positive semi-definite.

[M,N] = size(A);
if M~=N
  error('Input A must be a square matrix');
end

rank_tol = 1e-10;

L = zeros(N);
P = speye(N);

for n = 1:N
  temp_p = speye(N-n+1);

  diags = diag(A);
  
  [maxdiag, next_row] = max(abs(diags));
  if maxdiag < rank_tol
    L(n:N,n:N) = 0;
    break
  end

  % Permute rows/cols of A, and update permutation matrix P accordingly
  if next_row ~= 1
    temp_p([1 next_row], [1 next_row]) = [0 1; 1 0];
  end
  L(n:end,:) = temp_p*L(n:end,:);

  A = temp_p*A*temp_p';

  % Now first diagonal element is maximum
  if A(1,1) < 0
    error('Input A must be semi-definite');
  end

  % Update L matrix
  L(n,n) = sqrt(A(1,1));
  if n < N
    L(n+1:end, n) = 1/L(n,n)*A(2:end,1);
  end

  % Update A matrix
  A(2:end,2:end) = A(2:end,2:end) - 1/A(1,1)*A(2:end,1)*A(2:end,1)';

  % Update P matrix
  P(n:end,:) = temp_p*P(n:end,:);
  full(P);

  % Now remove row/col 1 of A
  A(:,1) = [];
  A(1,:) = [];
end
