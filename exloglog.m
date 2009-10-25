function[varargout] = exloglog(varargin);

% Implements the matlab loglog function, but does some 
% modification of the plot so that it's readable upon
% export;

hand = loglog(varargin{:});

for q = 1:length(hand);
  set(hand,'LineWidth',3);
  set(hand,'MarkerSize',20);
end

set(gca, 'FontSize', 14,'fontweight', 'b');

if nargout>=1;
  varargout{1} = hand;
end
