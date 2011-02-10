function out = evaluate(self, inp);
% evaluate -- Evaluates the affine map
% 
% y = evaluate(x)
%
%     Evaluates the affine map y = A*x + b.

if (self.domain_dimension == 1) & (self.range_dimension == 1)
  out = A*inp + b;  % Size of input doesn't matter
else
  % Size of input matters -- cannot operate in some cases
  [m,n] = size(inp);
  if m ~= self.domain_dimension
    error('Input dimensions are not consistent with affine map domain');
  end
  out = self.A*inp + repmat(self.b, [1 n]);
end
