function[w] = derivative(self, z)
% [w] = derivative(self, z)
%
%     Computes the derivative of the Moebius map w = f(z) defined by 
%     w = (a*z + b)/(c*z + d), where
%
%     self.H = [a  b]
%              [c  d]

H = self.H;

num = H(1,1)*z + H(1,2);  % az + b
den = H(2,1)*z + H(2,2);  % cz + d

w = num./den;
w(isinf(z)) = H(1,1)/H(2,1);

w = 1./den.*(H(1,1) - H(2,1)*w);
