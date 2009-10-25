function[varargout] = subsref(self,s)
% subsref -- The overloaded method mimicking calling the PlotStyle
%     varargout = subsref(self,s)

switch s(1).type
case '()'
  for q = 1:length(s.subs)
    for qq = 1:self.N_properties
      set(s.subs{q}, self.props{qq}, self.values{qq});
    end
  end
case '.'
  varargout{1} = self.(s.subs);
otherwise
  error('Unrecognized subscripting of function');
end
