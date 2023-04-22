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
      [ x,y,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
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
      row_lip=(1.5*euclideanDistance)+row_mean_eye;
     
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
    
%% Gradient Method  
    nose_img_lt=[];
    nose_img_rt=[];
    left_shift=10;
    right_shift=10;
    modified_min_row_nose=ceil((1/2)*(max_per_bisec_row-min_per_bisec_row)+min_per_bisec_row); 
     for i=(modified_min_row_nose+1):max_per_bisec_row
         for j=col_rt_eye-right_shift+1:col_rt_eye
             nose_img_rt(i-modified_min_row_nose,j-col_rt_eye+right_shift)=face_img(i,j);
         end
     end
     
     for i=(modified_min_row_nose+1):max_per_bisec_row
         for j=col_lt_eye+1:col_lt_eye+left_shift
         nose_img_lt(i-modified_min_row_nose,j-col_lt_eye)=face_img(i,j);
         end
     end
     figure();
     imshow(face_img);hold on;
     Fx_rt=[];
     temp_rt=[];
     temp_lt=[];
     variance_rt=[];
     variance_lt=[];
     variance=[];
     for i=1:size(nose_img_rt,1)
         temp_rt(i,:)=gradient(nose_img_rt(i,:))';
         variance_rt(i)=var(temp_rt(i,:));
         Fx_rt_temp=(gradient(nose_img_rt(i,:)));
%          Fx_rt(i)=max(Fx_rt_temp);
%          c=find(Fx_rt(i)==Fx_rt_temp);
         [pks_rt,locs_rt,w_rt,p_rt] = findpeaks(Fx_rt_temp);
         if(isempty(p_rt)==isempty([]))
             if i>1
                 Fx_rt(i)=Fx_rt(i-1);
             else
                 Fx_rt(i)=0;
             end
         else 
             p_rt_max=max(p_rt);
             index_loc=find((p_rt_max==p_rt),1);
             Fx_rt(i)=Fx_rt_temp(locs_rt(index_loc));
         end
             % plot(c+col_rt_eye-right_shift,i+modified_min_row_nose,'c*');
     end
     Fx_lt=[];
     for i=1:size(nose_img_lt,1)
         temp_lt(i,:)=(gradient(nose_img_lt(i,:)));
         variance_lt(i)=var(temp_lt(i,:));
         Fx_lt_temp=(gradient(nose_img_lt(i,:)));
%          Fx_lt(i)=max(Fx_lt_temp);
%          c=find(Fx_lt(i)==Fx_lt_temp);
         [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(Fx_lt_temp);
         if(isempty(p_lt)==isempty([]))
             if i>1
                 Fx_lt(i)=Fx_lt(i-1);
             else
                 Fx_lt(i)=0;
             end
         else
             p_lt_max=max(p_lt);
             index_loc=find((p_lt_max==p_lt),1);
             Fx_lt(i)=Fx_lt_temp(locs_lt(index_loc));
         end
        % plot(c+col_lt_eye,i+modified_min_row_nose,'c*');
     end
     figure();
     plot(Fx_rt);title('RIGHT');
     figure();
     plot(Fx_lt);title('LEFT');
     Fx_req_rt=min(Fx_rt);
     pks_rt=[];
     locs_rt=[];
     w_rt=[];
     p_rt=[];
     pks_lt=[];
     locs_lt=[];
     w_lt=[];
     p_lt=[];
         req_row_rt=find(min(variance_rt)==variance_rt)+modified_min_row_nose
         req_row_lt=find(min(variance_lt)==variance_lt)+modified_min_row_nose
         [pks_rt,locs_rt,w_rt,p_rt] = findpeaks(Fx_rt);
         p_rt_max=max(p_rt);
         index_loc=find(p_rt_max==p_rt);
         r_rt=locs_rt(index_loc);
         c_rt=min(find(Fx_rt(r_rt)==gradient(nose_img_rt(r_rt,:))));
         
         [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(Fx_lt);
         p_lt_max=max(p_lt);
         index_loc=find(p_lt_max==p_lt);
         r_lt=locs_lt(index_loc);
         c_lt=min(find(Fx_lt(r_lt)==gradient(nose_img_lt(r_lt,:))));
%     r_rt=min(find(Fx_req_rt==Fx_rt));
%     c_rt=min(find(min(gradient(nose_img_rt(r_rt,:)))==gradient(nose_img_rt(r_rt,:))));
    figure();
    imshow(face_img);title(nameFolds{folder_idx});
    hold on;
    plot(c_rt+col_rt_eye-right_shift,r_rt+modified_min_row_nose,'c*');
    
     
    Fx_req_lt=max(Fx_lt);
     
%     r_lt=min(find(Fx_req_lt==Fx_lt));
%     c_lt=min(find(max(gradient(nose_img_lt(r_lt,:)))==gradient(nose_img_lt(r_lt,:))));
    hold on;
    plot(c_lt+col_lt_eye,r_lt+modified_min_row_nose,'c*');
%% New Check
    temp=[];
    [r,c]=find(face_img>0);
   face_img=face_img(modified_min_row_nose:max_per_bisec_row,col_rt_eye:col_lt_eye);
   for i=1:size(face_img,1)
         temp(i,:)=(gradient(face_img(i,:)));
         variance(i)=var(temp(i,:));
         Fx_temp=(gradient(face_img(i,:)));
%          Fx_lt(i)=max(Fx_lt_temp);
%          c=find(Fx_lt(i)==Fx_lt_temp);
         [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(Fx_temp);
         if(isempty(p_lt)==isempty([]))
             if i>1
                 Fx_lt(i)=Fx_lt(i-1);
             else
                 Fx_lt(i)=0;
             end
         else
             p_lt_max=max(p_lt);
             index_loc=find((p_lt_max==p_lt),1);
             Fx_lt(i)=Fx_temp(locs_lt(index_loc));
         end
        % plot(c+col_lt_eye,i+modified_min_row_nose,'c*');
   end
     temp=[min(c):max(c)];
     req_row=find(min(variance)==variance)+modified_min_row_nose;
     %rows=[req_row_lt req_row_rt req_row]
     hold on;
     plot(temp,req_row,'c*');
     hold off;
     figure();
     plot(variance);title('variance');
     
        %% Ending
      folder_idx
      nameFolds{folder_idx}
end