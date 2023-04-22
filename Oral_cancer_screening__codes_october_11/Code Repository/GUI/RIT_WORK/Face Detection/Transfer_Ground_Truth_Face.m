%% Main Code for Face Detection
dbstop if error
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%  d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
%   d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
 d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%% 
for folder_idx=1:no_dir

%     Dest_Direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\Jpeg\'];
%     Dest_Direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\'];
    Dest_Direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\'];

%   direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
%   direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];    
direc
Dest_Direc
copyfile(direc,Dest_Direc);
end