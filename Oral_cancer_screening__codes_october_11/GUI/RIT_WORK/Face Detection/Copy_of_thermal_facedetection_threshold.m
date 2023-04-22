%%
%clear;
clc;
%close all;

%%
figure();
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal\');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
for folder_idx=2:no_dir
disp(nameFolds(folder_idx)); 
%close all;
    % Frontal Face
    I_F_1=imread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_IR_FT.jpg']);
    imshow(I_F_1(:,:,1));
    I_F_g=double(I_F_1(:,:,1));
    th_F=200;
    mask_F_1=I_F_g.*double(I_F_g>=th_F);
    %face_F=I_F.*mask_F;
    figure();
    imshow(mask_F_1/255);
    % Right Profile
    I_R=imread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_IR_RT.jpg']);
    % Right Profile
    I_L=imread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_IR_LT.jpg']);


end