function[values] = linear_integrator(x,y,z)
% linear_integrator -- Evaluates the piecewise linear integral
%
% values = linear_integrator(x,y,z)
%
%     Assuming that (x,y) form functional data, this function
%     integrates the function using linear interpolation and evaluates the
%     result at z. Extrapolation is used if z is out of bounds. The domain
%     values x should be sorted. The constant of integration is such that the
%     integral evaluated at x(1) is 0.
%
%     This is exact for a (pieceiwise) linear function.

x = x(:);
y = y(:);

zsize = size(z);
z = z(:);
N = length(z);

values = zeros([N 1]);

dx = diff(x);
dy = diff(y);
cumulative_additions = cumsum(1/2*dx.*(y(2:end) + y(1:end-1)));

[garbage, locations] = histc(z, [-Inf; x; Inf]);

x = [x(1); x];
cumulative_additions = [0; 0; cumulative_additions];

dy = [dy(1); dy; dy(end)];
dx = [dx(1); dx; dx(end)];
dy_scaled = dy./dx;
y = [y(1); y; y(end)];
%y_relative = y;

x_picked = x(locations);

values = cumulative_additions(locations) + ...
         y(locations).*(z-x_picked) + ...
         1/2*(z-x_picked).^2.*dy_scaled(locations);

values = reshape(values, zsize);
