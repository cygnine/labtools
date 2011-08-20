function[varargout] = inv(self, varargin)
% inv -- Overloaded method for MoebiusMap
%
% M = inv(self)
%
%     Returns the MoebiusMap M that is the inverse map of self.

H = self.H;
H2 = [H(2,2) -H(1,2);
     -H(2,1) H(1,1)];

M = MoebiusMap(H2);

if length(varargin) > 0
  [varargout{1:nargout}] = M.evaluate(varargin{:});
else
  varargout{1} = M;
end
