function[] = crop_export(fhandle, fname, fsize)
% crop_export -- Crops a figure for export
%
% crop_export(fhandle, fname, [[ fsize ]])
%
%     Crops the given figure specified by the handle fhandle. The crop procedure
%     is tight: it stretches the axes flush against the figure border. If you
%     run 'axis off' before calling this, then just the image is stretched.
%     After cropping, the file is saved calling the builtin saveas using the
%     filename fname, with a paper (image) size of fsize. The input fsize is
%     optional.

figure(fhandle);
ax_position = get(gca, 'position');
f_position = get(gcf, 'paperposition');
set(gca, 'position', [0.005 0.005 0.99 0.99]);
if nargin > 2
  set(fhandle, 'papersize', fsize);
  set(fhandle, 'paperposition', [0 0 fsize]);
end
if strcmpi(fname(end-2:end), 'pdf')
  % Use print
  print(fhandle, '-dpdf', '-r300', fname);
else
  saveas(fhandle, fname);
end
set(gca, 'position', ax_position);
set(fhandle, 'paperposition', f_position);
