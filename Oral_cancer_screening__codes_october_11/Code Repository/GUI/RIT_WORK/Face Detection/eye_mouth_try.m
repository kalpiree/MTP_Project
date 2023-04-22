%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=4:no_dir
    close all;
     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     Mode='F';
%    [BW_mask_F,mask_F,r_min1]=(face_detect_try( I_F , Mode ));
    [BW_mask_F,mask_F]=(face_detect( I_F ));
    close all;
    figure();
    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))));
    face_img=I_F.*double(BW_mask_F);
    face_img_n=I_F_n.*double(BW_mask_F);
    imshow(face_img_n);title(nameFolds(folder_idx));
    [row,col]=find(face_img_n>0);
    min_row=min(row);
    min_col=min(col);
    max_row=max(row);
    max_col=max(col);
    mid_col=floor(((max_col-min_col)/2)+min_col);
%     r_max=(max_row-min_row)*(0.5)+min_row;
%     j=0;
%     for i=min_col:mid_col
%         F=face_img_n(min_row:r_max,i);
%         Fx=gradient(F);
%         Fx1=Fx(2:end);
%         j=j+1;
%         max_F_row(j)=find(Fx1==max(Fx1),1)+1;
%         max_F_col(j)=i;
% %         j=j+1;
%     end
% figure();
% imshow(face_img_n);
% hold on;
% max_F_row=max_F_row+min_row;
% plot(max_F_col,max_F_row,'c*');
    %max_F_row=max_F_row+min_row;
    min_eye_row=floor((max_row-min_row)*(0.4)+min_row);
    max_eye_row=floor((max_row-min_row)*(2/3)+min_row);
%     min_eye_row=min_row;
%     max_eye_row=floor((max_row-min_row)*(2/3)+min_row);
    
face_img_req1=face_img_n(min_eye_row:max_eye_row,min_col:mid_col);
    face_img_req2=face_img_n(min_eye_row:max_eye_row,mid_col:max_col);
    max_1=max(face_img_req1(:));
    [max1_row,max1_col]=find(face_img_req1 == max_1);
    max_2=max(face_img_req2(:));
    [max2_row,max2_col]=find(face_img_req2 == max_2);
%     
%     max_2=0;
%     for idx=1:size(face_img_req,1)
%         for j=1:size(face_img_req,2)
%             if(face_img_req(idx,j) > max_2 && face_img_req(idx,j) ~=max_1)
%                 max_2=face_img_req(idx,j);
%                 max2_row=idx;
%                 max2_col=j;
%             end
%         end
%     end
           
    hold on;
    eye1_col=max(max1_col+min_col-1);
    eye1_row=max(max1_row+min_eye_row-1);
    eye2_col=max(max2_col+mid_col-1);
    eye2_row=max(max2_row+min_eye_row-1);
    plot(eye1_col,eye1_row,'*');
    plot(eye2_col,eye2_row,'*');
    figure();
    subplot(1,2,1);imshow(face_img_req1);
    subplot(1,2,2);imshow(face_img_req2);
    
 
end
