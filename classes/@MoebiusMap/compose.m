function[M] = compose(self, other)
% compose -- MoebiusMap compositions
%
% M = compose(self, other)
%
%     Given a second MoebiusMap named 'other', this returns the MoebiusMap M
%     that is 'self' composed with 'other': M = self o other.

M = MoebiusMap(self.H*other.H);

