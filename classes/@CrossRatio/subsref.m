function[varargout] = subsref(self, S)
% subsref -- Overloaded subsref method for CrossRatio
%
% varargout = subsref(self, S)
%
%     Enables evaluation of CrossRatio if input z is an array of numbers:
%
%     cr = self(z)

switch S(1).type
case '()'
  %if length(S(1).subs)==1 && isa(S(1).subs{1}, 'numeric')
  if isa(S(1).subs{1}, 'numeric')
    [varargout{1:nargout}] = self.evaluate(S(1).subs{:});
  else
    error('Cannot subscript CrossRatio with a non-numeric element');
  end
otherwise
  [varargout{1:nargout}] = builtin('subsref', self, S);
end
