function[B] = rank_pinv(A,varargin);
% rank_pinv -- Moore-Penrose pseudoinverse via rank specification
%
% B = rank_pinv(A, {{rank}})
%
%     Computes the Moore-Pensore pseudoinverse of a matrix A via the SVD. The
%     number of singular values retained is equal to the input `rank'. If `rank'
%     is not given, Matlab's pinv routine is called.

if nargin<2
  B = pinv(A);
else
  [u,s,v] = svd(A);
  B = U(:,1:rank)*S(1:rank,1:rank)*(V(:,1:rank)).';
end
