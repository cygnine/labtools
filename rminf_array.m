function[M] = rminf_array(M)
% rminf_array -- Row-wise removes non-finite entries from an array
%
% M = rminf_array(M)
%
%     This function searches the first column of M for any non-finite entries.
%     When found, it removes those rows and returns the array.

M(not(isfinite(M(:,1))),:) = [];
