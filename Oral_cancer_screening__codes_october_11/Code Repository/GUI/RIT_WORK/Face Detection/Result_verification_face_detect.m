%% Main Code for Face Detection
close all
%clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=66:no_dir
     close all;
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      [BW_mask_F,mask_F,result_NonMalig_PR(folder_idx)]=(face_detect( I_F,nameFolds,folder_idx  ));
      result_NonMalig_PR=abs(result_NonMalig_PR);
     %      I_F=mat2gray(I_F);
%      face_img=(I_F).*double(BW_mask_F);
%      face_img=imfill(face_img,'holes');
     
     
end   
