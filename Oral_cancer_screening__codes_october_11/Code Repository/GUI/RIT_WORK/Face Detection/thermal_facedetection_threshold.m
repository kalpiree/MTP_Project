%%
clear;
clc;
close all;

%%
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal\');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
close all;
    % Frontal Face
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
    int_F=(255/(max(max(I_F))-min(min(I_F))))*[I_F-min(min(I_F))];
    int_F=int_F/255;
    level = graythresh(int_F);
    BW = im2bw(int_F,level); 
    mask_F=int_F.*double(BW);
    figure();
    imshow(mask_F);
    % Right Profile
    I_R=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_rt.csv']);
    int_R=(255/(max(max(I_R))-min(min(I_R))))*[I_R-min(min(I_R))];
    int_R=int_R/255;
    level = graythresh(int_R);
    BW = im2bw(int_R,level); 
    mask_R=int_R.*double(BW);
    figure();
    imshow(mask_R);
    % Left Profile
    I_L=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_lt.csv']);
    int_L=(255/(max(max(I_L))-min(min(I_L))))*[I_L-min(min(I_L))];
    int_L=int_L/255;
    level = graythresh(int_L);
    BW = im2bw(int_L,level); 
    mask_L=int_L.*double(BW);
    figure();
    imshow(mask_L);
    

end