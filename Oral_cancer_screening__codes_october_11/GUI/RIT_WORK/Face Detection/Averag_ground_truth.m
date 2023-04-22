
%% Main Code for Face Detection
close all
clear all
clc
%% Normal
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
counter=1;
for folder_idx=1:63
    Save_Direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];    
    load(Save_Direc);
    width_ground(counter)=(ground_left_col-ground_right_col);
    height_ground(counter)=(ground_bottom_row-ground_top_row);
    counter=counter+1;
end

%% Malignant

d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:81
    Save_Direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
    load(Save_Direc);
    width_ground(counter)=(ground_left_col-ground_right_col);
    height_ground(counter)=(ground_bottom_row-ground_top_row);
    counter=counter+1;
end




%% NonMalignant
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:59
    Save_Direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
    load(Save_Direc);
    width_ground(counter)=(ground_left_col-ground_right_col);
    height_ground(counter)=(ground_bottom_row-ground_top_row);
    counter=counter+1;
end