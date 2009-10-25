function[varargout] = exsemilogx(varargin);

% Implements the matlab semilogx function, but does some 
% modification of the plot so that it's readable upon
% export;

hand = semilogx(varargin{:});

for q = 1:length(hand);
  set(hand,'LineWidth',3);
  set(hand,'MarkerSize',20);
end

%set(gca, 'FontSize', 12,'fontweight', 'b');
set(gca, 'FontSize', 16, 'fontweight', 'b', 'FontName', 'Times');

if nargout>=1;
  varargout{1} = hand;
end
