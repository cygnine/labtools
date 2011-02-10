function[w] = evaluate(self, z)
% evaluate -- Evaluation of MoebiusMap 
%
% [w] = evaluate(self, z)
%
%     Implements the Moebius map w = f(z) defined by
%     w = (a*z + b)/(c*z+d), where
%
%     self.H = [a  b]
%              [c  d]

H = self.H;

w = (H(1,1)*z + H(1,2))./(H(2,1)*z + H(2,2));
w(isinf(z)) = H(1,1)/H(2,1);
