function[labtools] = init__()
% init__ -- Initialization file for labtools package
%
% [nodes] = init__()

pwd_addpath('classes');

labtools = recurse_files;

labtools.linalg = matlab_import('linalg');
labtools.rootfind = matlab_import('rootfind');
