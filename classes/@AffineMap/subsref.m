function[varargout] = subsref(self,s);
% subsref -- The overloaded method mimicking function handle behavior
%     [varargout] = subsref(self,s);

if length(s)==1
  switch s(1).type
  case '()'
    for q = 1:length(s.subs);
      varargout{q} = self.evaluate(s.subs{q});
    end
  case '.'
    varargout{1} = getfield(self, s.subs{1});
  otherwise 
    error('Unrecognized subscripting of affine map');
  end
elseif length(s)==2  % This must be self.handle(input1, input2, ...)
  [varargout{1:nargout}] = self.handle(s(2).subs{:});
elseif length(s)>2  % Doesn't make sense here
  error('Invalid call syntax for affine map');
end
