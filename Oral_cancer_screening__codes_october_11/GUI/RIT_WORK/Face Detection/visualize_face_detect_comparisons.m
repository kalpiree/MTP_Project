%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
 %d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
      close all;
%      I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      [BW_mask_F,mask_F,result_Normal_PR(folder_idx),c1_PR,c2_PR,face_detect_min_r_PR,face_detect_max_r_PR]=(face_detect_PR_visualize( I_F,nameFolds,folder_idx  ));
      [BW_mask_F,mask_F,result_Normal(folder_idx),c1,c2,face_detect_min_r,face_detect_max_r]=(face_detect_visualize( I_F,nameFolds,folder_idx  ));
 %    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
      direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
%     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
     
     load(direc); 
          
     figure();
     imshow(I_F,[]);
     hold on;
     rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
   'EdgeColor','r', 'LineWidth', 3);
     rectangle('Position', [ c1(1),face_detect_min_r,abs(c2(1)-c1(1)) , abs(face_detect_max_r-face_detect_min_r)],...
   'EdgeColor','b', 'LineWidth', 3);
     rectangle('Position', [ c1_PR(1),face_detect_min_r_PR,abs(c2_PR(1)-c1_PR(1)) , abs(face_detect_max_r_PR-face_detect_min_r_PR)],...
   'EdgeColor','y', 'LineWidth', 3);
end   
