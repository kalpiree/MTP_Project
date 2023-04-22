%% Main Code for Face Detection
dbstop if error
close all
clear all
clc

%% Fetch the Index Numbers of the Malignant Patients
disp('Which Category do you choose');
disp('Normal (N), Malignant (M), Precancerous (P)');
question='Enter your choice = ';
User_Choice=input(question,'s');
if (strcmp(User_Choice, 'N')==1)
d = dir('D:\Work\ThermalOOC_Manashi\Normal'); % Reading Dir of the Specified Folder
elseif (strcmp(User_Choice, 'M')==1)
d = dir('D:\Work\ThermalOOC_Manashi\Malignant'); % Reading Dir of the Specified Folder
elseif (strcmp(User_Choice, 'P')==1)
d = dir('D:\Work\ThermalOOC_Manashi\NonMalignant'); % Reading Dir of the Specified Folder
else
    disp('Invalid Choice');
    return
end
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
for folder_idx=1:no_dir

   fprintf('Processing Patient ID'); disp(nameFolds(folder_idx)); 
   
if (strcmp(User_Choice, 'N')==1)
   I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);
elseif (strcmp(User_Choice, 'M')==1)
   I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
elseif (strcmp(User_Choice, 'P')==1)
   I_F=xlsread(['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
else
    disp('Invalid Choice');
end
%% Face Detection

     I_F_cpy=I_F;
     op_img1=nameFolds(folder_idx);
     [BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,~,lower_boundary_row]=(face_detect( I_F,nameFolds,folder_idx,op_img1 ));
     lower_boundary_row=floor(lower_boundary_row);
     I_F=mat2gray(I_F);
     face_img=(I_F).*double(BW_mask_F);
    
%% Eye Detection

[modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );

%% Mouth Detection
[req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose] = mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row);

%% Nose Detection
[r_lt,c_lt,r_rt,c_rt]=nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt);

%% Mouth Row
[ mouth_row_index_req,lower_lip_row ] = mouth_row_detect( face_img,req_row,col_lt_eye,col_rt_eye,r_rt,row_rt_eye,req_col_mouth_rt,req_col_mouth_lt );

%% Connected Components
[ face_img ] = Connected_Components_Face( face_img,op_img1,lower_lip_row );

%% Hull Mask
[ face_region ] = Hull_Mask( face_img,req_col_mouth_rt,req_col_mouth_lt,c_rt,c_lt,r_rt,r_lt,mouth_row_index_req,lower_lip_row )

%% Lower Eye Regression
[ face_region1,Left_Img,Right_Img,Lower_eye_row,cmid ] = Lower_Eye_Regression( face_img,face_region,col_rt_eye,col_lt_eye,row_rt_eye,row_lt_eye,c_rt,c_lt,req_col_mouth_lt,req_col_mouth_rt )
[row,column]=find(face_img>0);
cmax=max(column);
cmin=min(column);

[img_size_X,img_size_Y]=size(face_img);
Left_Img(Lower_eye_row-10:end,cmid:cmax)=face_region(Lower_eye_row-10:end,cmid:cmax);
Left_Img_1=Left_Img;
Left_Img_1=(Left_Img_1>0);

Labels_L= bwlabel(Left_Img_1);
stats_L = regionprops(logical(Labels_L), 'Area');
Ar_L=struct2cell(stats_L);
Ar_L=cell2mat(Ar_L);
LabelmaxArea_L=find(Ar_L==max(Ar_L));
Logical_Left_ROI=[Labels_L==LabelmaxArea_L];


A_ROI_L=I_F_cpy.*double(Logical_Left_ROI);
A_ROI_L=imfill(A_ROI_L,'holes');

Right_Img(Lower_eye_row-10:end,cmin:cmid)=face_region(Lower_eye_row-10:end,cmin:cmid);
Right_Img_1=Right_Img;
Right_Img_1=(Right_Img_1>0);


Labels_R= bwlabel(Right_Img_1);
stats_R = regionprops(logical(Labels_R), 'Area');
Ar_R=struct2cell(stats_R);
Ar_R=cell2mat(Ar_R);
LabelmaxArea_R=find(Ar_R==max(Ar_R));
Logical_Right_ROI=[Labels_R==LabelmaxArea_R];

A_ROI_R=I_F_cpy.*double(Logical_Right_ROI);
A_ROI_R=imfill(A_ROI_R,'holes');
%% Display
 close all;
[r,c]=find(face_img);
rmax=max(r);
figure;
imshow(face_img);title(nameFolds{folder_idx});
hold on;
plot(col_rt_eye,row_rt_eye,'c*');
plot(col_lt_eye,row_lt_eye,'c*');
row_mean_eye=row_lt_eye;
plot_variable=[req_row:rmax];
plot(c_rt,r_rt,'b*');
plot(c_lt,r_lt,'b*');
plot(req_col_mouth_rt,mouth_row_index_req,'g*');
plot(req_col_mouth_lt,mouth_row_index_req,'g*');


end  