%%
clear;
clc;
close all;

%% Load the contents of the folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal\');
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%% Face Extraction
for folder_idx=12:no_dir
disp(nameFolds(folder_idx)); 
%close all;
    % Frontal Face
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
    int_F=(255/(max(max(I_F))-min(min(I_F))))*[I_F-min(min(I_F))]; % Map the temperature variations bet 0 and 255
    int_F=int_F/255; % Normalizing bet 0 and 1
%     figure();
%     imshow(int_F);title('Original Image');
    level = graythresh(int_F); % fINDING THE GLOBAL THRESHOLD USING OTSU METHOD
    BW = im2bw(int_F,level); 
    mask_F=int_F.*double(BW); % Extracting the face
    figure();
    imshow(mask_F);title('Mask');
%% 
     temp1=1:640;
      for k=1:480
          Ph_y(k)=sum(int_F(k,:));
      end
     Fx_y=gradient(Ph_y);
     a1y=max(Fx_y);
     c1y=find(Fx_y==a1y);
     hold on;
     plot(temp1,c1y,'c*');
     modified_mask_F=mask_F((1:320),:);
     figure();
     imshow(modified_mask_F); title('Modified Mask');
     
     %%
     mask_F_canny=edge(modified_mask_F,'Canny');
%      figure();
%      imshow(mask_F_canny); title('Using Canny');
end