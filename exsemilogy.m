function[varargout] = exsemilogy(varargin);

% Implements the matlab semilogy function, but does some 
% modification of the plot so that it's readable upon
% export;

hand = semilogy(varargin{:});

for q = 1:length(hand);
  set(hand,'LineWidth',2);
  set(hand,'MarkerSize',15);
end

%set(gca, 'FontSize', 12,'fontweight', 'b');
set(gca, 'FontSize', 12, 'fontweight', 'b', 'FontName', 'Times');

if nargout>=1;
  varargout{1} = hand;
end
