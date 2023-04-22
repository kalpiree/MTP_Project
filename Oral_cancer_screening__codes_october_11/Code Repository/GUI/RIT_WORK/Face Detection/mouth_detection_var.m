function [ req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose ] =mouth_detection_var( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row)
%% Documentation
% face_detect:-
% Called by funtion: Try_Anova_New_Code.m
% Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            modified_r_min 
%                            row_lt_eye 
%                            row_rt_eye 
%                            col_lt_eye 
%                            col_rt_eye 
%                            mean_eye_brow_row
% o/p parameters of the fn:  req_col_mouth_lt 
%                            req_col_mouth_rt
%                            req_row
%                            max_face_row

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. modified_r_min :: Row index representing hair line
%                    2. max_face_row :: Project the horizontal maximum of the face from modified_r_min to obtain maximum face row
%                    3. modified_min_row_nose :: Represent the half of nose. 
%                    4. variance :: Store the row-wise variance.
%                    5. cropped_variance :: Reject the latter 25% of variance
%                    6. thresh :: threshold to identify the required peak.
%                    7. local_max :: Locate the first peak satifying the threshold
%                    8. difference :: Compute the successive differences to ID the peak
%                    9. req_row :: Represents the row between the mouth and the nose.
%                   10. window_size :: The window to be scanned using ANOVA
%                   11. p_mouth_rt :: Significance between two columns, using ANOVA for the right image
%                   12. difference_mouth_rt :: r_max is computed to be 40% from the modified r_min of right half
%                   13. counter_rt :: Array Counter 
%                   14. counter_lt :: Row components of the sampled columns
%                   15. col_gradient_lt :: Gradient of the smapled column
%                   16. difference_mouth_lt :: Non zero component of the gradient of the smapled column
%                   17. req_col_mouth_lt :: findpeaks return variables to identify prominent peaks
%                  
%%    Working: Find the req_row, the row between nose and mouth. From the req_row to the max_face_row, select the columns, 
%              w.r.t the window size. Consider two successive columns, continuously and perform the ANOVA analysis. Determine the 
%              significance for each pair of the columns. Identify the first minimum from the significance vector, 
%              from the extremes for both the left and right images. These two columns indicate the corner points of 
%              the mouth.
    [r,c]=find(face_img>0);
    rmin=min(r);
    rmax=max(r);
    column_id_data=face_img(mean_eye_brow_row,:); % column_id_data--> to get a true notion of the face width i.e the width of the face is measured for the mean_eye_brow_row 
    c=find(column_id_data>0);
    cmin=min(c);
    cmax=max(c);
%     cmid=ceil((col_lt_eye+col_rt_eye)/2);
    
    req_dist=cmax-cmin; %req_dist is the width of the face 
    max_face_row=modified_r_min+req_dist; %req_dist added to modified_r_min(row from below the hair) gives height of the face
    if(max_face_row > rmax)
        max_face_row=rmax;
    end
    min_row=row_lt_eye; %row_lt_eye is the row component of the hotspot
    cmid=ceil((cmin+cmax)/2);
    modified_min_row_nose=ceil((1/4)*(max_face_row-min_row)+min_row); 
 
    temp=[];
    nose_img=face_img(modified_min_row_nose:max_face_row,col_rt_eye:col_lt_eye);
    for i=1:size(nose_img,1)
         temp(i,:)=(gradient(nose_img(i,:)));
         variance(i)=var(temp(i,:));
    end
     
     cropped_variance=variance(1:((3/4)*size(variance,2)));
     thresh=0.6*max(cropped_variance); % Explanation??
     local_max=find(cropped_variance>=thresh);  % Explanation??
     local_max=local_max(1);
     % [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(cropped_variance);
     counter_rt=local_max;
     difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
    
     while(difference>=0)
         difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
         counter_rt=counter_rt+1;
     end
     while(difference<=0&&counter_rt<size(cropped_variance,2))
         difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
         counter_rt=counter_rt+1;
     end
     
     req_row=counter_rt-1+modified_min_row_nose;
    
     window_size=21;
    set(0,'DefaultFigureVisible','off');
    p_mouth_rt=[];
    for mouth_col_index_rt=(col_rt_eye-window_size):col_rt_eye
         col_data_1=face_img(req_row:rmax,mouth_col_index_rt);
         col_data_2=face_img(req_row:rmax,mouth_col_index_rt+1);
         y_mouth_rt=[col_data_1 col_data_2];
         p_mouth_rt(mouth_col_index_rt-(col_rt_eye-window_size)+1)=var(col_data_2-col_data_1);  
    end
    set(0,'DefaultFigureVisible','on');
         
         counter_rt=1;
         difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);

         while(difference_mouth_rt>=0&&counter_rt<size(p_mouth_rt,2))
             difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);
             counter_rt=counter_rt+1;
         end
         while(difference_mouth_rt<=0&&counter_rt<size(p_mouth_rt,2))
             difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);
             counter_rt=counter_rt+1;
         end
         req_col_mouth_rt=counter_rt-1+(col_rt_eye-window_size);
        
         
         
    set(0,'DefaultFigureVisible','off');
    p_mouth_lt=[];
    for mouth_col_index_lt=col_lt_eye:(col_lt_eye+window_size)
         col_data_1=face_img(req_row:rmax,mouth_col_index_lt);
         col_data_2=face_img(req_row:rmax,mouth_col_index_lt+1);
         y_mouth_lt=[col_data_1 col_data_2];
         p_mouth_lt(mouth_col_index_lt-(col_lt_eye)+1)=var(col_data_2-col_data_1); 
    end
    set(0,'DefaultFigureVisible','on');
    
         counter_lt=size(p_mouth_lt,2)-1   ;
         difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);

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
         
       %% Mouth Row 
        temp=[];
        mouth_left_col_data=face_img(req_row:max_face_row,req_col_mouth_lt);
        
        mouth_right_col_data=face_img(req_row:max_face_row,req_col_mouth_rt);
        
        mouth_left_col_grad=gradient(mouth_left_col_data);
        
        mouth_right_col_grad=gradient(mouth_right_col_data);
        
        figure();
        stem(req_row:max_face_row,mouth_left_col_grad);title('LEFT COLUMN');

        
        figure();
        stem(req_row:max_face_row,mouth_right_col_grad);title('RIGHT COLUMN');
%     modified_min_row_mouth=ceil((1/4)*(max_face_row-req_row)+req_row); 
%     mouth_img=face_img(req_row:max_face_row,req_col_mouth_rt:req_col_mouth_lt);
%     the_edge_rt = edge(mouth_img);
%     figure();
%     imshow(the_edge_rt,[]);
%     figure();
%     imshow(face_img,[])
%     the_edge=the_edge_rt(1:ceil((1/3)*(size(the_edge_rt,1))),:);
%     [r,c]=find(the_edge>0);
%     req_row_mouth_start=max(r)+req_row;
%     mouth_img=face_img(req_row_mouth_start:max_face_row,req_col_mouth_rt:req_col_mouth_lt);
%     
%     for i=1:size(mouth_img,1)
%          temp(i,:)=(gradient(mouth_img(i,:)));
%          variance(i)=var(temp(i,:));
%     end
%      cropped_variance=variance(1:((3/4)*size(variance,2)));
%      thresh=0.6*max(cropped_variance);
%      local_max=(find(cropped_variance>=thresh));
%      local_max=local_max(1);
%      % [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(cropped_variance);
%      counter_rt=local_max;
%      difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
%     
%      while(difference>=0)
%          difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
%          counter_rt=counter_rt+1;
%      end
%      while(difference<=0&&counter_rt<size(cropped_variance,2))
%          difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
%          counter_rt=counter_rt+1;
%      end
%      req_row_mouth=counter_rt-1+req_row_mouth_start;
%      
%      mean_mouth_internsity=mean(face_img(req_row_mouth,req_col_mouth_rt:req_col_mouth_lt));
    
%% Mouth Row Corners
% modified_min_row_mouth=ceil((1/4)*(max_face_row-req_row)+req_row); 
% mouth_img=face_img(modified_min_row_mouth:max_face_row,req_col_mouth_rt:req_col_mouth_lt)
% I=mouth_img;
% C = corner(I);
% figure();
% imshow(face_img);
% hold on
% temp=[req_col_mouth_rt:req_col_mouth_lt];
% mouth_row_mean=mean(C(:,2)+modified_min_row_mouth);
% mouth_row_median=median(C(:,2)+modified_min_row_mouth);
% plot(temp, mouth_row_mean, 'r*');
% plot(temp, mouth_row_median, 'g*');
% plot(C(:,1)+req_col_mouth_rt,C(:,2)+modified_min_row_mouth, 'c*');
% 
% kernel1D_size=5;
% 
% for i=1:length(C)
% sum_corner_intensity=0;
%     for j=C(i,1)+req_col_mouth_rt-kernel1D_size:C(i,1)+req_col_mouth_rt-kernel1D_size
%         sum_corner_intensity=sum_corner_intensity+(face_img(C(i,2)+modified_min_row_mouth,j):face_img(C(i,2)+modified_min_row_mouth,j));
%     end
%     mean_corner_intensity(i)=sum_corner_intensity/(2*kernel1D_size+1);
% end
% row_corner=find(max(mean_corner_intensity)==mean_corner_intensity);
% plot(temp,row_corner+modified_min_row_mouth,'y*');
%%

     figure();
     imshow(face_img,[]);hold on;
%      temp=[min(c):max(c)];
%      plot(temp,req_row,'g*');
%      plot(temp,modified_min_row_nose,'y*');
%      plot(temp,req_row_mouth,'b*');
%      hold off;
%      temp=req_row_mouth_start+1:req_row_mouth_start+length(cropped_variance);
%      figure();
%      stem(temp,cropped_variance)
     temp


