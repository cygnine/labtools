function[l,a,p] = mlu(a, varargin)
% mlu -- A user-written LU factorization routine with partial pivoting
%
% [l,u,p] = mlu(a, [pivot=true])
%
%     Performs the LU decomposition using the Dolittle algorithm. Partial
%     pivoting is performed when the optional input "pivot" is true. The output
%     matrices form the LUP decomposition so that p*a = l*u.
%
%     If pivoting is turned off, a warning is displayed if the routine runs into
%     numerical trouble (TODO).

persistent strict_inputs
if isempty(strict_inputs)
  from labtools import strict_inputs
end

opt = strict_inputs({'pivot'}, {true}, [], varargin{:});
pivot = opt.pivot;

[m,n] = size(a);
l = eye(m);
vtemp = zeros([1 n]);
stemp = spalloc(1, m, 2);
p = speye(m);

for q = 1:min([m,n])

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %%%%%%%%%%    PIVOTING    %%%%%%%%%% 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  % If pivoting is allowed, pick the appropriate row in the column q with the
  % largest magnitude.
  if pivot
    [garbage, pivot_row] = max(abs(a(q:end,q)));
    pivot_row = pivot_row + (q-1);
  else
    pivot_row = q;
  end

  % Must actually rearrange matrix taking into account pivots:
  vtemp = a(pivot_row,:);
  a(pivot_row,:) = a(q,:);
  a(q,:) = vtemp;

  % Deal with l matrix
  vtemp = l(pivot_row,:);
  l(pivot_row,1:q-1) = l(q,1:q-1);
  l(q,1:q-1) = vtemp(1:(q-1));

  % Deal with permutation matrix
  stemp(:,:) = p(q,:);
  p(q,:) = p(pivot_row,:);
  p(pivot_row,:) = stemp;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %%%%%%%%%%  END PIVOTING  %%%%%%%%%% 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  % Find multiplicative factors
  factors = -a(q+1:end,q)/a(q,q);

  % Guass-eliminate a
  a(q+1:end,q:end) = a(q+1:end,q:end) + factors*a(q,q:end);

  % Tack on this inverse to all previous inverses
  l(q:m,q) = l(q:m,q:end)*[1; -factors];
end

if m>n
  l = l(:,1:n);
  a = a(1:n,:);
end
