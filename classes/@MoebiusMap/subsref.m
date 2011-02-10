function[varargout] = subsref(self, S)
% subsref -- Overloaded subsref method for MoebiusMap
%
% varargout = subsref(self, S)
%
%     Enables evaluation of MoebiusMap if input z is an array of numbers:
%
%     w = self(z)
%
%     Also enables composition with other MoebiusMap elements:
%
%     M = self(other)

switch S(1).type
case '()'
  if length(S(1).subs)==1 && isa(S(1).subs{1}, 'numeric')
    [varargout{1:nargout}] = self.evaluate(S(1).subs{1});
  elseif length(S(1).subs)==1 && isa(S(1).subs{1}, 'MoebiusMap')
    [varargout{1:nargout}] = self.compose(S(1).subs{1});
  else
    error('Cannot subscript MoebiusMap with a non-numeric, non-MoebiusMap element');
  end
%case '.'
%  [varargout{1:nargout}] = self.(S(1).subs);
otherwise
  [varargout{1:nargout}] = builtin('subsref', self, S);
end
