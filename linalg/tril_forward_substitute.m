function[x] = tril_forward_substitute(L, b)
% tril_forward_substitute -- Performs forward-substitution on a lower-triangular system
%
% x = tril_forward_substitute(L,b)
%
%     Uses forward substitution to solve the linear system:
%
%              L*x = b,
%
%     for the vector x. L is assumed to be full and lower triangular; there is
%     no in-code check for this condition. Otherwise, a pretty straightforward
%     method. Naturally, the system must be square.

[M,N] = size(L);
if abs(M-N)>0
  error('The input matrix L must be square');
end
N = size(b,1);
if abs(M-N)>0
  error('The vector input b must have as many rows as the matrix L');
end

% If everything's fine, let's go:
x = zeros(size(b));
for q = 1:N
  x(q,:) = (b(q,:) - L(q,1:q-1)*x(1:q-1,:))/L(q,q);
end
