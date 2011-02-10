function[] = figsave(handles,titles,directory);

%[] = figsave(handles,titles,directory);
% Saves figures as matlab figure files and as eps files
% handles is a numeric array, titles is a cell array, and
% directory is a string.
%
% By default, the width is scaled to 4 inches.
%
% acn

if directory(end)~='/';
  directory(end+1) = '/';
end

for q = 1:length(handles);
  saveas(handles(q), [directory titles{q}], 'fig');

  figure(handles(q));
  temp = axis;
  figsize = [temp(2) - temp(1), temp(4) - temp(3)];
  figsize = figsize/figsize(1)*4;

  set(handles(q), 'PaperPositionMode', 'manual');
  set(handles(q), 'Units', 'inches');
  set(handles(q), 'PaperUnits', 'inches');
  set(handles(q), 'PaperSize',figsize);
  set(handles(q), 'PaperPosition', [0,0, figsize]);
  saveas(handles(q), [directory titles{q}], 'pdf');
  saveas(handles(q), [directory titles{q}], 'epsc');
  saveas(handles(q), [directory titles{q}], 'jpg');
  
  %print(handles(q), '-depsc', '-r250', '-painters', [directory titles{q}]);
  %print(handles(q), '-dpdf', '-r250', [directory titles{q}]);
  %print(handles(q), '-djpeg', '-r250', '-painters', [directory titles{q}]);
end
