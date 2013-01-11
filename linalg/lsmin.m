function[x] = lsmin(A, b)
% lsmin -- Solves the least-squares minimum-norm problem
%
% x = lsmin(A, b)
% 
%     Solves the problem:
%
%       Minimize || x ||_2 subject to minimizing || A x - b ||_2
%
%     This does the same thing as pinv(A)*b. (But is cheaper)

[m,n] = size(A);
assert(length(b)==m, 'Sizes of inputs A and b are inconsistent');

% First find subpsace that minimizes || A x - b ||_2
[Q,R] = qr(A);
btilde = Q'*b;

% || A x - b || == || R x - btilde ||
rA = rank(R);

% Do LQ factorization of truncated R to obtain:
% || L Q' x - btilde || = || L z - btilde ||, 
% with z = Q'*x
[Q2,L] = qr(R(1:rA,:)');
L = L';
z = zeros([n 1]);

rL = rank(L);
z(1:rL) = L(1:rL,1:rL)\btilde(1:rA);

x = Q2*z;
