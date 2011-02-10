classdef AffineMap
% AffineMap -- Class definition for an affine transformation
%
% self = AffineMap(A, b)
%
%     Defines an instance of a Euclidean affine transformation defining the map
%
%            x |------> A*x + b,
%
%     where the dimensions of the domain and range of the map are determined by
%     the size of the matrix A and vector b. 
%
%     If empty inputs make the size of the domain/range space unclear, the
%     descriptive variables corresponding to the dimensions are set to zero.

  properties(Access=private)
    domain_dimension;
    range_dimension;
    A;
    b;
  end
  methods(Access=private)
    out = evaluate(self, inp);
  end

  methods
    function self = AffineMap(A,b)
      if exist('b')
        b = b(:);
      else
        b = [];
      end
      if not(exist('A'))
        A = [];
      end
      if isempty(A) & isempty(b)
        self.A = 1;
        self.b = 0;
        self.range_dimension = 0;
        self.domain_dimension = 0;
      elseif isempty(A)
        self.A = 1;
        self.b = b;
        self.range_dimension = length(b);
        self.domain_dimension = 0;
      elseif isempty(b)
        self.A = A;
        [self.range_dimension self.domain_dimension] = size(A);
        self.b = zeros([self.range_dimension 1]);
      else
        self.A = A;
        self.b = b;
        [self.range_dimension self.domain_dimension] = size(A);
        if length(b) ~= self.range_dimension
          error('Inputs A and b do not have consistent dimensions');
        end
      end
    end

    varargout = subsref(self, varargin)
    [] = disp(self);

  end

end
