%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%  d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
% d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
    disp(nameFolds(folder_idx))
    close all;
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_LT.csv']);
   I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
  
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
   I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
  

     [rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row,BW_mask_F,mask_F]=(face_detect( I_F,nameFolds,folder_idx  ));
     I_F=mat2gray(I_F);
     BW_mask_F=imfill(BW_mask_F,'holes');
     face_img=(I_F).*double(BW_mask_F);
     %face_img=imfill(face_img,'holes');
     [Gmag,Gdir] = imgradient(face_img);
     figure,imshow(face_img,[])
     figure,imshow(Gmag)
     mid_boundary_col=(rt_boundary_col+lt_boundary_col)/2;
%       for i=mid_boundary_col:lt_boundary_col
%      Pv(i)=sum(BW_mask_F(upper_boundary_row:lower_boundary_row,i));
% %         Pv(i)=sum(BW_mask_F(:,i));
% 
%     end
end   
