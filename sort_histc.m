function[x, bin_id, bin_count, bin_matrix, sort_order] = sort_histc(x, edges)
% sort_histc -- Performs a histogram count with sorting
%
% [x, bin_id, bin_count, bin_matrix, sort_order] = sort_histc(x, edges)
%
%     Performs a histogram count as Matlab's built-in HISTC does. However, this
%     function sorts the inputs x by increasing bins (not by value inside bins).
%     Then it returns the sorted vector x, the corresponding bin_id (a
%     non-decreasing vector), the bin_count, a slicing matrix, and a sorting
%     order.
%
%     To re-order the vector x, do
%       x(sort_order) = x;
%
%     The length(edges) x 2 matrix bin_matrix is a slicing matrix. I.e.
%     x(bin_matrix(N,1):bin_matrix(N,2)) are the elements of x that lie in bin
%     N.
%
%     TODO: support matrix input x, plus histogramming across dimensions other
%     than 1.

x = x(:);

% first do histogram counting:
[bin_count, bin_id] = histc(x, edges);

[temp, sort_order] = sortrows([x, bin_id], 2);

x = temp(:,1); bin_id = temp(:,2);

csum = cumsum(bin_count(:));
bin_matrix = [1 + [0; csum(1:end-1)], csum];
