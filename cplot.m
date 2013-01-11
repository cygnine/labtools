function h = ccplot(x,y,c,varargin)
% cplot Conditionally colored plot
% 
%   h = cplot(x,y,cval, 'key', 'value', ) plots the vector y versus
%   vector x using coloring based on the values in the vector cval.
%   cplot maps each value in the vector cval to a certain color of the
%   specified colormap cmap. Linear color interpolation is used between
%   data points.
%
%   cplot returns handles to the line objects that can be used to
%   change properties via set(...)
%
%   Examples:
%       x = linspace(0,4*pi,50);
%       y = sin(x);
%       c = y.^2;
%       h = ccplot(x,y,c, 'linewidth', 2);
    
    if ~(all(size(x) == size(y)) && all(size(x) == size(c)))
        error('Vectors X,Y and C must be the same size');
    end
    if min(size(x)) ~= 1
      error('X, Y, and C must be vectors');
    end

    x = x(:).';
    y = y(:).';
    c = c(:).';
    x2 = [x(1:end-1); 
          x(2:end)];
    y2 = [y(1:end-1);
          y(2:end)];
    c2 = [c(1:end-1); 
          c(2:end)];

    h = patch(x2, y2, c2, 'edgecolor', 'interp', varargin{:});
    set(gcf, 'renderer', 'zbuffer');
end
