classdef PlotStyle
% PlotStyle -- Defines a plotting style for matlab figures
%     obj = PlotStyle()
%     obj = PlotStyle('Keyword', 'Value', ...)
%     obj = PlotStyle(keyword_value_struct)
  properties
    props = {};
    values = {};
    N_properties = 0;
  end
  methods

    function self = PlotStyle(varargin)
    % PlotStyle -- Defines a plotting style for matlab figure
    %     obj = PlotStyle()
    %     obj = PlotStyle('Keyword', 'Value')
    %     obj = PlotStyle(keyword_value_struct)
    %
    %     Initializes PlotStyle object obj that defines a particular style for
    %     Matlab figures. obj(figure_handle) then sets the properties of that
    %     figure handle to the values defined by obj. The values defined by obj
    %     are set by inputting Keyword-Value pairs.

      if nargin==0
        self.props = {};
        self.values = {};
        self.N_properties = 0;
      else
        global handles;
        temp = handles.common.input_schema({}, {}, [], varargin{:});
        self.props = fieldnames(temp);
        self.N_properties = length(self.props);
        self.values = {};
        for q = 1:self.N_properties
          self.values{q} = getfield(temp,self.props{q});
        end
      end
    end

    varargout = subsref(self,varargin);

    [] = disp(self);

  end
end
