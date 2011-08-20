function[cops] = init__()
% init__ -- Initialization file for labtools.cops package
%  "Complex OPerationS"
%
% [nodes] = init__()

module_list = {'moebius'};
%cops = recurse_files(pwd, module_list);

cops.module_list = module_list;
cops.recurse_files = true;
cops.addpaths = {};
