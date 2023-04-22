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
      row_mean_eye=row_lt_eye;
  %%  Geometry
     
      [r,c]=find(face_img>0);
      cmin=min(c);
      cmax=max(c);
  
      euclideanDistance = abs(col_rt_eye-col_lt_eye);
      col_lip=[cmin:cmax];
      row_lip=(1.8*euclideanDistance)+row_mean_eye;
     
      per_bisec=ceil((col_rt_eye+col_lt_eye)/2);
      min_ear_row=row_lip;
      min_ear_col=col_lip(1);
      max_ear_row=row_lip;
      max_ear_col=cmax;
      
      figure();
      imshow(face_img);
      hold on;
      y=[];
      for x=min_ear_col:max_ear_col
      y=[y ceil(min_ear_row+(((x-min_ear_col)*(min_ear_row-max_ear_row))/(min_ear_col-max_ear_col)))];
      end
      x=[min_ear_col:max_ear_col];
      plot(x,y,'c*');
      per_bisec_col_plot=[col_rt_eye:col_lt_eye];
     
      plot(per_bisec_col_plot,row_lt_eye,'c*');
      req_loc_in_ear_row=find(per_bisec==x);
      req_loc_in_ear_row=ceil(y(req_loc_in_ear_row));
      
      min_per_bisec_row=row_lt_eye;
      min_per_bisec_col=per_bisec;
      max_per_bisec_row=req_loc_in_ear_row;
      max_per_bisec_col=per_bisec;
      
      req_per_rows=[min_per_bisec_row:max_per_bisec_row];
      plot(per_bisec,req_per_rows,'c*');
    
%% Perpendiculars method- Corner
    nose_img_lt=[];
    nose_img_rt=[];
    modified_min_row_nose=ceil((1/3)*(max_per_bisec_row-min_per_bisec_row)+min_per_bisec_row); 
    for i=(modified_min_row_nose+1):max_per_bisec_row
         for j=col_rt_eye+1:col_lt_eye
             if(j>per_bisec)
             nose_img_lt(i-modified_min_row_nose,j-per_bisec)=face_img(i,j);
             else
             nose_img_rt(i-modified_min_row_nose,j-col_rt_eye)=face_img(i,j);
             end
         end
     end
    figure();
    subplot(1,2,2);imshow(nose_img_lt);
    subplot(1,2,1);imshow(nose_img_rt);
    C_lt = corner(nose_img_lt);
%     hold on
%     plot(C_lt(:,1), C_lt(:,2), 'r*');
%     hold off;
%     figure();
%     imshow(nose_img_lt);
%     hold on
    Corner_pts_lt=[];
    for index_corner_lt=1:size(C_lt,1)
    Corner_pts_lt(index_corner_lt)=(nose_img_lt(C_lt(index_corner_lt,2),C_lt(index_corner_lt,1)));
    end
    max_nose_intensity_lt=max(Corner_pts_lt);
    index_corner_find_lt=find(Corner_pts_lt==max_nose_intensity_lt);
    plot(C_lt(index_corner_find_lt,1),C_lt(index_corner_find_lt,2),'*c');
%     hold off;
    
    C_rt = corner(nose_img_rt);
%     hold on
%     plot(C_rt(:,1), C_rt(:,2), 'r*');
%     hold off;
%     figure();
%     imshow(nose_img_rt);
%     hold on
    Corner_pts_rt=[];
    for index_corner_rt=1:size(C_rt,1)
    Corner_pts_rt(index_corner_rt)=(nose_img_rt(C_rt(index_corner_rt,2),C_rt(index_corner_rt,1)));
    end
    max_nose_intensity_rt=max(Corner_pts_rt);
    index_corner_find_rt=find(Corner_pts_rt==max_nose_intensity_rt);
    plot(C_rt(index_corner_find_rt,1),C_rt(index_corner_find_rt,2),'*c');
    hold off;
    figure();
    imshow(face_img);
    hold on;
    plot(C_rt(index_corner_find_rt,1)+col_rt_eye+1,C_rt(index_corner_find_rt,2)+modified_min_row_nose,'*c');
    plot(C_lt(index_corner_find_lt,1)+per_bisec+1,C_lt(index_corner_find_lt,2)+modified_min_row_nose,'*c');
    hold off;
    
    figure();
    imshow(face_img);
    hold on;
    plot(C_rt(:,1)+col_rt_eye+1,C_rt(:,2)+modified_min_row_nose,'*c');
    plot(C_lt(:,1)+per_bisec+1,C_lt(:,2)+modified_min_row_nose,'*c');
     
    
%% ANGLE METHOD  
%       %Right Image 30 degrees
%       max_angle=35;
%       min_angle=10;
%       for angle=(max_angle):-1:(min_angle)
%           x_right=[];
%           for y_right=row_lt_eye+1:max_per_bisec_row
%           req_right_30_col_length=ceil(abs((y_right-row_lt_eye)*tan((angle*pi)/180)));
%           x_right_temp=per_bisec-req_right_30_col_length;
%           check_loc_x=find(x_right_temp==x);
%           check_loc_y=find(y_right==y);
%           if(check_loc_x==check_loc_y)
%               break;
%           end
%           x_right=[x_right x_right_temp];
%           end   
%           y_right=[row_lt_eye+1:max_per_bisec_row];
% %           plot(x_right,y_right,'c*');
%           Sum=0;
%           for index=row_lt_eye+1:max_per_bisec_row
%               Sum=Sum+face_img(x_right(index-row_lt_eye),y_right(index-row_lt_eye));
%           end
%           Fx(angle)=Sum;
%       end
%       %Fx=gradient(Fx);
% %       figure();
% %       imshow(face_img);
% %       hold on;
%       x_right=[];
%       max_angle=find(Fx==max(Fx));
%       for y_right=row_lt_eye+1:max_per_bisec_row
%           req_right_30_col_length=ceil(abs((y_right-row_lt_eye)*tan((max_angle*pi)/180)));
%           x_right_temp=per_bisec-req_right_30_col_length;
%           check_loc_x=find(x_right_temp==x);
%           check_loc_y=find(y_right==y);
%           if(check_loc_x==check_loc_y)
%               break;
%           end
%           x_right=[x_right x_right_temp];
%       end   
%       y_right=[row_lt_eye+1:max_per_bisec_row];
%       plot(x_right,y_right,'c*');
%       
%       
%       % Left image
%       max_angle=35;
%       min_angle=10;
%       for angle=(max_angle):-1:(min_angle)
%           x_left=[];
%           for y_left=row_lt_eye+1:max_per_bisec_row
%           req_left_30_col_length=ceil(abs((y_left-row_lt_eye)*tan((angle*pi)/180)));
%           x_left_temp=per_bisec-req_left_30_col_length;
%           check_loc_x=find(x_left_temp==x);
%           check_loc_y=find(y_left==y);
%           if(check_loc_x==check_loc_y)
%               break;
%           end
%           x_left=[x_left x_left_temp];
%           end   
%           y_left=[row_lt_eye+1:max_per_bisec_row];
% %          plot(x_left,y_left,'c*');
%           Sum=0;
%           for index=row_lt_eye+1:max_per_bisec_row
%               Sum=Sum+face_img(x_left(index-row_lt_eye),y_left(index-row_lt_eye));
%           end
%           Fx(angle)=Sum;
%       end
%       %Fx=gradient(Fx);
% %       figure();
% %       imshow(face_img);
% %       hold on;
%       x_left=[];
%       max_angle=find(Fx==max(Fx));
%       for y_left=row_lt_eye+1:max_per_bisec_row
%           req_left_30_col_length=ceil(abs((y_left-row_lt_eye)*tan((max_angle*pi)/180)));
%           x_left_temp=per_bisec+req_left_30_col_length;
%           check_loc_x=find(x_left_temp==x);
%           check_loc_y=find(y_left==y);
%           if(check_loc_x==check_loc_y)
%               break;
%           end
%           x_left=[x_left x_left_temp];
%       end   
%       y_left=[row_lt_eye+1:max_per_bisec_row];
%       plot(x_left,y_left,'c*');

        %% Ending
      folder_idx
      nameFolds{folder_idx}
end