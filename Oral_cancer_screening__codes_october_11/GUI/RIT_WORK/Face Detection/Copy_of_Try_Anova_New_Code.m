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
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
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
   
%      figure, imshow(face_img);
%      h = imrect;
%      position = wait(h);
%      set(0,'DefaultFigureVisible','off')
%      mid_rectangle=position(1)+ceil((position(3)/2));
%      p=[];
%      for index_rect=mid_rectangle:-1:position(1)
%          grp_1=face_img((position(2):position(2)+position(4)),index_rect);
%          grp_2=face_img((position(2):position(2)+position(4)),index_rect-1);
%          y=[grp_1 grp_2];
%          p(index_rect-position(1)+1)=anova1(y); 
%      end
%      q=imboxfilt(p,21);
%      set(0,'DefaultFigureVisible','on')
%     figure();
%     stem(p);
%     figure();
%     stem(q);
%     figure();
%     imshow(face_img);
    window_size=21;
    set(0,'DefaultFigureVisible','off')
    p_mouth_rt=[];
    for mouth_col_index_rt=(col_rt_eye-window_size):col_rt_eye
         col_data_1=face_img(req_row:max_face_row,mouth_col_index_rt);
         col_data_2=face_img(req_row:max_face_row,mouth_col_index_rt+1);
         y_mouth_rt=[col_data_1 col_data_2];
         p_mouth_rt(mouth_col_index_rt-(col_rt_eye-window_size)+1)=anova1(y_mouth_rt); 
    end
    set(0,'DefaultFigureVisible','on')
         
         counter=1;
         difference_mouth=p_mouth_rt(counter+1)-p_mouth_rt(counter)

         while(difference_mouth>=0&&counter<size(p_mouth_rt,2))
             difference_mouth=p_mouth_rt(counter+1)-p_mouth_rt(counter);
             counter=counter+1;
         end
         while(difference_mouth<=0&&counter<size(p_mouth_rt,2))
             difference_mouth=p_mouth_rt(counter+1)-p_mouth_rt(counter);
             counter=counter+1;
         end
         req_col_mouth=counter-1+(col_rt_eye-window_size);
        
         
         
    set(0,'DefaultFigureVisible','off')
    p_mouth_lt=[];
    for mouth_col_index_lt=col_lt_eye:(col_lt_eye+window_size)
         col_data_1=face_img(req_row:max_face_row,mouth_col_index_lt);
         col_data_2=face_img(req_row:max_face_row,mouth_col_index_lt+1);
         y_mouth_lt=[col_data_1 col_data_2];
         p_mouth_lt(mouth_col_index_lt-(col_lt_eye)+1)=anova1(y_mouth_lt); 
    end
    set(0,'DefaultFigureVisible','on')
    
         counter_lt=size(p_mouth_lt,2)-1   ;
         difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt)

         while(difference_mouth_lt<=0&&counter_lt<size(p_mouth_lt,2))
             difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);
             counter_lt=counter_lt-1;
         end
         while(difference_mouth_lt>=0&&counter_lt<size(p_mouth_lt,2))
             difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);
             counter_lt=counter_lt-1;
         end
         counter_lt=counter_lt-1;
         req_col_mouth_lt=counter_lt-1+col_lt_eye;
         
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
         plot(col_lt,row_lt,'c*');
          plot(col_rt,row_rt,'c*');
     
         row_length=[req_row:max_face_row];
         plot(req_col_mouth,row_length,'c*');
         row_length=[req_row:max_face_row];
         plot(req_col_mouth_lt,row_length,'c*');
         figure();
         stem(p_mouth_lt);title('LEFT');
         figure();
         stem(p_mouth_rt);title('Right');
         
         
%%   Neck Detection

[r,c]=find(face_img>0);
mid_c=ceil((min(c)+max(c))/2);
I_rt = face_img(req_row:max(r),min(c):mid_c);
I_lt = face_img(req_row:max(r),mid_c+1:max(c));
C_rt_neck = corner(I_rt);
subplot(1,2,1);imshow(I_rt);
hold on
plot(C_rt_neck(:,1), C_rt_neck(:,2), 'r*');
hold off;
subplot(1,2,2);
C_lt_neck = corner(I_lt);
imshow(I_lt);
hold on
plot(C_lt_neck(:,1), C_lt_neck(:,2), 'r*');
hold off;
sort_C_rt_neck=sortrows(C_rt_neck,2);
sort_C_lt_neck=sortrows(C_lt_neck,2);
corner_slope_lt=[];
corner_angle_lt=[];
corner_slope_rt=[];
corner_angle_rt=[];
for i=1:size(sort_C_rt_neck,1)-1
    corner_slope_rt(i)=(sort_C_rt_neck(i+1,2)-sort_C_rt_neck(i,2))/(sort_C_rt_neck(i+1,1)-sort_C_rt_neck(i,1));
   % corner_angle(i)=((corner_angle(i)*180)/pi);
    corner_angle_rt(i)=atan(corner_slope_rt(i))*(180/pi);
end

for i=1:size(sort_C_lt_neck,1)-1
    corner_slope_lt(i)=(sort_C_lt_neck(i+1,2)-sort_C_lt_neck(i,2))/(sort_C_lt_neck(i+1,1)-sort_C_lt_neck(i,1));
   % corner_angle(i)=((corner_angle(i)*180)/pi);
    corner_angle_lt(i)=atan(corner_slope_lt(i))*(180/pi);
end

figure();
stem(corner_angle_rt);
figure();
stem(corner_angle_lt);

neck_index_rt=1;
neg_count=0;
pos_count=0;
    if(corner_angle_rt(neck_index_rt)>=0)
        while((corner_angle_rt(neck_index_rt)>=0 || neg_count<=1) && neck_index_rt~=size(corner_angle_rt,2))
            if(corner_angle_rt(neck_index_rt)<0)
                neg_count=neg_count+1;
                if(corner_angle_rt(neck_index_rt+1)<0)
                    neg_count=2;
                    break;
                end
            end
            neck_index_rt=neck_index_rt+1;
        end
    else
         while(corner_angle_rt(neck_index_rt)<=0)
             neck_index_rt=neck_index_rt+1;
         end
         neg_count=0;
         while((corner_angle_rt(neck_index_rt)>=0 || neg_count<=1 )&& neck_index_rt~=size(corner_angle_rt,2))
            if(corner_angle_rt(neck_index_rt)<0)
                neg_count=neg_count+1;
                if(corner_angle_rt(neck_index_rt+1)<0)
                    neg_count=2;
                    break;
                end
            end
            neck_index_rt=neck_index_rt+1;
         end
    end
         
     neck_index_rt= neck_index_rt-1;
     neck_index_rt_value=sort_C_rt_neck(neck_index_rt,2);
     
%              if(corner_angle_rt(neck_index_rt)<0)
%                 neg_count=neg_count+1;
%                 if(corner_angle_rt(neck_index_rt+1)<0)
%                     neg_count=2;
%                     break;
%                 end
%             end
%         end
%             neck_index_rt=neck_index_rt+1;
%     end
%         
%         
%         
%         
%         
%         while(neg_count<=1 || corner_angle_rt(neck_index_rt)>=0 )
%             if(corner_angle_rt(neck_index_rt)<=0)
%                 neg_count=neg_count+1;
%             end
%             neck_index_rt=neck_index_rt+1;
%         end
%     else
%         while(neg_count<=1 ||corner_angle_rt(neck_index_rt)>=0)
%             if(corner_angle_rt(neck_index_rt)<=0)
%               neg_count=neg_count+1;
%             end
%             neck_index_rt=neck_index_rt+1;
%         end
%         while(corner_angle_rt(neck_index_rt)>=0 )
%             neck_index_rt=neck_index_rt+1;
%         end
%     end
    
neck_index_lt=1;
pos_count=0;
     
   if(corner_angle_lt(neck_index_lt)<=0)
        while((corner_angle_lt(neck_index_lt)<=0 || pos_count<=1) && neck_index_lt~=size(corner_angle_lt,2))
            if(corner_angle_lt(neck_index_lt)>0)
                pos_count=pos_count+1;
                if(corner_angle_lt(neck_index_lt+1)>0)
                    pos_count=2;
                    break;
                end
            end
            neck_index_lt=neck_index_lt+1;
        end
    else
         while(corner_angle_lt(neck_index_lt)>=0)
             neck_index_lt=neck_index_lt+1;
         end
         pos_count=0;
         while((corner_angle_lt(neck_index_lt)<=0 || pos_count<=1) && neck_index_lt~=size(corner_angle_lt,2))
            if(corner_angle_lt(neck_index_lt)>0)
                pos_count=pos_count+1;
                if(corner_angle_lt(neck_index_lt+1)>0)
                    pos_count=2;
                    break;
                end
            end
                        neck_index_lt=neck_index_lt+1;

         end
   end
     neck_index_lt= neck_index_lt-1;
     if(neck_index_lt==size(corner_angle_lt,2))
         neck_index_lt=size(corner_angle_lt,2);
     end
     if(neck_index_rt==size(corner_angle_rt,2))
         neck_index_rt=size(corner_angle_rt,2);
     end
     neck_index_lt_value=sort_C_lt_neck(neck_index_lt,2);
 
%     
% neck_index_lt=1;
% neg_count=0;
% pos_count=0;
%     if(corner_angle_lt(neck_index_lt)>=0)
%         while(pos_count<=1 || corner_angle_lt(neck_index_lt)>=0 )
%             if(corner_angle_lt(neck_index_lt)>=0)
%                 pos_count=pos_count+1;
%             end
%             neck_index_lt=neck_index_lt+1;
%         end
%          while(corner_angle_lt(neck_index_lt)<=0)
%             neck_index_lt=neck_index_lt+1;
%         end
%     else
%         while(pos_count<=1 ||corner_angle_lt(neck_index_lt)<=0)
%             if(corner_angle_lt(neck_index_lt)>=0)
%                 pos_count=pos_count+1;
%             end
%             neck_index_lt=neck_index_lt+1;
%         end
%     end
%     
   
%      
%      neck_index_lt=size(corner_angle_lt,2)
%     if(corner_angle_lt(neck_index_lt)>0)
%         while(corner_angle_lt(neck_index_lt)>0)
%             neck_index_lt=neck_index_lt-1;
%         end
%     else
%         while(corner_angle_lt(neck_index_lt)<0)
%             neck_index_lt=neck_index_lt-1;
%         end
%     end
%     
%      neck_index_lt= neck_index_lt+1;
%      neck_index_lt=sort_C_lt_neck(neck_index_lt,2);
     
     
%     %% Mouth corner Detection
%     mouth_corner_rt_min=col_rt_eye-right_shift;
%     mouth_corner_rt_max=col_rt;
%     mouth_corner_lt_min=col_lt;
%     mouth_corner_lt_max=col_lt_eye+left_shift;
%     
%     mouth_rt_img=face_img(req_row:max_face_row,mouth_corner_rt_min:mouth_corner_rt_max);
%     mouth_lt_img=face_img(req_row:max_face_row,mouth_corner_lt_min:mouth_corner_lt_max);
%     
%     Corner_rt = corner(mouth_rt_img);
%     lip_rt_row=Corner_rt(:,2)+req_row;
%     lip_rt_col=Corner_rt(:,1)+mouth_corner_rt_min;
%         
%     Corner_lt = corner(mouth_lt_img);
%     lip_lt_row=Corner_lt(:,2)+req_row;
%     lip_lt_col=Corner_lt(:,1)+mouth_corner_lt_min;
% 
%     imshow(face_img);
%     hold on
%     plot(lip_rt_col, lip_rt_row, 'r*');
%     plot(lip_lt_col, lip_lt_row, 'r*');

  
 
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
         plot(col_lt,row_lt,'c*');
          plot(col_rt,row_rt,'c*');
     
         row_length=[req_row:max_face_row];
         plot(req_col_mouth,row_length,'c*');
         row_length=[req_row:max_face_row];
         plot(req_col_mouth_lt,row_length,'c*');
         col_length_rt=[min(c):mid_c];
         col_length_lt=[mid_c:max(c)];
         mean_neck=ceil((neck_index_rt+neck_index_lt)/2);
         plot(col_length_rt,(mean_neck+req_row),'c*');
         plot(col_length_lt,(mean_neck+req_row),'c*');
         
         column_reject_rt=sort_C_rt_neck(neck_index_rt,2)+min(c);
         column_reject_lt=sort_C_lt_neck(neck_index_lt,2)+mid_c;
         array_counter=1;
         row_vector=[];
         col_vector=[];
         for array_index=1:neck_index_rt
             if((sort_C_rt_neck(array_index,1)+min(c))<column_reject_rt)
             row_vector(array_counter)=sort_C_rt_neck(array_index,2)+req_row;
             col_vector(array_counter)=sort_C_rt_neck(array_index,1)+min(c);
             array_counter=array_counter+1;
             end
         end
         
         for array_index=1:neck_index_lt
             if((sort_C_lt_neck(array_index,1)+mid_c)>column_reject_lt)
             row_vector(array_counter)=sort_C_lt_neck(array_index,2)+req_row;
             col_vector(array_counter)=sort_C_lt_neck(array_index,1)+mid_c;
             array_counter=array_counter+1;
             end 
         end
         figure();
         imshow(I_F,[]);
         hold on;
         plot(col_vector,row_vector,'*');
         hold off;
             
             %% Convex Hull Check
p = polyfit(col_vector,row_vector,2);
x=[min(c):max(c)];
y=polyval(p,x);
figure();
imshow(I_F,[]);
hold on;
plot(x,y);
 
end
