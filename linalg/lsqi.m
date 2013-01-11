function[x] = lsqi(A, b, B, d, eps)
% lsqi -- Solves a least-squares problem with quadratic inequality constraint.
%
% x = lsqi(A, b, B, D, eps)
%
%     Solves the problem 
%
%          min || A x - b ||_2, subject to || B x - d ||_2 \leq eps
%
%     using the generalized svd. A solution to this problem may not exist. When
%     many solutions exist, the one with smallest Euclidean norm is returned.

persistent newton
if isempty(newton)
  from labtools.rootfind import newton_raphson as newton
end

[m,p] = size(A);
bsize = length(b);
[n,p2] = size(B);
dsize = length(d);

sv_tol = 1e-9;

%assert(m >= n, 'Not supported when A has more rows than columns');
assert(p==p2, 'Matrices A and B must have the same number of columns');
assert(m==bsize, 'Sizes of inputs A and b are inconsistent');
assert(n==dsize, 'Sizes of inputs B and d are inconsistent');
assert(eps >= 0, 'Tolerance eps must be non-negative');

[U,V,X,C,S] = gsvd(A, B);
X = X'; % My notation
% A = U C X
% B = V S X
[q,p] = size(X);

% Do some transformations to form a pair of diagonal systems
btilde = U'*b;
dtilde = V'*d;

if size(C,1) > 1
  %c = [zeros([p-q 1]); diag(C, p-q)];
  c = [zeros([q-m 1]); diag(C, max([p-m 0]))];
else
  c = [zeros([q-m 1]); C(end)];
end
rA = q - find(c > sv_tol, 1, 'first') + 1;
if all(size(S,2) > 1)
  s = [diag(S); zeros([q - size(S,1) 1])];
else
  s = [s(1); zeros([q - size(S,1) 1])];
end
rB = find(s > sv_tol, 1, 'last');

% We will try to find the solution y satisfying y = X x
y = zeros([q 1]);

% Extend btilde and dtilde
btilde = [zeros([q-m 1]); btilde];
dtilde = [dtilde; zeros([q-n 1])];

% First case: the only feasible solutions satisfy norm(B*x - d) == eps, in
% which case we need only pick out the minimum norm solution from this subspace
% to norm(A*x-b), done via a QR-like procedure.
dtilde_residuals = sum(dtilde(rB+1:end).^2);
if dtilde_residuals > eps^2
  fprintf('System has no solution...smallest error tolerance eps possible is %1.4e. Returning this vector.\n', sqrt(dtilde_residuals));

  y(1:rB) = dtilde(1:rB)./s(1:rB);
  last_indices = [max([rB+1 q-rA+1]):q]';
  y(last_indices) = btilde(last_indices)./c(last_indices);

elseif dtilde_residuals == eps
  y(1:rB) = dtilde(1:rB)./s(1:rB);
  last_indices = [max([rB+1 q-rA+1]):q]';
  y(last_indices) = btilde(last_indices)./c(last_indices);

else
  % More complicated case: norm(B*x - d) < eps, but we have a strict minimizer
  
  % Try the following solution:
  first_indices = [1:min([rB,q-rA])]';
  y(first_indices) = dtilde(first_indices)./s(first_indices);
  y(q-rA+1:end) = btilde(q-rA+1:q)./c(q-rA+1:end);

  if norm(s(1:q).*y(1:q) - dtilde(1:q))^2 <= eps^2;
    % Yay, done
  else
    y(:) = 0;

    % So now we have to solve the optimization problem on boundary of feasible set
    % Define a nonlinear scalar function that we must optimize to find the Lagrange multiplier
    i1 = q - rA + 1; 
    i2 = rB;
    numerators = c(i1:i2).*(s(i1:i2).*btilde(i1:i2) - c(i1:i2).*dtilde(i1:i2));
    denominators = @(lambda) c(i1:i2).^2 + lambda*s(i1:i2).^2;
    f = @(lambda) dtilde_residuals + sum((numerators./denominators(lambda)).^2) - eps^2;
    df = @(lambda) sum(-2*numerators.^2./denominators(lambda).^3.*s(i1:i2).^2);
    lambda = newton(0, f, df);

    y(i1:i2) = (c(i1:i2).*btilde(i1:i2) + lambda*s(i1:i2).*dtilde(i1:i2))./(c(i1:i2).^2 + lambda*s(i1:i2).^2);

    % And now the two simple cases
    i1 = 1;
    i2 = min([rB, q - rA]);
    y(i1:i2) = dtilde(i1:i2)./s(i1:i2);
    
    i1 = max([rB+1 q - rA+1]);
    i2 = q;
    y(i1:i2) = btilde(i1:i2)./c(i1:i2);
  end
end

% Now that we've solved for y, we can determine x

rX = rank(X, sv_tol);
if p == rX
  % Easy: invert
  x = X\y;
elseif q == rX % full row rank
  % First permute solutions so that 'arbitrary' assignments to y are put at bottom of vector

  null_set = [(rB+1):(q-rA)]'; % Indices where we can arbitrarily assign y
  if isempty(null_set)
    % don't do anything -- there are no extra degrees of freedom
    %P = speye(q);
    last_ind = q;
  else
    after_null = [null_set(end):q]';

    y = y([1:rB; after_null; null_set]);
    X = [X(:,1:rB) X(:,after_null) X(:,null_set)];

    last_ind = q - length(null_set);
  end

  % Now y and X are permuted so that the degrees of freedom are at the end.

  % Get LQ decomposition for X
  [Q,L] = qr(X');
  L = L';

  % Only the first q columns of L should be nonempty
  Ltilde = L(1:last_ind,1:last_ind);
  z = zeros([p 1]);
  z(1:last_ind) = Ltilde\y;
  x = Q*z;

else % Neither full column nor row rank
  error('Not yet coded when X from gsvd has incomplete row rank');
end
