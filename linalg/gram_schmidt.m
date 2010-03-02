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

persistent strict_inputs default_ip crop
if isempty(strict_inputs)
  from labtools import strict_inputs crop
  default_ip = @(x,y) y'*x;
end

opt = strict_inputs({'ip'}, {default_ip}, [], varargin{:});
ip = opt.ip;

[m,n] = size(v);

% Allocation
q = v;
if m>n
  q = [q rand([m, m-n])];
end
r = crop(eye(max([m,n])), [m,n]);

for p = 1:n
  % Unfortunately, I don't know how to do this in a vectorized manner:
  for pp = 1:min((p-1), m)
    proj = ip(q(:,p), q(:,pp));
    q(:,p) = q(:,p) - proj*q(:,pp);
    r(pp,p) = proj;
  end
  
  mag = ip(q(:,p), q(:,p));
  q(:,p) = 1/sqrt(mag)*q(:,p);
  if p <= m
    r(p,:) = sqrt(mag)*r(p,:);
  end
end

% Now the remaining columns of q aren't orthonormal. Orthonormalize them without
% touching r:
if m>n
  for p = (n+1):m
    for pp = 1:(p-1)
      proj = ip(q(:,p), q(:,pp));
      q(:,p) = q(:,p) - proj*q(:,pp);
    end

    mag = ip(q(:,p), q(:,p));
    q(:,p) = 1/sqrt(mag)*q(:,p);
  end
end

% And truncate q:
q = q(:,1:m);
