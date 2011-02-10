function disp(self)
% disp -- Display syntax for affine map

fprintf('Affine map from R^%d ----> R^%d\n', self.domain_dimension, self.range_dimension);
fprintf('                x |-----> A*x + b\n');
fprintf('\n  A = \n')
disp(self.A);
fprintf('\n  b = \n')
disp(self.b);
