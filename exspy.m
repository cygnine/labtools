function[varargout] = exspy(varargin);

% Implements the matlab semilogy function, but does some 
% modification of the plot so that it's readable upon
% export;

spy(varargin{:},20);

%for q = 1:length(hand);
%  set(hand,'LineWidth',3);
%  set(hand,'MarkerSize',20);
%end

set(gca, 'FontSize', 16,'fontweight', 'b');

%if nargout>=1;
%  varargout{1} = hand;
%end
