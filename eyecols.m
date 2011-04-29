function[A] = eyecols(N,n)
% eyecols -- Returns certain columns of the identity matrix
%
% A = eyecols(N,n)
%
%     Let I be the N x N identity matrix (eye(N)). If n is a vector of positive
%     indices, this routine returns column indices n of the identity matrix. If
%     any indices are greater than N, those columns are zero.
%
%     eyecols(3,[1 2]) = 
%
%                1  0
%                0  1
%                0  0
%
%
%     eyecols(3, 3:5) = 
%
%                0  0  0
%                0  0  0
%                1  0  0

temp = speye(N);

Nflags = (n <= N);

A = zeros([N length(n)]);

A(:,Nflags) = full(temp(:,n(Nflags)));
