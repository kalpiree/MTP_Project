function [ find_r_min_lt_index,mean_eye_brow_row_number,row_rt_plot,row_lt_plot,col_rt_plot,col_lt_plot ] = eye_detection_thermal( face_img )
%% Documentation
%
% Called by funtion: Try_Anova_New_Code.m
% Functions called in this fn: modified_min_det.m
% i/p parameters to the fn: face_img ( The input image )
% o/p parameters of the fn: find_r_min_lt_index
%                           mean_eye_brow_row_number
%                           row_rt_plot
%                           row_lt_plot
%                           col_rt_plot
%                           col_lt_plot

% Variable names:
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. number_of_splits :: Number of sampled columns on each side of the face
%                    2. offset_eye_max :: Offset to detect the maximum row for eye
%                    3. lt_eye :: Left half of the image
%                    4. rt_eye :: Right half of the image
%                    5. find_r_min_lt :: Vector containing the ending of hair pixels on the left face
%                    6. find_r_min_rt :: Vector containing the ending of hair pixels on the right face
%                    7. find_r_min_lt_index :: Variable containing the ending of hair pixels on the left face
%                    8. find_r_min_rt_index :: Variable containing the ending of hair pixels on the right face
%                    9. find_col_lt :: Vector containing the selected columns on the left face
%                   10. find_col_rt :: Vector containing the selected columns on the right face
%                   11. r_eye_lt_region_max :: r_max is computed to be 40% from the modified r_min of left half
%                   12. r_eye_rt_region_max :: r_max is computed to be 40% from the modified r_min of right half
%                   13. count_eye_lt :: Array Counter
%                   14. col_data_lt :: Row components of the sampled columns
%                   15. col_gradient_lt :: Gradient of the smapled column
%                   16. col_gradient_0_lt :: Non zero component of the gradient of the smapled column
%                   17. pks,locs,w,prominence :: findpeaks return variables to identify prominent peaks
%                   18. p_loc_lt :: Identify the location of the prominent peak of the gradient
%                   19. c_lt :: The corresponding location in the face_img
%                   20. eye_brow_row_lt :: ID the location of the eyebrow row for each column
%                   21. eye_brow_value :: The intensity of the eyebrow pixel for each column
%                   22. mean_eye_brow_row_lt :: Mean of the eye_brow points for all the sampled columns
%                   23. diff_lt :: Compute the differences of points from mean
%                   24. eye_brow_new_lt :: Eye brow points after rejecting the spurious points
%                   25. freq_lt :: Number of unique elements in the array
%                   26. eye_brow_top_lt_row :: The identified eyebrow row
%                   27. r_eye_lt_region_max :: Maximum row for eye detection
%                   28. eye_region_lt :: Image containing the eye region
%                   29. row_lt_plot :: Row component of the hotspot
%                   30. col_lt_plot :: Column component of the hotspot
%                   31. mean_row_plot :: Averaged eye row.

%% Constants
number_of_splits=5;
offset_eye_max=65;             % offset to detect the maximum row for eye
[r,c]=find(face_img>0);
cmin=min(c);
cmax=max(c);
cmid=ceil((cmax+cmin)/2);
%% Identifying eyebrows
% Working: Find the hair line pixels and the corresponding vectors. From the sampled columns, find the non zero
%                components of the gradient of each columns. Identify the most prominent peak of each column. Remove the
%                spurious points in the eye_brow_vector. This is done by computing the mean of the eyebrow points and computing
%                the difference of all other points in the vector. The unwritten assumption is that the number of spurious points
%                is less than that of the required points. Based on the difference vector, the maximum of number of +ve and -ve points
%                are computed. In the first case, the spurious points lie above the eye brow. hence reject the points causing negative
%                differences. And amongst the other points, choose the minimum. In the other case, choose the maximum. Thus the eyebrows
%                are detected. Set an offset of 65 pixels to identify the eye region. Determine the maximum in that region which points to
%                the corner of the eye.
% Left Face
[lt_eye,rt_eye,find_r_min_lt,find_r_min_rt,find_r_min_lt_index,find_r_min_rt_index,find_col_lt,find_col_rt,r_eye_lt_region_max,r_eye_rt_region_max] = modified_min_det( face_img ); % this fn is for finding the modified row which is to remove the hair and strt the row of the face from below hair. This fn also returns the search area to locate eye
count_eye_lt=1;
mean_r_eye_region_max=ceil((r_eye_lt_region_max+r_eye_rt_region_max)/2);
if mean_r_eye_region_max<(find_r_min_lt_index+50)
    temp_find_r_min_lt_index=find_r_min_lt_index; %this is just to start searching the eyes a little lower than modified min row
    temp_find_r_min_rt_index=find_r_min_rt_index;  %this is just to start searching the eyes a little lower than modified min row
else    
temp_find_r_min_lt_index=find_r_min_lt_index+50; %this is just to start searching the eyes a little lower than modified min row
temp_find_r_min_rt_index=find_r_min_rt_index+50;  %this is just to start searching the eyes a little lower than modified min row
end
for index=1:size(find_r_min_lt,2)  % why 2 didn't understand?? -- understood
    c_lt=[];
    col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt(index)-cmid); % Segment only the required region   % ideally position 2 shouldnot have error % anyways yoyu can hardcode it
    col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
    row_0=find(col_gradient_lt~=0); % ID the first non zero number
    col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.  % can i replace end?
    

    if (index==1 && isempty(col_gradient_0_lt))
        find_col_lt_modify=find_col_lt(index)-5;  % is this even correct? imagine
        while(isempty(col_gradient_0_lt))
            
            col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt_modify(index)-cmid); % Segment only the required region
            col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
            row_0=find(col_gradient_lt~=0); % ID the first non zero number
            col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.  % basically finds from first gradient
            find_col_lt_modify=find_col_lt_modify-5;   % even this??
        end
        
        
    elseif(index~=1 && isempty(col_gradient_0_lt))
        col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt(Prev_index)-cmid); % Segment only the required region  %prev_index?? should be index
        col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
        row_0=find(col_gradient_lt~=0); % ID the first non zero number
        col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
    else
        Prev_index=index;
    end
    
    
    
    [pks,locs,w,prominence]=findpeaks(col_gradient_0_lt);
    
    
    p_loc_lt=find(max(prominence)==prominence,1);
    c_lt=min(locs(p_loc_lt)); % min location of max prominience
    eye_brow_row_lt(count_eye_lt)=c_lt;
    eye_brow_row_lt(count_eye_lt)= eye_brow_row_lt(count_eye_lt)+temp_find_r_min_lt_index; % Compute the Offset
    eye_brow_value(count_eye_lt)=lt_eye(eye_brow_row_lt(count_eye_lt),find_col_lt(index)-cmid); % The corresponding intensity
    count_eye_lt=count_eye_lt+1; % Updating the array
end
% Removing Spurious EyeBrow_row points
mean_eye_brow_row_lt=floor(mean(eye_brow_row_lt(1:number_of_splits))); %Compute the mean of the obtained rows
% Compute the differences from mean
for ide=1:number_of_splits
    diff_lt(ide)=eye_brow_row_lt(ide)-mean_eye_brow_row_lt;
end
eye_brow_new_lt=[];
repetition_count_lt=0; % Keep track of repititions while deleting
row_P_lt=find(diff_lt>0); % ID the number of positive differences

if size(row_P_lt,2)>(number_of_splits-size(row_P_lt,2)) % If true, Negative differences are the Spurious Points ( to be deleted )
    row_N_lt=find(diff_lt<=0); % ID the number of negative differences
    freq_lt=unique(diff_lt(row_N_lt)); % ID the unique elements amongst the negative differences that are to be deleted
    eye_brow_new_lt=eye_brow_row_lt;
    for ind=1:size(freq_lt,2)
        eye_brow_new_lt = eye_brow_new_lt(eye_brow_new_lt~=eye_brow_new_lt(row_N_lt(ind)-repetition_count_lt)); % Delete the Spurious Points
        if(ind>0)
            repetition_count_lt=1; % To traverse to correct element in row_N_lt after deletion
        end
    end
    eye_brow_top_lt_row=min(eye_brow_new_lt); % Minimum of the true points gives eye brow row
    
else                                                  % If true, Positive differences are the Spurious Points ( to be deleted )
    eye_brow_new_lt=eye_brow_row_lt;
    freq_lt=unique(diff_lt(row_P_lt));% ID the unique elements amongst the positive differences that are to be deleted
    for ind=1:(size(freq_lt,2))
        eye_brow_new_lt = eye_brow_new_lt(eye_brow_new_lt~=eye_brow_new_lt(row_P_lt(ind)-repetition_count_lt));  % Delete the Spurious Points
        if(ind>0)
            repetition_count_lt=1;% To traverse to correct element in row_P_lt after deletion
        end
    end
    eye_brow_top_lt_row=max(eye_brow_new_lt); % Maximum of the true points gives eye brow row
    
end
% Right Face
count_eye_rt=1;
for index=1:size(find_r_min_rt,2)
    c_rt=[];
    col_data_rt=rt_eye(temp_find_r_min_rt_index:mean_r_eye_region_max,find_col_rt(index)-cmin); % Segment only the required region
    col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
    row_0=find(col_gradient_rt~=0);% ID the first non zero number
    col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
    if (index==1 && isempty(col_gradient_0_rt))
        while(isempty(col_gradient_0_rt))
            find_col_rt_modify=find_col_rt(index)+5;
            col_data_rt=rt_eye(temp_find_r_min_rt_index:mean_r_eye_region_max,find_col_rt_modify(index)-cmin); % Segment only the required region
            col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
            row_0=find(col_gradient_rt~=0);% ID the first non zero number
            col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
        end
    elseif(index~=1 && isempty(col_gradient_0_rt))
        col_data_rt=rt_eye(temp_find_r_min_rt_index:mean_r_eye_region_max,find_col_rt(Prev_index)-cmin); % Segment only the required region
        col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
        row_0=find(col_gradient_rt~=0);% ID the first non zero number
        col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
    else
        Prev_index=index;
    end
    
    
    
    [pks,locs,w,prominence]=findpeaks(col_gradient_0_rt);
    p_loc_rt=find(max(prominence)==prominence,1);
    c_rt=locs(p_loc_rt);
    eye_brow_row_rt(count_eye_rt)=c_rt;
    eye_brow_row_rt(count_eye_rt)= eye_brow_row_rt(count_eye_rt)+temp_find_r_min_rt_index;% Compute the Offset
    eye_brow_value_rt(count_eye_rt)=rt_eye(eye_brow_row_rt(count_eye_rt),find_col_rt(index)-cmin);% The corresponding intensity
    count_eye_rt=count_eye_rt+1; % Update the array
end
% Removing Spurious EyeBrow_row points
mean_eye_brow_row_rt=floor(mean(eye_brow_row_rt(1:number_of_splits)));
% Compute the differences from mean
for ide=1:number_of_splits
    diff_rt(ide)=eye_brow_row_rt(ide)-mean_eye_brow_row_rt;
end

eye_brow_new_rt=[];
row_P_rt=find(diff_rt>0);  % ID the number of positive differences
repetition_count_rt=0; % Keep track of repititions while deleting

if size(row_P_rt,2)>(number_of_splits-size(row_P_rt,2))  % If true, Negative differences are the Spurious Points ( to be deleted )
    row_N_rt=find(diff_rt<=0); % ID the number of negative differences
    freq_rt=unique(diff_rt(row_N_rt)); % ID the unique elements amongst the negative differences that are to be deleted
    eye_brow_new_rt=eye_brow_row_rt;
    for ind=1:size(freq_rt,2)
        eye_brow_new_rt = eye_brow_new_rt(eye_brow_new_rt~=eye_brow_new_rt(row_N_rt(ind)-repetition_count_rt));  % Delete the Spurious Points
        if(ind>0)
            repetition_count_rt=1;  % To traverse to correct element in row_N_lt after deletion
        end
    end
    eye_brow_top_rt_row=min(eye_brow_new_rt); % Minimum of the true points gives eye brow row
else
    freq_rt=unique(diff_rt(row_P_rt)); % ID the unique elements amongst the positive differences that are to be deleted
    eye_brow_new_rt=eye_brow_row_rt;
    for ind=1:size(freq_rt,2)
        eye_brow_new_rt = eye_brow_new_rt(eye_brow_new_rt~=eye_brow_new_rt(row_P_rt(ind)-repetition_count_rt)); % Delete the Spurious Points
        if(ind>0)
            repetition_count_rt=1; % To traverse to correct element in row_N_lt after deletion
        end
    end
    eye_brow_top_rt_row=max(eye_brow_new_rt); % Maximum of the true points gives eye brow row
end

% Select the Eye Region from eyebrows to the pre defined offset
mean_eye_brow_row_number=ceil((eye_brow_top_lt_row+eye_brow_top_rt_row)/2);
r_eye_rt_region_max=mean_eye_brow_row_number+offset_eye_max;
eye_region_rt=rt_eye(mean_eye_brow_row_number:r_eye_rt_region_max,find_col_rt(number_of_splits)-cmin:cmid-cmin);  % Final Right eye Segmented Image.

% Select the Eye Region from eyebrows to the pre defined offset
r_eye_lt_region_max=mean_eye_brow_row_number+offset_eye_max;
eye_region_lt=lt_eye(mean_eye_brow_row_number:r_eye_lt_region_max,1:find_col_lt(number_of_splits)-cmid); % Final Left eye Segmented Image.

%% Finding Eye Hotspots
% ID the hotspots in each of the segmented images
rt_max=sort(eye_region_rt(:),'descend');
rt_max=rt_max(1);
[rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
lt_max=sort(eye_region_lt(:),'descend');
lt_max=lt_max(1);
[lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);

% Compute the offsets
row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
col_rt_plot=min(rt_max_c+find_col_rt(number_of_splits));
col_lt_plot=min(lt_max_c+cmid);

% In order to prevent spurious identification, we perform this check
% check difference between cols. of rt and lt eye. If difference is
% less then threshold that means the lt and rt eye detected pts
% overlaped then consider finding the second maximum pt
idx_lt=2;
idx_rt=2;
diff_col_rtandlt_eye= abs(col_lt_plot-col_rt_plot);
while (diff_col_rtandlt_eye < 40)
    if (col_lt_plot<col_rt_plot | col_lt_plot==col_rt_plot )
        rt_max=sort(eye_region_rt(:),'descend');
        rt_max=rt_max(1);
        [rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
        lt_max=sort(eye_region_lt(:),'descend');
        lt_max=lt_max(idx_lt);
        idx_lt=idx_lt+1;
        [lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);
        
        % Compute the offsets
        row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
        row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
        col_rt_plot=min(rt_max_c+find_col_rt(number_of_splits));
        col_lt_plot=min(lt_max_c+cmid);
    end
    if (col_rt_plot<col_lt_plot)
        rt_max=sort(eye_region_rt(:),'descend');
        rt_max=rt_max(idx_rt);
        idx_rt=idx_rt+1;
        [rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
        lt_max=sort(eye_region_lt(:),'descend');
        lt_max=lt_max(1);
        [lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);
        
        % Compute the offsets
        row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
        row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
        col_rt_plot=min(rt_max_c+find_col_rt(number_of_splits));
        col_lt_plot=min(lt_max_c+cmid);
    end
    diff_col_rtandlt_eye= abs(col_lt_plot-col_rt_plot);
end


% Aligning the rows

mean_row_plot=ceil((row_rt_plot+row_lt_plot)/2);
row_rt_plot=mean_row_plot;
row_lt_plot=mean_row_plot;
end