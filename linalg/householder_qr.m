function[q,r] = householder_qr(v, varargin)
% householder_qr -- Computes the QR factorization via Householder reflections
%
% [q,r] = householder_qr(v, [ip=[]])
%
%     Uses successive Householder reflections to compute the QR factorization of
%     the M x N matrix v. The inner product is used to modify the usual
%     Euclidean Householder reflection. To give a different inner product, set
%     the optional input ip to a function handle so that ip(v1,v2) yields a
%     scalar-valued inner product when v1 and v2 are column vectors. 
%
% TODO: Actually implement different inner products

persistent strict_inputs default_ip
if isempty(strict_inputs)
  from labtools import strict_inputs
  default_ip = @(x,y) y'*x;
end

opt = strict_inputs({'ip'}, {default_ip}, [], varargin{:});

[m,n] = size(v);
mn = max([m,n]);

q = eye(m);
r = [v rand([m mn-n])];
e1 = zeros([m 1]);
e1(1) = 1;

for p = 1:min([m,n])
  % Construct Householder reflector matrix H
  alpha = norm(r(p:end,p));
  alpha = -sign(r(p,p))*alpha;
  v = r(p:end,p) - alpha*e1;
  v = v/norm(v);
  H = eye(m-p+1) - 2*v*v';

  r(p:end,p:end) = H*r(p:end,p:end);
  q(:,p:end) = q(:,p:end)*(H');

  e1(end) = [];
end

q = q(:,1:m);
r = r(1:m,1:n);
