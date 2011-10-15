function[] = contourplot_update(chandle, N)
% contourplot_update -- Updates LevelList properties for contour plots
%
% contourplot_update(chandle, [[ N = length(get(chandle, 'levellist')) ]] )
%
%     Given a contour plot handle chandle, this function redefines the LevelList
%     property of the contour plot handle to be N equispaced points over the
%     values spanned by the contour plot ZData property. If N is not specified,
%     then it is set to the current length of the LevelList property.

if nargin < 2
  N = length(get(chandle, 'levellist'));
end

temp = get(chandle, 'zdata');
temp = temp(:);
set(chandle, 'levellistmode', 'manual', 'levellist', linspace(min(temp), max(temp), N));
