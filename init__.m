function[labtools] = init__()
% init__ -- Initialization file for labtools package
%
% [nodes] = init__()

module_list = {'linalg', 'specfun', 'rootfind', 'pgf', 'sampling', ...
               'minimization', 'cops'};

%pwd_addpath('classes');
%labtools = recurse_files(pwd, module_list);

labtools.module_list = module_list;
labtools.recurse_files = true;
labtools.addpaths = {'classes'};
