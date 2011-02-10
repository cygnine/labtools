function[] = latex_tabular(fname, data, varargin)
% latex_tabular -- Writes a tex tabular array of the given data
%
% [] = latex_tabular(fname, data, [fmt='1.5E', rows={}, cols={}])
%
%     Writes the data in the 2-D array "data" to the filename specified by
%     fname. The data format is given by the optional input fmt, and row and
%     columns headers can be specified by the optional inputs "rows", "cols".
%     Note that length(rows) must be the same as size(data,1), and the same for
%     the columns.
%
%     NOTE: the file given by fname is created if necessary, and any contents
%     are discarded.

persistent strict_inputs
if isempty(strict_inputs)
  from labtools import strict_inputs
end

opt = strict_inputs({'fmt', 'rows', 'cols'}, {'1.5E', [], []}, [], varargin{:});

fid = fopen(fname, 'w');
[R,C] = size(data);
if not(isempty(opt.rows))
  assert(length(opt.rows)==R, 'Error: you must specify as many row headers as there are rows in the data');
  assert(length(opt.cols)==C, 'Error: you must specify as many column headers as there are columns in the data');
end

opt.fmt = strcat(' ', opt.fmt, ' ');

% Create tabular characterization and also create row format
fprintf(fid,'\\begin{tabular}{');
fmt = '';
if not(isempty(opt.rows))
  fprintf(fid, 'l');
end
for q = 1:C
  fprintf(fid, 'c');

  fmt = [fmt, ' %', opt.fmt, ' '];
  if q<C;
    fmt = [fmt, '&'];
  end
end
fmt = [fmt, '\\\\\n'];
fprintf(fid,'}\n');

% Write first row: column headers
if not(isempty(opt.cols))
  if not(isempty(opt.rows))
    fprintf(fid, '&');
  end
  for q = 1:C
    fprintf(fid, [' ' opt.cols{q} ' ']);
    if q<C
      fprintf(fid, '&');
    end
  end
  fprintf(fid, '\\\\\n');
end

% Write data + row headers
for q = 1:R
  if not(isempty(opt.rows))
    fprintf(fid, [' ' opt.rows{q} ' & ']);
  end
  fprintf(fid, fmt, data(q,:));
end

fprintf(fid,'\\end{tabular}');
fclose(fid);
