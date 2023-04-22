close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%  d = dir('D:\Work\ThermalOOC_Manashi\Normal'); % Reading Dir of the Specified Folder
%  d = dir('D:\Work\ThermalOOC_Manashi\Malignant'); % Reading Dir of the Specified Folder
 d = dir('D:\Work\ThermalOOC_Manashi\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir,

%      I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);

%  I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
   I_F=xlsread(['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
 
%     [I_new,mask_F] = face_detect_PR_original( I_F,nameFolds,folder_idx );
[I_new,mask_F] = face_detect_PR_original( I_F,nameFolds,folder_idx )
end