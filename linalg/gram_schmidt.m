function[q,r] = gram_schmidt(v, varargin)
% gram_schmidt -- A user implementation of Gram-Schmidt
%
% [q,r] = gram_schmidt(v, [ip=[]])
%
%     Performs the (modified) Gram-Schdmit orthogonalization process on the N x
%     P matrix v. The columns are orthogonalized with respect to some inner
%     product and returned in the N x N matrix q. The default inner product is
%     the Euclidean inner product. The user may specify an inner product by
%     setting the optional input "ip" to a function handle. Then for two
%     length-N column vectors v1 and v2, ip(v1, v2) should return the
%     scalar-valued inner product.

persistent strict_inputs default_ip crop spdiag
if isempty(strict_inputs)
  from labtools import strict_inputs crop spdiag
  default_ip = @(x,y) y'*x;
end

opt = strict_inputs({'ip'}, {default_ip}, [], varargin{:});
ip = opt.ip;

[m,n] = size(v);
mn = max([m,n]);

% Allocation
q = v;
if m>n
  q = [q rand([m, m-n])];
end
r = eye(mn);

for p = 1:mn
  % Normalize the next vector
  mag = ip(q(:,p), q(:,p));
  q(:,p) = 1/sqrt(mag)*q(:,p);
  r(p,:) = sqrt(mag)*r(p,:);

  % Project out components on this normalized vector
  inds = (p+1):mn;
  proj = ip(q(:,inds), q(:,p));
  r(p,inds) = proj.';
  q(:,inds) = q(:,inds) - repmat(q(:,p), [1 length(inds)])*spdiag(proj);
end

% And truncate q, r:
q = q(:,1:m);
r = crop(r, [m,n]);
