function[q,r] = givens_qr(v, varargin)
% givens_qr -- Computes the QR decomposition using Givens rotations
%
% [q,r] = givens_qr(v, [ip=[]])
%
%     Performs a sequence of Givens rotations on the M x N matrix v to reduce it
%     to upper-triangular form. The inner product is used to modify the usual
%     Euclidean Givens rotations. To give a different inner product, set the
%     optional input ip to a function handle so that ip(v1,v2) yields a
%     scalar-valued inner product when v1 and v2 are column vectors. 
%
% TODO: Actually implement different inner product


persistent strict_inputs givens apply_givens right_apply_givens
persistent default_ip
if isempty(strict_inputs)
  from labtools import strict_inputs
  from labtools.linalg import givens apply_givens right_apply_givens
  default_ip = @(x,y) y'*x;
end

opt = strict_inputs({'ip'}, {default_ip}, [], varargin{:});

[m,n] = size(v);
mn = max([m,n]);

q = eye(m);
r = [v rand([m mn-n])];

for p = 1:mn
  % As of now, this is not parallelized
  for pp = m:-1:(p+1)
    [G,res] = givens(r([pp-1 pp],p));

    r = apply_givens(r, G, pp-1, pp, p, res);
    q = right_apply_givens(q, G', pp-1, pp);
  end
end

q = q(:,1:m);
r = r(1:m,1:n);
