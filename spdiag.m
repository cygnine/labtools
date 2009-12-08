function[S] = spdiag(V)
% spdiag -- A faster but severely hobbled version of spdiags
%
% S = spdiag(V)
%
%     Given a vector V of length N, returns a sparse N x N matrix S with V as
%     the diagonal.

V = V(:);
N = length(V);
S = spalloc(N,N,N);

indices = (0:(N-1))*N + (1:N);

S(indices) = V;
