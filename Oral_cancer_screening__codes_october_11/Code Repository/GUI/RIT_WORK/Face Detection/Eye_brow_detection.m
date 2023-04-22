%%
%Eye_brow_detection:
%Called by:
%i/p parameters to the fn:

%var names
%% Main Code for Face Detection
% close all
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
for folder_idx=7:no_dir
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
    r_max=(max_row-(min_row))*(1/2.5)+min_row;
    j=0;
    %for i=min_col:mid_col
        figure();
imshow(face_img_n);

% for i=min_col+40:mid_col
%         F=face_img_n(min_row+80:r_max,i);
%         Fx=gradient(F);
%         temp=[min_row+80:r_max];
%         Fxl=imboxfilt(Fx,21);
%         row_eb=find(Fxl==min(Fxl))+min_row+80;
%         plot(i,row_eb,'c*');
% end
% 
% for i=min_row+80:r_max
%         F=face_img_n(i,(mid_col:-1:min_col+40));
%         Fx=gradient(F);
%         temp=[mid_col:-1:min_col+40];
%         Fxl=imboxfilt(Fx,21);
%         row_eb=mid_col-find(Fxl==max(Fxl));
%         plot(row_eb,i,'r*');
% end
face_img_req1=face_img_n((min_row:r_max),(min_col:mid_col));
figure();
detected_horizontal_face_img_req1=[];
face_temp_req1=[];
subplot(1,2,1);imshow(face_img_req1);

horizontal_face_img=edge(face_img_req1,'Sobel','horizontal');
detected_horizontal_face_img=double(horizontal_face_img).*face_img_req1;
detected_horizontal_face_img_req1((min_row:floor(r_max)),(min_col:mid_col))=detected_horizontal_face_img;
figure();
imshow(detected_horizontal_face_img_req1);
figure();
mid_temp_col=floor(size(face_img_req1,2)/2);
mid_temp_row=floor(size(face_img_req1,1)/2);
mid_temp_array=face_img_req1(:,mid_temp_col);
min_row_new=0;
% face_temp_req1((min_row+80:floor(r_max)),(min_col:mid_col))=face_img_req1
% imshow(face_temp_req1);
vertical_face_img=edge(face_img_req1,'Sobel','vertical');
detected_vertical_face_img=double(vertical_face_img).*face_img_req1;
figure();
imshow(detected_vertical_face_img);
% for i=mid_temp_row:-1:min_row
%     if detected_vertical_face_img(i,min_col:mid_temp_col)>0
%         min_row_new=i+min_row+80;
%     else
%         continue
%     end
% end


%%%%%%
% for i=1:size(detected_vertical_face_img,1)
for i=1:floor(size(detected_vertical_face_img,2)/2)
    if detected_vertical_face_img(i,size(detected_vertical_face_img,2))>0.4
        min_row_new=i+min_row;
    else
        continue
    end
end
%% previous
% if(min_row_new==0)
%     for i=mid_temp_col:-1:1
%         for j=1:size(detected_vertical_face_img,1)
%             if detected_vertical_face_img(j,i)>0
%                 min_row_new=j+min_row+80;
%                 break;
%             else
%                 continue;
%             end
%         end
%     end
% end


%-------------------------------------------------
%%new

if(min_row_new==0)
    for i=mid_temp_col:-1:(mid_temp_col-20)
%         for j=1:size(detected_vertical_face_img,1)
           for j=1:floor(size(detected_vertical_face_img,2)/2)
            if detected_vertical_face_img(j,i)>0.4
                min_row_new=j+min_row;
                break;
            else
                continue;
            end
        end
    end
end
if(min_row_new==0)
    for i=size(detected_vertical_face_img,2):-1:mid_temp_col
%         for j=1:size(detected_vertical_face_img,1)
          for j=1:floor(size(detected_vertical_face_img,2)/2)
            if detected_vertical_face_img(j,i)>0.4
                min_row_new=j+min_row;
                break;
            else
                continue;
            end
        end
    end
end

if(min_row_new==0)
    min_row_new=min(row);
end
r_max=(max_row-min_row_new)*(1/2.5)+min_row_new;
face_img_req_final=face_img_n((min_row_new:r_max),(min_col:mid_col));
figure();
imshow(face_img_req_final);title('FINAL');
%         Fx1=Fx(2:end);
%         j=j+1;d
%         max_F_row(j)=find(Fx1==max(Fx1),1)+1;
%         max_F_col(j)=i;
%       j=j+1;
    %end
% figure();
% imshow(face_img_n);
% hold on;
% max_F_row=max_F_row+min_row;
% plot(max_F_col,max_F_row,'c*');
%     max_F_row=max_F_row+min_row;
%     min_eye_row=floor((max_row-min_row)*(0.4)+min_row);
%     max_eye_row=floor((max_row-min_row)*(2/3)+min_row);
%     min_eye_row=min_row;
%     max_eye_row=floor((max_row-min_row)*(2/3)+min_row);
    
% face_img_req1=face_img_n(min_eye_row:max_eye_row,min_col:mid_col);
%     face_img_req2=face_img_n(min_eye_row:max_eye_row,mid_col:max_col);
%     max_1=max(face_img_req1(:));
%     [max1_row,max1_col]=find(face_img_req1 == max_1);
%     max_2=max(face_img_req2(:));
%     [max2_row,max2_col]=find(face_img_req2 == max_2);
% %     
% %     max_2=0;
% %     for idx=1:size(face_img_req,1)
% %         for j=1:size(face_img_req,2)
% %             if(face_img_req(idx,j) > max_2 && face_img_req(idx,j) ~=max_1)
% %                 max_2=face_img_req(idx,j);
% %                 max2_row=idx;
% %                 max2_col=j;
% %             end
% %         end
% %     end
%            
%     hold on;
%     eye1_col=max(max1_col+min_col-1);
%     eye1_row=max(max1_row+min_eye_row-1);
%     eye2_col=max(max2_col+mid_col-1);
%     eye2_row=max(max2_row+min_eye_row-1);
%     plot(eye1_col,eye1_row,'*');
%     plot(eye2_col,eye2_row,'*');
%     figure();
%     subplot(1,2,1);imshow(face_img_req1);
%     subplot(1,2,2);imshow(face_img_req2);
    
 
end
