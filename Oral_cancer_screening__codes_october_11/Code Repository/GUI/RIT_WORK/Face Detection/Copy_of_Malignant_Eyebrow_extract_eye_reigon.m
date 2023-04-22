%% Main Code for Face Detection
% close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
%d = dir('F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
     close all;
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     [BW_mask_F,mask_F]=(face_detect( I_F ));
     I_F=mat2gray(I_F);
     face_img=(I_F).*double(BW_mask_F);
%    face_img=adapthisteq(face_img);

%% Eye Detection
      [ row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
      figure();
      imshow(face_img);
      hold on;
      plot(col_rt_eye,row_rt_eye,'c*');
      plot(col_lt_eye,row_lt_eye,'c*');
      % Plotting the bounding box around the eye
      rectangle('Position', [ col_rt_eye-70,row_rt_eye-20, 70, 40],...
        'EdgeColor','r', 'LineWidth', 3)
      rectangle('Position', [ col_lt_eye,row_lt_eye-20, 70, 40],...
        'EdgeColor','r', 'LineWidth', 3)

  %%  Lip Detection
      [row_lip,col_lip] = lip_detection_thermal(face_img,col_rt_eye,col_lt_eye,row_rt_eye);
      plot(col_lip,row_lip,'c*');
      rectangle('Position', [ col_lip-50,row_lip-25, 100, 50],...
        'EdgeColor','y', 'LineWidth', 3)
  %% Ending
      folder_idx
      nameFolds{folder_idx}
end