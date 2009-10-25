function[varargout] = exmesh(varargin);

% Implements the matlab mesh function, but does some 
% modification of the plot so that it's readable upon
% export;

hand = mesh(varargin{:});

for q = 1:length(hand);
  set(hand,'LineWidth',3);
  set(hand,'MarkerSize',20);
end

set(gca, 'FontSize', 16, 'fontweight', 'b', 'FontName', 'Times');

if nargout>=1;
  varargout{1} = hand;
end
