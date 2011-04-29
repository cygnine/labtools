function[] = pgfplots_table_vnames(fname, data, vname)
% pgfplots_table_vnames -- Saves ASCII data in pgfplots-friendly format
%
% pgfplots_table_vnames(fname, datacell, vnamecell)
%
%     Saves the variables with (string) names vnamecell{1}, vnamecell{2}, etc. to the file named
%     (string) fname in ASCII format. The format is as follows:
%
%         var1               var2             var3            ... 
%         value1             value2           value3          ... 
%         value1             value2           value3          ... 
%         value1             value2           value3          ... 
%           .                  .                .             ... 
%           .                  .                .             ... 
%           .                  .                .             ... 
%
%     The variable data is taken from the cell array datacell. This essentially
%     does the same thing as pgfplots_table_output.

%persistent input_schema
%if isempty(input_schema)
  %from labtools import input_schema
%end

Nvars = length(data);

if Nvars<1
  fprintf('No data given...returning\n.');
  return
end

data_print_length = 17;

fid = fopen(fname, 'w');
%data = {};
lengths = [];
varname_length = 0;
for q = 1:Nvars
  %data{q} = evalin('base', varargin{q});
  lengths(q) = length(data{q});
  varname_length = max(varname_length, length(vname{q}));
end
varname_length = max(data_print_length, varname_length);
varname_length = num2str(varname_length);

column_sep = '4';

if not(all(diff(lengths)==0))
  error('All input variables must be vectors of the same length');
else
  N = lengths(1);
end

for q = 0:N;
  if q==0 % Print the row of names
    for var = 1:Nvars
      fprintf(fid, '%6s', '');
      fprintf(fid, strcat('%', varname_length, 's'), vname{var});
      if var<Nvars
        fprintf(fid, strcat('%', column_sep, 's'), '');
      end
    end
  else % Print actual data
    for var = 1:Nvars
      fprintf(fid, strcat('%1.', varname_length, 'e'), data{var}(q));
      if var<Nvars
        fprintf(fid, strcat('%', column_sep, 's'), '');
      end
    end
  end
  fprintf(fid, '\n');
end

fclose(fid);
