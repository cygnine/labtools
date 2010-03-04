function[q,r] = mqr(v, varargin)
% mqr -- A user implementation of the QR decomposition ("Modified" QR)
%
% [q,r] = mqr(v, [ip=[], method='mgs'])
%
%     Performs the QR decomposition on the N x P matrix v. Each column of V is
%     orthogonalized with respect to the other columns. The method of
%     orthogonalization is chosen by the optional input "method". The
%     possibilities are:
%
%        'mgs', 'gs'          -- (Modified) Gram-Schmidt orthogonalization
%        'givens'             -- Givens rotations
%        'hh', 'householder'  -- Householder reflections
%
%     The inner product assumed is the Euclidean inner product on R^N. If
%     desired, the user may specify a function handle as the optional input "ip"
%     to replace the Euclidean inner product. Then for two length-N column
%     vectors v1 and v2, ip(v1, v2) should return the scalar-valued inner
%     product.
%
%     No error checking of any kind is performed at this stage.

persistent gram_schmidt givens househoulder strict_inputs default_ip
if isempty(ip)
  from labtools.linalg import gram_schmidt
  %from labtools.linalg import givens householder
  from labtools import strict_inputs

  default_ip = @(x,y) y'*x;  % The Euclidean inner product
end

opt = strict_inputs({'method', 'ip'}, {'mgs', default_ip}, [], varargin{:});

switch method
case {[], 'mgs', 'gs'}
  method = gram_schmidt
case 'givens'
  error('Not yet implemented');
  method = givens
case {'householder', 'hh'}
  error('Not yet implemented');
  method = householder
end

[q,r] = method(v, 'ip', opt.ip);
