%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
% d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
%   d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=31:-1:1
      close all;
      
%% Image to Plot
     
   I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%      I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     figure();
     imshow(I_F,[]);
     hold on;
%% Ground Truth

   direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
%     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
%     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];

     load(direc); 
    
      rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
   'EdgeColor','g', 'LineWidth', 12); 
     
%      
         %% PR Paper Otsu
    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];

     load(direc); 

     lower_boundary_row_pr_mod=lower_boundary_row;
     upper_boundary_row_pr_mod=upper_boundary_row;
     lt_boundary_col_pr_mod=lt_boundary_col; 
     rt_boundary_col_pr_mod=rt_boundary_col;
     
     width_pr_mod=lt_boundary_col_pr_mod-rt_boundary_col_pr_mod;
     height_pr_mod=lower_boundary_row_pr_mod-upper_boundary_row_pr_mod;
     
     if(height_pr_mod>0 && width_pr_mod>0)
     rectangle('Position', [ rt_boundary_col_pr_mod,upper_boundary_row_pr_mod,width_pr_mod , height_pr_mod],...
   'EdgeColor',[1 .5 0], 'LineWidth', 12);
     end
%% Our proposed method

%    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
% %    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
%   
%      load(direc); 
%     
%      lower_boundary_row_proposed=lower_boundary_row;
%      upper_boundary_row_proposed=upper_boundary_row;
%      lt_boundary_col_proposed=lt_boundary_col;
%      rt_boundary_col_proposed=rt_boundary_col;
%      
%      width_proposed=lt_boundary_col_proposed-rt_boundary_col_proposed;
%      height_proposed=lower_boundary_row_proposed-upper_boundary_row_proposed;
%      
% %      rectangle('Position', [ rt_boundary_col_proposed,upper_boundary_row_proposed,width_proposed , height_proposed],...
% %    'EdgeColor','b', 'LineWidth', 12);
%      
% 
%      %% ACEEE Paper Method
% 
%    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
% % 
%      load(direc); 
%      lower_boundary_row_spie=lower_boundary_row;
%      upper_boundary_row_spie=upper_boundary_row;
%      lt_boundary_col_spie=lt_boundary_col;
%      rt_boundary_col_spie=rt_boundary_col;
%      
%      width_spie=lt_boundary_col_spie-rt_boundary_col_spie;
%      height_spie=lower_boundary_row_spie-upper_boundary_row_spie;
%      
%      if(width_spie>0 && height_spie>0)
% %      rectangle('Position', [ rt_boundary_col_spie,upper_boundary_row_spie,width_spie , height_spie],...
% %    'EdgeColor','y', 'LineWidth', 12);
%      end
% 
%  %% Viola Jones PreTrained
% % 
% % 
%    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
% 
%      load(direc); 
%      lower_boundary_row_spie=lower_boundary_row;
%      upper_boundary_row_spie=upper_boundary_row;
%      lt_boundary_col_spie=lt_boundary_col;
%      rt_boundary_col_spie=rt_boundary_col;
%      
%      width_spie=lt_boundary_col_spie-rt_boundary_col_spie;
%      height_spie=lower_boundary_row_spie-upper_boundary_row_spie;
% %      
% %      rectangle('Position', [ rt_boundary_col_spie,upper_boundary_row_spie,width_spie , height_spie],...
% %    'EdgeColor','m', 'LineWidth', 12);
% 
%  %%  % PR Paper Kitler
% 
%  direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_PR_Kitler',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Kitler',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Kitler',nameFolds{folder_idx},'.mat'];
% 
% %      load(direc); 
% % 
% %      lower_boundary_row_pr_mod=lower_boundary_row;
% %      upper_boundary_row_pr_mod=upper_boundary_row;
% %      lt_boundary_col_pr_mod=lt_boundary_col;
% %      rt_boundary_col_pr_mod=rt_boundary_col;
% %      
% %      width_pr_mod=lt_boundary_col_pr_mod-rt_boundary_col_pr_mod;
% %      height_pr_mod=lower_boundary_row_pr_mod-upper_boundary_row_pr_mod;
% %      if(height_pr_mod>0 && width_pr_mod >0)
% %      rectangle('Position', [ rt_boundary_col_pr_mod,upper_boundary_row_pr_mod,width_pr_mod , height_pr_mod],...
% %    'EdgeColor','r', 'LineWidth', 8);
% %      end
% %% 
% %   direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
% % %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
% % %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
% % hold off;
% %      load(direc); 
% %      direc_img=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.jpg'];
% % %     direc_img=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.jpg'];
% % %     direc_img=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.jpg'];
% %     figure();I_F_optical=imread(direc_img);I_F_optical=imresize(I_F_optical,[480 640]);
% %     imshow(I_F_optical,[]);hold on;
% %      lower_boundary_row_pr_mod=lower_boundary_row;
% %      upper_boundary_row_pr_mod=upper_boundary_row;
% %      lt_boundary_col_pr_mod=lt_boundary_col;
% %      rt_boundary_col_pr_mod=rt_boundary_col;
% %      
% %      width_pr_mod=lt_boundary_col_pr_mod-rt_boundary_col_pr_mod;
% %      height_pr_mod=lower_boundary_row_pr_mod-upper_boundary_row_pr_mod;
% %      if(height_pr_mod>0 && width_pr_mod >0)
% %      rectangle('Position', [ rt_boundary_col_pr_mod,upper_boundary_row_pr_mod,width_pr_mod , height_pr_mod],...
% %    'EdgeColor','r', 'LineWidth', 8);
% %      end
% %        rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
% %    'EdgeColor','g', 'LineWidth', 12); 
% %      
%       %% PR Paper Otsu
%     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
% 
%      load(direc); 
% 
%      lower_boundary_row_pr_mod=lower_boundary_row;
%      upper_boundary_row_pr_mod=upper_boundary_row;
%      lt_boundary_col_pr_mod=lt_boundary_col; 
%      rt_boundary_col_pr_mod=rt_boundary_col;
%      
%      width_pr_mod=lt_boundary_col_pr_mod-rt_boundary_col_pr_mod;
%      height_pr_mod=lower_boundary_row_pr_mod-upper_boundary_row_pr_mod;
%      
%      if(height_pr_mod>0 && width_pr_mod>0)
%      rectangle('Position', [ rt_boundary_col_pr_mod,upper_boundary_row_pr_mod,width_pr_mod , height_pr_mod],...
%    'EdgeColor','c', 'LineWidth', 8);
%      end
  end   