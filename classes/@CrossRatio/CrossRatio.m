classdef CrossRatio < SimpleSingleton
% CrossRatio -- Functional cross ratio representation
%
% C = CrossRatio()
%
%      Returns a singleton instance of a cross-ratio. I.e. this is a class
%      representation of the cross-ratio function. If z is a vector of length 4,
%      the cross-ratio of the entries is defined as
%
%            [z(1) - z(2)] * [z(2) - z(4)]
%       C =  -----------------------------
%            [z(2) - z(3)] * [z(1) - z(4)]
%
%      This class also supports other common operations: Jacobians.
%
%      Two calling syntaxes are supported:
%       >> CR = CrossRatio.instance()
%       >> C = CR(z);
%       >> C = CR(z(1), z(2), z(3), z(4));

  methods
    function[self] = CrossRatio(varargin)
      persistent obj
      if not(isempty(obj))
        self = obj; return;
      end

      obj = self;
    end
  end
  methods
    cr = evaluate(self, varargin)
    cr = jacobian(self, varargin)
    cr = subsref(self,varargin)
  end
end
