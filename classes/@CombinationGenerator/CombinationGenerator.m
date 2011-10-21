classdef CombinationGenerator < handle
% CombinationGenerator -- generator for a list of combinations
%
% self = CombinationGenerator(v1, v2, ...)
%
%     Given vectors v1, v2, ..., vN of any lengths, sequentially returns all
%     combinations of N-vectors, where entry j is chosen from vj. Upon
%     exhaustion of all combinations, this method returns empty vectors.
%
%     E.g.: 
%
%     >> G = CombinationGenerator([1,2,3], [-1,-2]);
%     >> G.next();
%
%      ans = 
%
%         1     -1
%
%     >> G.next();
%
%      ans = 
%
%         1     -2
%
%     >> G.next(3);
%
%      ans = 
%
%         2     -1
%         2     -2
%         3     -1

properties(SetAccess=private)
  set_cardinality
  N
  vectors
end
properties(Access=private)
  current_coordinate
  vector_lengths
  ghost_array
  ghost_array_size
  next_coordinate
  first_nontrivial_index
end
methods
  function[self] = CombinationGenerator(varargin)
    self.vectors = varargin;
    self.N = nargin;
    % Make sure they're all vectors:
    self.vector_lengths = zeros([self.N 1]);
    for q = 1:self.N
      if isnumeric(self.vectors{q});
        self.vectors{q} = self.vectors{q}(:);
        self.vector_lengths(q) = length(self.vectors{q});
      else
        error('All inputs must be numeric-type arrays');
      end
    end
    self.current_coordinate = ones([self.N 1]);

    self.ghost_array_size = [max(self.vector_lengths) self.N];
    self.ghost_array = zeros(self.ghost_array_size);
    for q = 1:self.N;
      self.ghost_array(1:self.vector_lengths(q),q) = self.vectors{q};
    end
    self.first_nontrivial_index = find(self.vector_lengths > 1, 1, 'last');
    self.next_coordinate = self.first_nontrivial_index;
    self.set_cardinality = prod(self.vector_lengths);
  end

  a = next(self,varargin);
end

end
