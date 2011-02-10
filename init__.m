function[labtools] = init__()
% init__ -- Initialization file for labtools package
%
% [nodes] = init__()

module_list = {'linalg', 'specfun', 'rootfind', 'pgf', 'sampling', ...
               'minimization', 'cops'};

pwd_addpath('classes');

labtools = recurse_files(pwd, module_list);

%labtools.linalg = matlab_import('linalg');
%labtools.specfun = matlab_import('specfun');
%labtools.rootfind = matlab_import('rootfind');
%labtools.pgf = matlab_import('pgf');
%labtools.sampling = matlab_import('sampling');
%labtools.minimization = matlab_import('minimization');
%labtools.cops = matlab_import('cops');
