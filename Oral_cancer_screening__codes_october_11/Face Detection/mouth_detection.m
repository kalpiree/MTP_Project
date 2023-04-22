function [ req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose ] =mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row)
%% Documentation
% % Functions called in this fn: Nil
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
    
    req_dist=cmax-cmin; %req_dist is the width of the face 
    max_face_row=modified_r_min+req_dist; %req_dist added to modified_r_min(row from below the hair) gives height of the face
    if(max_face_row > rmax)
        max_face_row=rmax;
    end
    min_row=row_lt_eye; %row_lt_eye is the row component of the hotspot
    cmid=ceil((cmin+cmax)/2);
    modified_min_row_nose=ceil((1/4)*(max_face_row-min_row)+min_row); % search area for nose
 
    temp=[];
    nose_img=face_img(modified_min_row_nose:max_face_row,col_rt_eye:col_lt_eye); % Nose Image with the above boundaries

    % Determination of the row (req_row) between the nose and mouth
    % Compute the Row-wise variance along the Nose Image
    for i=1:size(nose_img,1)
         temp(i,:)=(gradient(nose_img(i,:)));
         variance(i)=var(temp(i,:));
    end
     
    cropped_variance= variance(1:floor((3/4)*size(variance,2))); % Exclude the later 25% of the search region, to avoid the mid-mouth region
    thresh=0.6*max(cropped_variance); % Threshold to be checked for.
    local_max=find(cropped_variance>=thresh);  % Identification of the first point that crosses the threshold.
    local_max=local_max(1);
    counter_rt=local_max; % This point marks the beginning of our search region, where we want to find the local minimum which is the req_row.
    difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);

    % This first loop is to traverse through the variance vector and identify the next immediate peak
    % Once there is a peak, then we move ont o identify the corresponding
    % valley right after it. When the initial difference, is negative, it
    % means, the first loop wont get executed, and the valley is directly
    % obtained throught the second loop.
    
    
     while(difference>=0)
         difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
         counter_rt=counter_rt+1;
     end
     while(difference<=0&&counter_rt<size(cropped_variance,2))
         difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
         counter_rt=counter_rt+1;
     end
     
     req_row=counter_rt-1+modified_min_row_nose; % Adding the required offset.

     window_size=21; % Window Size defined for setting a mouth region.
%%     
     set(0,'DefaultFigureVisible','off'); % Turn off Plotting Figures
%     Right Mouth Column 
     p_mouth_rt=[];
    % In order to identify the columns, we tranverse through the window
    % size from the column coordinates of eye canthus, and apply Analysis
    % of Variance for each successive pair fo columns.
    for mouth_col_index_rt=(col_rt_eye-window_size):col_rt_eye
         col_data_1=face_img(req_row:rmax,mouth_col_index_rt);
         col_data_2=face_img(req_row:rmax,mouth_col_index_rt+1);
         y_mouth_rt=[col_data_1 col_data_2]; % Succesive Columns of Interest
         p_mouth_rt(mouth_col_index_rt-(col_rt_eye-window_size)+1)=anova1(y_mouth_rt); % Perform one way ANOVA for the above columns.
    end
    set(0,'DefaultFigureVisible','on'); % Turn on Plotting Figures
         
         counter_rt=1;
         % In order to find the Columns, we have to find the first valley
         % in the 'p' vector. This is done using two loops, the first one
         % to crossover a apeak, if any and the second to traverse until
         % the valley point is obtained.
         difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt); % Difference vector used to identify the inc. or dec. trend of the graph 

         while(difference_mouth_rt>=0&&counter_rt<size(p_mouth_rt,2))
             difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);
             counter_rt=counter_rt+1;
         end
         while(difference_mouth_rt<=0&&counter_rt<size(p_mouth_rt,2))
             difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);
             counter_rt=counter_rt+1;
         end
         req_col_mouth_rt=counter_rt-1+(col_rt_eye-window_size); % Computing the effective index, by adding the offset.

         
         %% Left Mouth Column
         set(0,'DefaultFigureVisible','off');% Turn off Plotting Figures
    p_mouth_lt=[];
    for mouth_col_index_lt=col_lt_eye:(col_lt_eye+window_size)
         col_data_1=face_img(req_row:rmax,mouth_col_index_lt);
         col_data_2=face_img(req_row:rmax,mouth_col_index_lt+1);
         y_mouth_lt=[col_data_1 col_data_2];
         p_mouth_lt(mouth_col_index_lt-(col_lt_eye)+1)=anova1(y_mouth_lt); 
    end
    set(0,'DefaultFigureVisible','on');
         % In order to find the Columns, we have to find the first valley
         % in the 'p' vector. This is done using two loops, the first one
         % to crossover a apeak, if any and the second to traverse until
         % the valley point is obtained.
         counter_lt=size(p_mouth_lt,2)-1   ;
         difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);% Difference vector used to identify the inc. or dec. trend of the graph 

         while(difference_mouth_lt<=0&&counter_lt<size(p_mouth_lt,2))
             difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);
             counter_lt=counter_lt-1;
         end
         while(difference_mouth_lt>=0&&counter_lt<size(p_mouth_lt,2))
             difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);
             counter_lt=counter_lt-1;
         end
         counter_lt=counter_lt-1;
         req_col_mouth_lt=counter_lt-1+col_lt_eye; % Computing the effective index, by adding the offset.