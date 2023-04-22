%% Main Code for Face Detection
dbstop if error
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%  d = dir('D:\Work\ThermalOOC_Manashi\Normal'); % Reading Dir of the Specified Folder
%   d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
 d = dir('D:\Work\ThermalOOC_Manashi\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
for folder_idx=91:no_dir
%       I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);

 I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
[I_new,mask_F,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row] = face_detect_Harris_specs( I_F,nameFolds,folder_idx )
close all;

figure();
    imshow(mat2gray(I_F));title('Face Bounding Box');
    temp=[1:size(I_F,1)];
    hold on;
    plot(lt_boundary_col,temp,'c*');
    plot(rt_boundary_col,temp,'c*');
    temp=[1:size(I_F,2)];  
    plot(temp,lower_boundary_row,'c*');
    plot(temp,upper_boundary_row,'c*');
    rect = getrect
    
ground_right_col=rect(1);
ground_top_row=rect(2);
ground_left_col=ground_right_col+rect(3);
ground_bottom_row=ground_top_row+rect(4);
  direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
 %  direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
%     direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];    

    save(direc,'ground_left_col','ground_top_row','ground_bottom_row','ground_right_col');

end