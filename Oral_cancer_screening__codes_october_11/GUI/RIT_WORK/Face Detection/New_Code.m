%% Main Code for Face Detection
close all
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
      [ modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
      figure();
      imshow(face_img);title(nameFolds{folder_idx});
      hold on;
      plot(col_rt_eye,row_rt_eye,'c*');
      plot(col_lt_eye,row_lt_eye,'c*');
      % Plotting the bounding box around the eye
      rectangle('Position', [ col_rt_eye-70,row_rt_eye-20, 70, 40],...
        'EdgeColor','r', 'LineWidth', 3)
      rectangle('Position', [ col_lt_eye,row_lt_eye-20, 70, 40],...
        'EdgeColor','r', 'LineWidth', 3)
      row_mean_eye=row_lt_eye;
%% Modification
        
    [r,c]=find(face_img>0);
    rmin=min(r);
    rmax=max(r);
    column_id_data=face_img(mean_eye_brow_row,:);
    c=find(column_id_data>0);
    cmin=min(c);
    cmax=max(c);
    cmid=ceil((col_lt_eye+col_rt_eye)/2);
    
    req_dist=cmax-cmin;
    max_face_row=modified_r_min+req_dist;
    if(max_face_row > rmax)
        max_face_row=rmax;
    end
    min_row=row_lt_eye;
    cmid=ceil((cmin+cmax)/2);
   % figure();
   % imshow(face_img);title(nameFolds{folder_idx});
   % hold on;
   % plot(cmid,max_face_row,'r*');
    
    modified_min_row_nose=ceil((1/4)*(max_face_row-min_row)+min_row); 
    
    temp=[];
    nose_img=face_img(modified_min_row_nose:max_face_row,col_rt_eye:col_lt_eye);
    for i=1:size(nose_img,1)
         temp(i,:)=(gradient(nose_img(i,:)));
         variance(i)=var(temp(i,:));
         Fx_temp=(gradient(nose_img(i,:)));
    end
     
     cropped_variance=variance(1:((3/4)*size(variance,2)));
     thresh=0.6*max(cropped_variance);
     local_max=find(cropped_variance>=thresh);
     local_max=local_max(1);
     % [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(cropped_variance);
     counter=local_max;
     difference=cropped_variance(counter+1)-cropped_variance(counter)
    
     while(difference>=0)
         difference=cropped_variance(counter+1)-cropped_variance(counter);
         counter=counter+1;
     end
     while(difference<=0&&counter<size(cropped_variance,2))
         difference=cropped_variance(counter+1)-cropped_variance(counter);
         counter=counter+1;
     end
     req_row=counter-1+modified_min_row_nose;
     temp=[min(c):max(c)];
    % hold on;
    % plot(temp,req_row,'c*');
     %hold off;
    % figure();
    % max_prom=max(p_lt);
    % prom_loc=find(max_prom==p_lt);
%      stem(variance);
%      title('variance');
    % hold on;
    % plot(locs_lt,pks_lt,'*');
    % hold on;
    % plot(locs_lt(prom_loc),pks_lt(prom_loc),'c*');

    
    %% Finding hotspots
     eye_diff_dist=col_lt_eye-col_rt_eye;
     eye_diff_dist=ceil(eye_diff_dist/3);
     
     right_shift=eye_diff_dist;
     left_shift=eye_diff_dist;
     nose_img_lt=[];
     nose_img_rt=[];
     req_row=req_row+5;
     modified_min_row_nose=ceil((2/3)*(req_row-mean_eye_brow_row)+mean_eye_brow_row); 
     modified_cmid_nose_lt=ceil((cmid+col_lt_eye+left_shift)/2);
     modified_cmid_nose_rt=ceil((cmid+col_rt_eye-right_shift)/2);
     modified_cmid_nose_lt=ceil((cmid+modified_cmid_nose_lt)/2);
     modified_cmid_nose_rt=ceil((cmid+modified_cmid_nose_rt)/2);
     
     for i=(modified_min_row_nose+1):req_row
         for j=col_rt_eye-right_shift+1:modified_cmid_nose_rt
             nose_img_rt(i-modified_min_row_nose,j-col_rt_eye+right_shift)=face_img(i,j);
         end
     end
     
     for i=(modified_min_row_nose+1):req_row
         for j=modified_cmid_nose_lt+1:col_lt_eye+left_shift
         nose_img_lt(i-modified_min_row_nose,j-modified_cmid_nose_lt)=face_img(i,j);
         end
     end
     
     max_lt=max(nose_img_lt(:));
     [r_lt,c_lt]=find(nose_img_lt==max_lt,1);
    
     max_rt=max(nose_img_rt(:));
     [r_rt,c_rt]=find(nose_img_rt==max_rt,1);
     
     % Adding Offsets
     row_lt=r_lt+modified_min_row_nose;
     row_rt=r_rt+modified_min_row_nose;
     
     col_lt=c_lt+modified_cmid_nose_lt;
     col_rt=c_rt+col_rt_eye-right_shift;
     
   %  figure();
   %  imshow(face_img);
  %   hold on;
     plot(col_lt,row_lt,'c*');
     plot(col_rt,row_rt,'c*');
   
%     %% Mouth corner Detection
    mouth_corner_rt_min=col_rt_eye-right_shift;
    mouth_corner_rt_max=col_rt;
    mouth_corner_lt_min=col_lt;
    mouth_corner_lt_max=col_lt_eye+left_shift;
    
    mouth_rt_img=face_img(req_row:max_face_row,mouth_corner_rt_min:mouth_corner_rt_max);
    mouth_lt_img=face_img(req_row:max_face_row,mouth_corner_lt_min:mouth_corner_lt_max);
    
    Corner_rt = corner(mouth_rt_img);
    lip_rt_row=Corner_rt(:,2)+req_row;
    lip_rt_col=Corner_rt(:,1)+mouth_corner_rt_min;
        
    Corner_lt = corner(mouth_lt_img);
    lip_lt_row=Corner_lt(:,2)+req_row;
    lip_lt_col=Corner_lt(:,1)+mouth_corner_lt_min;
% 
    imshow(face_img);
    hold on
    plot(lip_rt_col, lip_rt_row, 'r*');
    plot(lip_lt_col, lip_lt_row, 'r*');

%     
                end
