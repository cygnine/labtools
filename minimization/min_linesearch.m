function[eps, varargout] = min_linesearch(v, w, obj, epsmax);
% min_linesearch -- Minimizing linesearch algorithm
%
% eps = min_linesearch(v, w, obj, epsmax)
%
%     Given a starting point v, returns the positive scalar eps such that (v +
%     eps*w) minimizes the objective function given by the handle obj. The
%     search is a global bisection approach over the interval eps \in [0,
%     epsmax].

naout = nargout - 1;

% Golden ratio
gr = 1/2*(1+sqrt(5));

% Find objective fcn values at endpoints:
Nt = size(v,1);

eps_left = 0;
eps_right = epsmax;

v_left = v + eps_left*w;
v_right = v + eps_right*w;
%theta_left = thetas_from_v(v_left);
%theta_right = thetas_from_v(v_right);

int_length = epsmax;
tol_length = 1e-2;
min_length = 0;

eps_midleft = eps_right - 1/gr*int_length;
eps_midright = eps_left + 1/gr*int_length;
v_midleft = v + eps_midleft*w;
v_midright = v + eps_midright*w;

obj_left = 0;
obj_midleft = 0;
obj_right = 0;
obj_midright = 0;

nout_left = cell([naout-1 1]);
nout_midleft = cell([naout-1 1]);
nout_midright = cell([naout-1 1]);

[obj_left, nout_left{1:naout-1}] = obj(v_left);
obj_right = obj(v_right);
[obj_midright, nout_midright{1:naout-1}] = obj(v_midright);
[obj_midleft, nout_midleft{1:naout-1}] = obj(v_midleft);

while (int_length/eps_right>tol_length) & (int_length > min_length)
  % Discard one of the two endpoints
  if obj_left > obj_right
    % Discard left:
    [obj_left, eps_left] = deal(obj_midleft, eps_midleft);
    nout_left = nout_midleft;

    int_length = 1/gr*int_length;
    [obj_midleft, eps_midleft] = deal(obj_midright, eps_midright);
    nout_midleft = nout_midright;

    eps_midright = eps_left + 1/gr*int_length;
    v_midright = v + eps_midright*w;
    [obj_midright, nout_midright{1:naout-1}] = obj(v_midright);

  else
    % Discard right:
    [obj_right, eps_right] = deal(obj_midright, eps_midright);

    int_length = 1/gr*int_length;
    [obj_midright, eps_midright] = deal(obj_midleft, eps_midleft);
    nout_midright = nout_midleft;

    eps_midleft = eps_right - 1/gr*int_length;
    v_midleft = v + eps_midleft*w;
    [obj_midleft, nout_midleft{1:naout-1}] = obj(v_midleft);
  end

  % For debugging:
  %fprintf('[%1.3e, %1.3e]\n', eps_left, eps_right);

end

eps = eps_left;
varargout{1} = obj_left;
[varargout{2:naout}] = nout_left{:};
