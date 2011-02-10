function[x] = triu_back_substitute(U, b)
% triu_back_substitute -- Performs back-substitution on an upper-triangular system
%
% x = triu_back_substitute(U,b)
%
%     Uses back substitution to solve the linear system:
%
%              U*x = b,
%
%     for the vector x. U is assumed to be full and upper triangular; there is
%     no in-code check for this condition. Otherwise, a pretty straightforward
%     method. Naturally, the system must be square.

[M,N] = size(U);
if abs(M-N)>0
  error('The input matrix U must be square');
end
N = size(b,1);
if abs(M-N)>0
  error('The vector input b must have as many rows as the matrix U');
end

% If everything's fine, let's go:
x = zeros(size(b));
for q = N:(-1):1;
  x(q,:) = (b(q,:) - U(q,q+1:N)*x(q+1:N,:))/U(q,q);
end
