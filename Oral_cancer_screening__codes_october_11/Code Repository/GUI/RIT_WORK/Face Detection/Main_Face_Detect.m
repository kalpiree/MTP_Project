%% Main Code for Face Detection
close all
clear all
%clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
% d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
    %close all;
     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%       I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     Mode='F';
%      I_F=adapthisteq(mat2gray(I_F));
%    [BW_mask_F,mask_F,r_min1]=(face_detect_try( I_F , Mode ));
    [BW_mask_F,mask_F]=(face_detect( I_F ));
  
    % close all;
    figure();
    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))));
    face_img=I_F.*double(BW_mask_F);
    face_img_n=I_F_n.*double(BW_mask_F);
    imshow(face_img_n);title(nameFolds(folder_idx));

end