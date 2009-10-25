function[x] = triu_sparse_invert(s,b,varargin);
% [x] = triu_sparse_invert(s,b,{bandwidth=false});
%
%     Solves the square system S*X=B for X. S is assumed to be a sparse
%     upper-triangular matrix with number of diagonals equal to bandwidth. This
%     is done via sequential back-subsitution. If bandwidth is not given, it is
%     determined via a call to Matlab's spdiags.  Note that if possible
%     bandwidth should be given to speed up this function; it's purpose is to
%     invert the system quickly; calling spdiags is unnecessary overhead.
%
%     TODO: calling input_schema's slow too...make it faster by explicit narg
%     calculations? And fix enigmatic name?

global handles;
opt = handles.common.input_schema({'bandwidth'}, {false},[],varargin{:});

% If bandwidth isn't given, figure it out
if opt.bandwidth==false
  [temp,d] = spdiags(s);
  opt.bandwidth = max(d) + 1;
end

N = length(b);

x = zeros([N,1]);
x(N) = b(N)/s(N,N);

for q = (N-1):-1:max([(N-opt.bandwidth), 1])
  x(q) = (b(q) - s(q,q+1:end)*x(q+1:end))/s(q,q);
end

for q = (N-opt.bandwidth-1):-1:1
  x(q) = (b(q) - s(q,q+1:q+opt.bandwidth)*x(q+1:q+opt.bandwidth))/s(q,q);
end
