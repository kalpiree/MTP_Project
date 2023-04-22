i = imread("C:\Users\ntnbs\Downloads\sample_og.jpg");
[face_img,mask_F,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row] = front_face_detect( i);
imshow(face_img)
imsave
%% Constants
number_of_splits=5;
offset_eye_max=65;             % offset to detect the maximum row for eye
[r,c]=find(face_img>0);
cmin=min(c);
cmax=max(c);
cmid=ceil((cmax+cmin)/2);
%% Left Face
[lt_eye,rt_eye,find_r_min_lt,find_r_min_rt,find_r_min_lt_index,find_r_min_rt_index,find_col_lt,find_col_rt,r_eye_lt_region_max,r_eye_rt_region_max] = modified_min_det_for_eye( face_img ); % this fn is for finding the modified row which is to remove the hair and strt the row of the face from below hair. This fn also returns the search area to locate eye

count_eye_lt=1;
mean_r_eye_region_max=ceil((r_eye_lt_region_max+r_eye_rt_region_max)/2);
if mean_r_eye_region_max<(find_r_min_lt_index+50)
    temp_find_r_min_lt_index=find_r_min_lt_index; %this is just to start searching the eyes a little lower than modified min row
    temp_find_r_min_rt_index=find_r_min_rt_index;  %this is just to start searching the eyes a little lower than modified min row
else    
temp_find_r_min_lt_index=find_r_min_lt_index+50; %this is just to start searching the eyes a little lower than modified min row
temp_find_r_min_rt_index=find_r_min_rt_index+50;  %this is just to start searching the eyes a little lower than modified min row
end
for index=1:size(find_r_min_lt,2)
    c_lt=[];
    col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,abs(find_col_lt(index)-cmid)); % Segment only the required region   % code modified
    %col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,cmid-find_col_lt(index))
    col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
    row_0=find(col_gradient_lt~=0); % ID the first non zero number
    col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
    

    if (index==1 && isempty(col_gradient_0_lt))
        find_col_lt_modify=find_col_lt(index)-5; %tried to modify
        while(isempty(col_gradient_0_lt))
            
            col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,abs(find_col_lt_modify(index)-cmid)+1); % Segment only the required region %code edited
            col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
            row_0=find(col_gradient_lt~=0); % ID the first non zero number
            col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
            find_col_lt_modify=find_col_lt_modify-5;
        end
        
        
    else if(index~=1 && isempty(col_gradient_0_lt))
        col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt(index)-cmid); % Segment only the required region
        col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
        row_0=find(col_gradient_lt~=0); % ID the first non zero number
        col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
     end
    %else
        %Prev_index=index;
    end
    
    
    
    [pks,locs,w,prominence]=findpeaks(col_gradient_0_lt);
    
    
    p_loc_lt=find(max(prominence)==prominence,1);
    c_lt=min(locs(p_loc_lt));
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
%% Right Face
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