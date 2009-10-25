function[] = disp(obj)
%  disp -- Displays keyword/value pairs for a PlotStyle
%      [] = disp(obj)

for q = 1:obj.N_properties
  if ischar(obj.values{q})
    fprintf('%-40s : %-40s\n', obj.props{q}, obj.values{q});
  elseif islogical(obj.values{q}) | isnumeric(obj.values{q})
    fprintf('%-40s : %-40d\n', obj.props{q}, obj.values{q});
  else
    fprintf('%-40s : ', obj.properties{q});
    disp(obj.values{q});
  end
end

fprintf('\n');
