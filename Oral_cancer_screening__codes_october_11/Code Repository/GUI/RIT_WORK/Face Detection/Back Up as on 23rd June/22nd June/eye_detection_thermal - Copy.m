function [ find_r_min_lt_index,mean_eye_brow_row_number,row_rt_plot,row_lt_plot,col_rt_plot,col_lt_plot ] = eye_detection_thermal( face_img )
%%   Processing the face detected image
%    figure,imshow(face_img);
     [row,col]=find (face_img>0);
     rmin=min(row);
     cmin=min(col);
     rmax=max(row);
     cmax=max(col);
     
%      rmid=ceil((rmax+rmin)/2);
%      col_value=cmin;
%      while(face_img(rmid,col_value)==0)
%          col_value=col_value+1;
%      end
%      cmin=col_value;
%      col_value=cmax;
%      while(face_img(rmid,col_value)==0)
%          col_value=col_value-1;
%      end
%      cmax=col_value;


     cmid=ceil((cmax+cmin)/2);
     
     % cmid modification
     reduced_face_img=face_img(rmin:((1/3)*(rmax-rmin)+rmin),:);
     [red_r,red_c]=find(reduced_face_img>0);
     reduced_cmin=min(red_c);
     reduced_cmax=max(red_c);
     
     cmid=ceil((reduced_cmin+reduced_cmax)/2);
     % Selecting the Columns for Processing each half image

     number_of_splits=5;            % Number of columns on either side of the face
     offset_eye_max=65;             % offset to detect the maximum row for eye
     th_rmin=0.75;                  % Threshold is set for removal of hair
     
     c_lt_1=face_img(:,cmid+40);
     c_lt_2=face_img(:,cmid+45);
     c_lt_3=face_img(:,cmid+50);
     c_lt_4=face_img(:,cmid+55);
     c_lt_5=face_img(:,cmid+60);
     
     c_rt_1=face_img(:,cmid-40);
     c_rt_2=face_img(:,cmid-45);
     c_rt_3=face_img(:,cmid-50);
     c_rt_4=face_img(:,cmid-55);
     c_rt_5=face_img(:,cmid-60);
     
     %Splitting the image into two halfs
     
     rt_eye=face_img(:,(cmin:cmid));        % Right Part of Face
     lt_eye=face_img(:,((cmid+1):cmax));    % Left Part of Face
     
%%   Determining the modified r_min 

    % For Left Face
     
     find_c1_lt=find(c_lt_1>th_rmin);
     if isempty(find_c1_lt)==isempty([])
        find_c1_lt=rmin;
     end   
     find_c1_lt=find_c1_lt(1);
     find_c2_lt=find(c_lt_2>th_rmin);
     if isempty(find_c2_lt)==isempty([])
        find_c2_lt=find_c1_lt;
     end 
     find_c2_lt=find_c2_lt(1);
     find_c3_lt=find(c_lt_3>th_rmin);
     if isempty(find_c3_lt)==isempty([])
       find_c3_lt=find_c2_lt;
     end
     find_c3_lt=find_c3_lt(1);
     find_c4_lt=find(c_lt_4>th_rmin);
     if isempty(find_c4_lt)==isempty([])
       find_c4_lt=find_c3_lt;
     end
     find_c4_lt=find_c4_lt(1);
     find_c5_lt=find(c_lt_5>th_rmin);
     if isempty(find_c3_lt)==isempty([])
       find_c5_lt=find_c5_lt;
     end
     find_c5_lt=find_c5_lt(1);
     find_c1_rt=find(c_rt_1>th_rmin);
     if isempty(find_c1_rt)==isempty([])
        find_c1_rt=rmin;
     end
     
     % Right Face
     
     find_c1_rt=find_c1_rt(1);
     find_c2_rt=find(c_rt_2>th_rmin);
     if isempty(find_c2_rt)==isempty([])
        find_c2_rt=find_c1_rt;
     end 
     find_c2_rt=find_c2_rt(1);
     find_c3_rt=find(c_rt_3>th_rmin);
     if isempty(find_c3_rt)==isempty([])
       find_c3_rt=find_c2_rt;
     end
     find_c3_rt=find_c3_rt(1);
     find_c4_rt=find(c_rt_4>th_rmin);
     if isempty(find_c4_rt)==isempty([])
       find_c4_rt=find_c3_rt;
     end
     find_c4_rt=find_c4_rt(1);
     find_c5_rt=find(c_rt_5>th_rmin);
     if isempty(find_c3_rt)==isempty([])
       find_c5_rt=find_c5_rt;
     end
     find_c5_rt=find_c5_rt(1);
     
     % Determined Columns for Left Face
     
     col1=cmid+40;
     col2=cmid+45;
     col3=cmid+50;
     col4=cmid+55;
     col5=cmid+60;
     find_col_lt=[col1 col2 col3 col4 col5];
     
     % Determined Columns for Right Face
      
     col1=cmid-40;
     col2=cmid-45;
     col3=cmid-50;
     col4=cmid-55;
     col5=cmid-60;
     find_col_rt=[col1 col2 col3 col4 col5];
      
     % Modified r_min is computed for each half of the face separately by
     % identifying the maximum from the set of points satisfying the
     % threshold
     
     find_r_min_lt=[find_c1_lt find_c2_lt find_c3_lt find_c4_lt find_c5_lt ];
     
     find_r_min_rt=[find_c1_rt find_c2_rt find_c3_rt find_c4_rt find_c5_rt ];
      
     find_r_min_lt_index=max(find_r_min_lt);
     temp_find_r_min_lt_index=find_r_min_lt_index+20;
     
     find_r_min_rt_index=max(find_r_min_rt);
     temp_find_r_min_rt_index=find_r_min_rt_index+20;
     
     % r_max is computed to be 40% from the modified r_min of each half
     
     r_eye_lt_region_max=ceil((rmax-find_r_min_lt_index)*(1/2.5))+find_r_min_lt_index;
      
     r_eye_rt_region_max=ceil((rmax-find_r_min_rt_index)*(1/2.5))+find_r_min_rt_index;
      %% Identifying Eyebrows
      
      % Left Face 
      
      count_eye_lt=1;
      figure();
      imshow(face_img);title('Required Image');
      hold on;
      for index=1:size(find_r_min_lt,2)
          c_lt=[];
          col_data_lt=lt_eye(temp_find_r_min_lt_index:r_eye_lt_region_max,find_col_lt(index)-cmid); % Segment only the required region
          col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
          row_0=find(col_gradient_lt~=0); % ID the first non zero number
          col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
          [pks,locs,w,prominence]=findpeaks(col_gradient_0_lt);
          p_loc_lt=find(max(prominence)==prominence);
          c_lt=min(locs(p_loc_lt));
          %col_gradient_0_lt=imboxfilt(col_gradient_0_lt,21); % Smoothen the signal using boxfilt
          %th_lt=max(col_gradient_0_lt); % Set the threshold for determing the peak
          %c_lt=find(col_gradient_0_lt>=th_lt); % ID the first element which satisfies the condition
          eye_brow_row_lt(count_eye_lt)=c_lt;
          eye_brow_row_lt(count_eye_lt)= eye_brow_row_lt(count_eye_lt)+temp_find_r_min_lt_index; % Compute the Offset
          eye_brow_value(count_eye_lt)=lt_eye(eye_brow_row_lt(count_eye_lt),find_col_lt(index)-cmid); % The corresponding intensity 
          plot(find_col_lt(index),eye_brow_row_lt(count_eye_lt),'c*');
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
      
      % Select the Eye Region from eyebrows to 50 more pixels
      r_eye_lt_region_max=eye_brow_top_lt_row+offset_eye_max;
      eye_region_lt=lt_eye(eye_brow_top_lt_row:r_eye_lt_region_max,:); % Final Left eye Segmented Image.
     
      % Right Face
      
      count_eye_rt=1;
      for index=1:size(find_r_min_rt,2)
          c_rt=[];
          col_data_rt=rt_eye(temp_find_r_min_rt_index:r_eye_rt_region_max,find_col_rt(index)-cmin); % Segment only the required region
          col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
          row_0=find(col_gradient_rt~=0);% ID the first non zero number
          col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
          [pks,locs,w,prominence]=findpeaks(col_gradient_0_rt);
          p_loc_rt=find(max(prominence)==prominence);
          c_rt=locs(p_loc_rt)
          %col_gradient_0_rt=imboxfilt(col_gradient_0_rt,21);% Smoothen the signal using boxfilt
          %th_rt=max(col_gradient_0_rt);% Set the threshold for determing the peak
          %c_rt=find(col_gradient_0_rt>=th_rt);% ID the first element which satisfies the condition
          eye_brow_row_rt(count_eye_rt)=c_rt;
          eye_brow_row_rt(count_eye_rt)= eye_brow_row_rt(count_eye_rt)+temp_find_r_min_rt_index;% Compute the Offset
          eye_brow_value_rt(count_eye_rt)=rt_eye(eye_brow_row_rt(count_eye_rt),find_col_rt(index)-cmin);% The corresponding intensity 
          plot(find_col_rt(index),eye_brow_row_rt(count_eye_rt),'c*');
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
      
      % Select the Eye Region from eyebrows to 50 more pixels
      hold off;
      r_eye_rt_region_max=eye_brow_top_rt_row+offset_eye_max;
      eye_region_rt=rt_eye(eye_brow_top_rt_row:r_eye_rt_region_max,:);  % Final Right eye Segmented Image.
     
      mean_eye_brow_row_number=ceil((eye_brow_top_lt_row+eye_brow_top_rt_row)/2);
      %% Finding Eye Hotspots 
      
      figure();
      imshow(eye_region_rt);
      figure();
      imshow(eye_region_lt);
      % ID the hotspots in each of the segmented images 
      rt_max=max(eye_region_rt(:));
      [rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
      lt_max=max(eye_region_lt(:));
      [lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);
     
      % Compute the offsets
      row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
      row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
      col_rt_plot=min(rt_max_c+cmin);
      col_lt_plot=min(lt_max_c+cmid); 
      
      % Aligning the rows
      mean_row_plot=ceil((row_rt_plot+row_lt_plot)/2);
      row_rt_plot=mean_row_plot;
      row_lt_plot=mean_row_plot;
end

