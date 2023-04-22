close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
  d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
%   d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
% d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
for folder_idx=7:no_dir
   disp(nameFolds(folder_idx)); 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
 
   close all;
   I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%  I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%  I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
   I_F_cpy=I_F;
   [BW_mask_F,mask_F]=(face_detect_Harris_specs( I_F,nameFolds,folder_idx ));
  
   I_F=mat2gray(I_F);
   face_img=(I_F).*double(BW_mask_F);
end
