function[] = square_figsave(handles,titles,directory);
% square_figure -- Saves square figures without axes or labels
%
% [] = figsave(handles,titles,directory);
%     Saves figures as matlab figure files and as eps files
%     handles is a numeric array, titles is a cell array, and
%     directory is a string.

if directory(end)~='/';
  directory(end+1) = '/';
end

for q = 1:length(handles);
  saveas(handles(q), [directory titles{q}], 'fig');
  set(handles(q), 'PaperPositionMode', 'manual');
  set(handles(q), 'PaperSize', [4 4]);
  set(handles(q), 'PaperPosition', [0 0 4 4]);
  %figure(handles(q));
  set(get(handles(q), 'Children'), 'Position', [0 0 1 1]);
  %set(gca, 'OuterPosition', [0 0 1 1]);
  set(handles(q), 'Units', 'inches');
  set(handles(q), 'PaperUnits', 'inches');

  saveas(handles(q), [directory titles{q}], 'pdf');
  saveas(handles(q), [directory titles{q}], 'epsc');
  saveas(handles(q), [directory titles{q}], 'jpg');
  
  %print(handles(q), '-depsc', '-r250', '-painters', [directory titles{q}]);
  %print(handles(q), '-dpdf', '-r250', [directory titles{q}]);
  %print(handles(q), '-djpeg', '-r250', '-painters', [directory titles{q}]);
end
