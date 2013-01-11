function[x] = lsqi(A, b, B, d, eps)
% lsqi -- Solves a least-squares problem with quadratic inequality constraint.
%
% x = lsqi(A, b, B, D, eps)
%
%     Solves the problem 
%
%          min || A x - b ||_2, subject to || B x - d ||_2 \leq eps
%
%     using the generalized svd. A solution to this problem may not exist. This
%     function only works when size(A,1) >= size(A,2).

persistent newton
if isempty(newton)
  from labtools.rootfind import newton_raphson as newton
end

[m,n] = size(A);
bsize = length(b);
[p,n2] = size(B);
dsize = length(d);

%assert(m >= n, 'Not supported when A has more rows than columns');
assert(n==n2, 'Matrices A and B must have the same number of columns');
assert(m==bsize, 'Sizes of inputs A and b are inconsistent');
assert(p==dsize, 'Sizes of inputs B and d are inconsistent');
assert(eps >= 0, 'Tolerance eps must be non-negative');

[U,V,X,C,S] = gsvd(A, B);

% Do some transformations to form a pair of diagonal systems
btilde = U'*b;
dtilde = V'*d;

alphas = diag(C);
alphas_r = find(alphas > 0, 1, 'last');
betas = diag(S);
r = find(betas > 0, 1, 'last');

% We will try to find the solution for y = inv(X')*x;
y = zeros([n 1]);

% First case: the only feasible solutions satisfy norm(B*x - d) == eps, in
% which case we need only pick out the minimum norm solution from this subspace
% to norm(A*x-b), done via a QR-like procedure.
dtilde_residuals = sum(d(r+1:end).^2);
if dtilde_residuals > eps^2
  x = [];
  fprintf('System has no solution...aborting\n');
  return
elseif dtilde_residuals == eps
  y(1:r) = dtilde(1:r)./betas(1:r);
  y(r+1:alphas_r) = btilde(r+1:alphas_r)./alpahs(r+1:alpahs_r);
  x = inv(X')*y;
  return
end

% More complicated case: norm(B*x - d) < eps, but we have a strict minimizer
if r == n % Else, some betas are zero, and the following attempt will fail
  y(1:alphas_r) = btilde(1:alphas_r)./alphas(1:alphas_r);
  y(alphas_r+1:end) = dtilde(alphas_r+1:end)./betas(alphas_r+1:end);
  if sum((betas.*y(1:length(betas)) - dtilde(1:length(betas))).^2) + dtilde_residuals < eps^2;
    % Yay
    x = inv(X')*y;
    return
  end
  y(:) = 0;
end

% So now we have to solve the optimization problem on boundary of feasible set
% Define a nonlinear scalar function that we must optimize to find the Lagrange multiplier
numerators = alphas(1:r).*(betas(1:r).*btilde(1:r) - alphas(1:r).*dtilde(1:r));
denominators = @(lambda) alphas(1:r).^2 + lambda*betas(1:r).^2;
f = @(lambda) dtilde_residuals + sum((numerators./denominators(lambda)).^2) - eps^2;
df = @(lambda) sum(-2*numerators.^2./denominators(lambda).^3.*betas(1:r).^2);
lambda = newton(0, f, df);

q = length(betas);
y(1:q) = (alphas(1:q).*btilde(1:q) + lambda*betas(1:q).*dtilde(1:q))./(alphas(1:q).^2 + lambda*betas(1:q).^2);
y(q+1:n) = btilde(q+1:n)./alphas(q+1:n);
x = inv(X')*y;
