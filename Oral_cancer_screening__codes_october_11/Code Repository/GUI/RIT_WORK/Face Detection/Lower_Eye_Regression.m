function [ face_region1,Left_Img,Right_Img,Lower_eye_row,cmid ] = Lower_Eye_Regression( face_img,face_region,col_rt_eye,col_lt_eye,row_rt_eye,row_lt_eye,c_rt,c_lt,req_col_mouth_lt,req_col_mouth_rt )
%% Documentation0
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            face_region 
%                            col_rt_eye 
%                            col_lt_eye 
%                            row_rt_eye 
%                            row_lt_eye 
%                            c_rt,c_lt,
%                            req_col_mouth_lt,req_col_mouth_rt
% o/p parameters of the fn:  Left_Img 
%                            Right_Img
%                            Lower_eye_row

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. Lower_right_eye :: Lower Eye Row for Right EYE
%                    2. Lower_left_eye :: Lower Eye Row for Left EYE
%                    3. Lower_eye_row :: Mean Lower Eye Row 
%                    4. Eye_dist :: Distance between R & L eye canthus
%                
%% Working: The objective is to remove the region above the eyes, as they 
% are not significant for oral cancer diagnosis. We determine the lower
% region of eye using regression based on the distance between the two eye
% canthus.
Eye_dist=col_lt_eye-col_rt_eye;
Lower_right_eye=0.09291*Eye_dist+6.1139+row_rt_eye; % Regression model for Right Eye
Lower_left_eye=0.1189*Eye_dist+2.6775+row_lt_eye; % Regression model for Left Eye
Lower_eye_row=ceil((Lower_right_eye+Lower_left_eye)/2); % Average of the above parameters.

[row,column]=find(face_img>0);
cmax=max(column);
cmin=min(column);

[img_size_X,img_size_Y]=size(face_img);

% Identifying the middle of the face.
c1mid=ceil((cmax+cmin)/2);  % Overall cmid using extremes of face.
c2mid=ceil((col_lt_eye+col_rt_eye)/2); % cmid using the L &R eye canthus locations
c3mid=ceil((c_rt(1)+c_lt(1))/2); % cmid using the R & L  nose locations
c4mid=ceil((req_col_mouth_lt+req_col_mouth_rt)/2); % cmid using the R & L mouth endpoint locations
cmid=ceil((c1mid+c2mid+c3mid+c4mid)/4); % Average of the above cmid's

face_region1=face_region;
face_region1(1:Lower_eye_row-10,:)=0; % Removing the region above the lower eye row, since they are not required for oral cancer diagnosis.

Left_Img=zeros(img_size_X,img_size_Y); % Computing the Left ROI
Right_Img=zeros(img_size_X,img_size_Y); % Computing the Right ROI


end

