function[S] = block_spdiag(D, weights)
% block_spdiag -- Constructs a sparse block-diagonal matrix
%
% S = block_spdiag(D, weights)
%
%     D should be a square matrix of size N x N. Weights should be a length K
%     vector. S is then an (N*K) x (N*K) sparse block-diagonal matrix, with each
%     block being weights(q)*D for each q.

assert(size(D,1)==size(D,2), 'Error: Input D must be a square matrix');

N = size(D,1);
K = length(weights);

S = spalloc(N*K, N*K, N^2*K);

for q = 1:K;
  i1 = (q-1)*N + 1;
  i2 = q*N;
  S(i1:i2, i1:i2) = weights(q)*D;
end
