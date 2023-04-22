clear;
clc;
close all;

%%
figure();
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
    figure();imshow(I_F,[]);
    I_F_1=imread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_IR_FT.jpg']);
    figure();imshow(I_F_1);
    I_F_g=double(rgb2gray(I_F_1));
    th_F=34;
    mask_F=I_F_g.*double(I_F>=th_F);
    figure();imshow(mask_F/255);
     % Right Profile
    I_R=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_rt.csv']);
    % Right Profile
    I_L=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_lt.csv']);
    % Right Profile
    I_R_1=imread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_IR_RT.jpg']);
    % Right Profile
    I_L_1=imread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_IR_LT.jpg']);

    figure();imshow(I_R,[]);
    figure();imshow(I_R_1);
    I_R_g=double(rgb2gray(I_R_1));
    th_R=33;
    mask_R=I_R_g.*double(I_R>=th_R);
    figure();imshow(mask_R/255);

    figure();imshow(I_L,[]);
    figure();imshow(I_L_1);
    I_L_g=double(rgb2gray(I_L_1));
    th_L=33;
    mask_L=I_L_g.*double(I_L>=th_L);
    figure();imshow(mask_L/255);

end
   