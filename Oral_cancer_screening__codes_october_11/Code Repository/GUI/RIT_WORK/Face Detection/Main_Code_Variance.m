%% Main Code for Face Detection
dbstop if error
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%  d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
%  d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
for folder_idx=66:no_dir
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
 
   close all;
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%  I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
 I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%  I_F=double(imread('0001.jpg'));     
   [BW_mask_F,mask_F]=(face_detect( I_F,nameFolds,folder_idx ));
   I_F=mat2gray(I_F);
   face_img=(I_F).*double(BW_mask_F);
%  face_img=imfill(face_img,'holes');
%% Eye Detection

[ modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
%% Mouth Detection
 [ req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose] = mouth_detection_var( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row);
%% Nose Detection=
[r_lt,c_lt,r_rt,c_rt]=nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt);

%% Mouth Row
distance_1_2=col_lt_eye-col_rt_eye;
distance_1_3=r_rt-row_rt_eye;

distance_3_5_eqn1=0.83763*distance_1_2+4.9135;
distance_3_5_eqn2=0.86625*distance_1_3+2.3029;

row_3_5_eqn1=distance_3_5_eqn1+r_rt;
row_3_5_eqn2=distance_3_5_eqn2+r_rt;

lower_lip_row=ceil((row_3_5_eqn1+row_3_5_eqn2)/2);

Mouth_Region_Image=face_img(req_row:lower_lip_row,req_col_mouth_rt:req_col_mouth_lt);

figure();
imshow(Mouth_Region_Image,[]);

Mouth_Region_Image = adapthisteq(Mouth_Region_Image);

figure();
imshow(Mouth_Region_Image,[]);
var_mouth=[];
for mouth_row_index=1:size(Mouth_Region_Image,1)
    var_mouth(mouth_row_index)=var(Mouth_Region_Image(mouth_row_index,:));
end

close all;
rev_var_mouth=var_mouth(length(var_mouth):-1:1);
choice=1;
mouth_index=1;
figure();
stem(rev_var_mouth);

% while(choice==1)
%     if(rev_var_mouth(mouth_index)-rev_var_mouth(mouth_index+1)>0)
%         mouth_index=mouth_index+1;
%     else 
%         mouth_row_index_req=mouth_index;
%         choice=0;
%     end
% end
while(rev_var_mouth(mouth_index)<rev_var_mouth(mouth_index+1))
    mouth_index=mouth_index+1;
end
while(choice==1)
    if(rev_var_mouth(mouth_index)-rev_var_mouth(mouth_index+1)>0)
        mouth_index=mouth_index+1;
    else
        if(rev_var_mouth(mouth_index+1)>rev_var_mouth(mouth_index) && rev_var_mouth(mouth_index+2) > rev_var_mouth(mouth_index))
            choice=0;
            mouth_row_index_req=mouth_index;
            break;
        else
            mouth_index=mouth_index+1;
        end
    end 
end
 mouth_row_index_req=length(var_mouth)-mouth_row_index_req;
 mouth_row_index_req= mouth_row_index_req+req_row;
 figure();

 imshow(face_img); hold on;
 plot(req_col_mouth_rt,mouth_row_index_req,'g*');
 
 plot(req_col_mouth_lt,mouth_row_index_req,'g*');
    

%% Display Section
 close all;
[r,c]=find(face_img);
rmax=max(r);
figure;
imshow(face_img);title(nameFolds{folder_idx});
hold on;
plot(col_rt_eye,row_rt_eye,'c*');
plot(col_lt_eye,row_lt_eye,'c*');
% Plotting the bounding box around the eye
rectangle('Position', [ col_rt_eye-70,row_rt_eye-20, 70, 40],...
  'EdgeColor','r', 'LineWidth', 3);
rectangle('Position', [ col_lt_eye,row_lt_eye-20, 70, 40],... 
  'EdgeColor','r', 'LineWidth', 3);
row_mean_eye=row_lt_eye;
plot_variable=[req_row:rmax];
% plot(req_col_mouth_lt,plot_variable,'c*');
% plot(req_col_mouth_rt,plot_variable,'c*');
plot(c_rt,r_rt,'b*');
plot(c_lt,r_lt,'b*');
plot(req_col_mouth_rt,mouth_row_index_req,'g*');
plot(req_col_mouth_lt,mouth_row_index_req,'g*');
op_img1=nameFolds(folder_idx);

fullFileName = fullfile('C:\Users\chaithan\Desktop\NonMalignant1', op_img1);
fullFileName=cell2mat(fullFileName);
saveas(gcf,fullFileName,'png')
% 
% Hull_X(1)=req_col_mouth_rt; Hull_Y(1)=mouth_row_index_req;
% Hull_X(2)=req_col_mouth_lt; Hull_Y(2)=mouth_row_index_req;
% Hull_X(3)=c_rt(1);Hull_Y(3)=r_rt;
% Hull_X(4)=c_lt(1);Hull_Y(4)=r_lt;
% 
% figure();
% imshow(face_img);hold on;
% k = convhull(Hull_X,Hull_Y);
% plot(Hull_X(k),Hull_Y(k),'r-')
% 
% New_face=face_img;
% 
% for move=min(Hull_Y)+1:max(Hull_Y)-1
%     find_index=find(move==Hull_Y);
%     index1=Hul                                                           l_X(find_index(1));
%     index2=Hull_X(find_index(2));
%     New_face(move, min(index1,index2):max(index1,index2))=0;
% end
%                                                                                           
% hold on;plot(col_right_nose,row_right_nose,'r*');
% plot(col_left_nose,row_left_nose,'r*');
%% Hull Mask
mid_mouth=ceil((req_col_mouth_rt+req_col_mouth_lt)/2);
[img_size_X,img_size_Y]=size(face_img);
face_keypt_X=[c_rt(1);c_lt(1);req_col_mouth_lt;req_col_mouth_rt;mid_mouth];
face_keypt_Y=[r_rt;r_lt;mouth_row_index_req;mouth_row_index_req;lower_lip_row];
k = convhull(face_keypt_X,face_keypt_Y);
BW = poly2mask(face_keypt_X(k),face_keypt_Y(k),img_size_X,img_size_Y);
face_portion_masked = bwconvhull(BW);
face_portion_masked=~face_portion_masked;
face_portion_masked=double(face_portion_masked);
face_region = face_img.*face_portion_masked;
figure;imshow(face_region);
hold on;
plot(face_keypt_X(k),face_keypt_Y(k),'r-',face_keypt_X,face_keypt_Y,'b*');title('Convhull of poly2mask')

%% Lower Eye POint Detection
Eye_dist=col_lt_eye-col_rt_eye;
Lower_right_eye=0.9291*Eye_dist+6.114+row_rt_eye;
Lower_left_eye=0.1189*Eye_dist+2.678+row_lt_eye;
Lower_eye_row=ceil((Lower_right_eye+Lower_left_eye)/2);
plot_temp=[1:640];
plot(plot_temp,Lower_eye_row,'c*');
% Mid Identification
[row,column]=find(face_img>0);
cmax=max(column);
cmin=min(column);

% c1mid...c4mid is for finding middle of the face taking avg of lt and rt
% bondary of detected face, lt and rt canthus of eye, lt and rt detected
% nose tip, lt and rt lip corner. The final avg variable is cmid
c1mid=ceil((cmax+cmin)/2);
c2mid=ceil((col_lt_eye+col_rt_eye)/2);
c3mid=ceil((c_rt(1)+c_lt(1))/2);
c4mid=ceil((req_col_mouth_lt+req_col_mouth_rt)/2);
cmid=ceil((c1mid+c2mid+c3mid+c4mid)/4);

Left_Img=zeros(img_size_X,img_size_Y);
Right_Img=zeros(img_size_X,img_size_Y);
Left_Img(Lower_eye_row:end,cmid:cmax)=face_region(Lower_eye_row:end,cmid:cmax);
Right_Img(Lower_eye_row:end,cmin:cmid)=face_region(Lower_eye_row:end,cmin:cmid);

%% Saving ROI
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');

%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
figure();
imshow(Right_Img);title('Right ROI');
figure();
imshow(Left_Img);title('Left ROI');
end  