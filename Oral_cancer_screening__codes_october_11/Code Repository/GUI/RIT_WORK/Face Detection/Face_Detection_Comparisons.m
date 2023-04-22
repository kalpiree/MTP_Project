%% Main Code for Face Detection
close all
% clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
% d = dir('E:\ThermalDatabase\Normal'); % Reading Dir of the Specified Folder
d = dir('E:\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
% d = dir('E:\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
% Result_ratio_Malig=[];
for folder_idx=1:79
 
%        I_F=xlsread(['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     I_F=xlsread(['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     min_NM(folder_idx)=min(I_F(:));
     max_NM(folder_idx)=max(I_F(:));

%      I_F=xlsread(['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
       Ground_direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
       load(Ground_direc);
       direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
       load(direc);
       figure();
%        subplot(2,2,1);
        figure, 
        imshow(I_F,[]);title(nameFolds{folder_idx});
       hold on;
       rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
     'EdgeColor','g', 'LineWidth', 3);
       rectangle('Position', [ rt_boundary_col,upper_boundary_row,abs(lt_boundary_col-rt_boundary_col) , abs(lower_boundary_row-upper_boundary_row)],...
     'EdgeColor','b', 'LineWidth', 3);
       hold off;
       title('Proposed');
       
       direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
       load(direc);
%        subplot(2,2,2);
       figure, 
       imshow(I_F,[]);
       hold on;
       rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
     'EdgeColor','g', 'LineWidth', 3);
       rectangle('Position', [ rt_boundary_col,upper_boundary_row,abs(lt_boundary_col-rt_boundary_col) , abs(lower_boundary_row-upper_boundary_row)],...
     'EdgeColor','r', 'LineWidth', 3);
       hold off;
       title('PR');
       
       direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
       load(direc);
%        subplot(2,2,3);
       figure,
imshow(I_F,[]);
       hold on;
       rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
     'EdgeColor','g', 'LineWidth', 3);
       rectangle('Position', [ rt_boundary_col,upper_boundary_row,abs(lt_boundary_col-rt_boundary_col) , abs(lower_boundary_row-upper_boundary_row)],...
     'EdgeColor','y', 'LineWidth', 3);
       hold off;
       title('ACCEE');
       
       direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
       load(direc);
%        subplot(2,2,4);
       figure, 
        imshow(I_F,[]);
       hold on;
       rectangle('Position', [ ground_right_col,ground_top_row,abs(ground_left_col-ground_right_col) , abs(ground_bottom_row-ground_top_row)],...
     'EdgeColor','g', 'LineWidth', 3);
       rectangle('Position', [ rt_boundary_col,upper_boundary_row,abs(lt_boundary_col-rt_boundary_col) , abs(lower_boundary_row-upper_boundary_row)],...
     'EdgeColor','m', 'LineWidth', 3);
       hold off;
       title('Viola');
       
     close all;
end