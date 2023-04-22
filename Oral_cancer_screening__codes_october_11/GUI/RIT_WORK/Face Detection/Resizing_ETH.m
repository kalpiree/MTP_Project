close all
clear all
clc
%%
d = dir('C:\Users\chaithan\Desktop\Terravic Negative'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(:).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
sub_direc=['C:\Users\chaithan\Desktop\Terravic Negative','\',nameFolds{folder_idx}];
I_F=imread(sub_direc);
I_F=imresize(I_F,[100 100]);
dest_path=sub_direc;
imwrite(I_F,dest_path);
end

