% Script to test sparse inversion

global handles;
la = handles.common.linalg;

N = 20;
bandwidth = 5;
B = rand([N,bandwidth]);
s = spdiags(B,0:(bandwidth-1),N,N);

b = rand([N,1]);

using_inv = inv(full(s))*b;

using_fun = la.triu_sparse_invert(s,b,'bandwidth',bandwidth);

fprintf('Error is %1.e3\n', norm(using_inv - using_fun));
