classdef MoebiusMap

  properties(SetAccess=protected)
    H
  end

  methods 
    function self = MoebiusMap(varargin)
    % MoebiusMap -- Moebius maps on the complex plane
    %
    % M = MoebiusMap(z, w)
    %     Returns the Moebius map M connecting the length-3 vectors z and w so that
    %     w = M(z). All elements in z (as well as w) must be distinct. Values of Inf
    %     are allowed.
    %
    % M = MoebiusMap(H)
    %     Returns the Moebius map M that is defined by the 2 x 2 matrix H such that
    %
    %               H(1,1)*z + H(1,2)
    %       M(z) =  -----------------
    %               H(2,1)*z + H(2,2)
      
      self.H = zeros(2);
      if nargin==1
        assert(all(size(varargin{1})==[2,2]), ...
           'The given matrix must be 2 x 2');
        
        self.H = varargin{1};
      elseif nargin==2
        assert((length(varargin{1})==3) & (length(varargin{2})==3), ...
           'The two inputs must be length-3 vectors');

        self = specify_points(self, varargin{1}, varargin{2});
      else
        error('Too many input arguments...MoebiusMap takes either 1 or 2 inputs');
      end

    end

    M = inv(self);
    M = compose(self, other)
    w = evaluate(self, z)
    M = subsref(self,z)
    w = derivative(self,z)
  end

  methods(Access=private)
    self = specify_points(self, points, images)
    [points, map] = finitize_points(self, points)
  end

end
