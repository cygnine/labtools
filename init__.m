function[labtools] = init__()
% init__ -- Initialization file for labtools package
%
% [nodes] = init__()

% labtools is special: if classes aren't added first, FunctionNode isn't defined
pwd_addpath('classes', 'global');

labtools = recurse_files;

labtools.linalg = matlab_import('linalg');
labtools.rootfind = matlab_import('rootfind');
