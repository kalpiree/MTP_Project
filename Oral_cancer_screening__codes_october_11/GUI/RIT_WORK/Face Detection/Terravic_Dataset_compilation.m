close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('C:\Users\chaithan\Desktop\Terravic Frontal'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

%%
for folder_idx=1:no_dir
sub_direc=['C:\Users\chaithan\Desktop\Terravic Frontal','\',nameFolds{folder_idx}];
sub_d = dir(sub_direc); % Reading Dir of the Specified Folder
sub_isub = [sub_d(:).isdir]; %# returns logical vector
sub_nameFolds = {sub_d(sub_isub).name}';
for sub_index=3:13
filename = sub_d(sub_index).name;
file_path=[sub_direc,'\',filename];
dest_path=['C:\Users\chaithan\Desktop\Terravic Dataset\',nameFolds{folder_idx},'_',filename,'.jpg'];
copyfile (file_path,dest_path);
end
end