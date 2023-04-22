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
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     [BW_mask_F,mask_F]=(face_detect( I_F ));
     I_F=mat2gray(I_F);
     face_img=(I_F).*double(BW_mask_F);
%    face_img=adapthisteq(face_img);
%%   Processing the face detected image
%    figure,imshow(face_img);
     [row,col]=find (face_img>0);
     rmin=min(row);
     cmin=min(col);
     rmax=max(row);
     cmax=max(col);
     
     rmid=ceil((rmax-rmin)/2);
     col_value=cmin;
     while(face_img(rmid,col_value)==0)
         col_value=col_value+1;
     end
     cmin=col_value;
     col_value=cmax;
     while(face_img(rmid,col_value)==0)
         col_value=col_value-1;
     end
     cmax=col_value;


     cmid=ceil((cmax+cmin)/2);
     
     % Selecting the Columns for Processing each half image

     number_of_splits=5;            % Number of columns on either side of the face
     offset_eye_max=65;             % offset to detect the maximum row for eye
     
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
     
     find_c1_lt=find(c_lt_1>0.75);
     if isempty(find_c1_lt)==isempty([])
        find_c1_lt=rmin;
     end   
     find_c1_lt=find_c1_lt(1);
     find_c2_lt=find(c_lt_2>0.75);
     if isempty(find_c2_lt)==isempty([])
        find_c2_lt=find_c1_lt;
     end 
     find_c2_lt=find_c2_lt(1);
     find_c3_lt=find(c_lt_3>0.75);
     if isempty(find_c3_lt)==isempty([])
       find_c3_lt=find_c2_lt;
     end
     find_c3_lt=find_c3_lt(1);
     find_c4_lt=find(c_lt_4>0.75);
     if isempty(find_c4_lt)==isempty([])
       find_c4_lt=find_c3_lt;
     end
     find_c4_lt=find_c4_lt(1);
     find_c5_lt=find(c_lt_5>0.75);
     if isempty(find_c3_lt)==isempty([])
       find_c5_lt=find_c5_lt;
     end
     find_c5_lt=find_c5_lt(1);
     find_c1_rt=find(c_rt_1>0.75);
     if isempty(find_c1_rt)==isempty([])
        find_c1_rt=rmin;
     end
     
     % Right Face
     
     find_c1_rt=find_c1_rt(1);
     find_c2_rt=find(c_rt_2>0.75);
     if isempty(find_c2_rt)==isempty([])
        find_c2_rt=find_c1_rt;
     end 
     find_c2_rt=find_c2_rt(1);
     find_c3_rt=find(c_rt_3>0.75);
     if isempty(find_c3_rt)==isempty([])
       find_c3_rt=find_c2_rt;
     end
     find_c3_rt=find_c3_rt(1);
     find_c4_rt=find(c_rt_4>0.75);
     if isempty(find_c4_rt)==isempty([])
       find_c4_rt=find_c3_rt;
     end
     find_c4_rt=find_c4_rt(1);
     find_c5_rt=find(c_rt_5>0.75);
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
     
     find_r_min_rt_index=max(find_r_min_rt);
     
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
          col_data_lt=lt_eye(find_r_min_lt_index:r_eye_lt_region_max,find_col_lt(index)-cmid); % Segment only the required region
          col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
          row_0=find(col_gradient_lt~=0); % ID the first non zero number
          col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
          col_gradient_0_lt=imboxfilt(col_gradient_0_lt,21); % Smoothen the signal using boxfilt
          th_lt=(0.75).*min(col_gradient_0_lt); % Set the threshold for determing the peak
          c_lt=find(col_gradient_0_lt<th_lt); % ID the first element which satisfies the condition
          eye_brow_row_lt(count_eye_lt)=c_lt(1);
          eye_brow_row_lt(count_eye_lt)= eye_brow_row_lt(count_eye_lt)+min(row_0)+find_r_min_lt_index; % Compute the Offset
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
          col_data_rt=rt_eye(find_r_min_rt_index:r_eye_rt_region_max,find_col_rt(index)-cmin); % Segment only the required region
          col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
          row_0=find(col_gradient_rt~=0);% ID the first non zero number
          col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
          col_gradient_0_rt=imboxfilt(col_gradient_0_rt,21);% Smoothen the signal using boxfilt
          th_rt=(0.75).*min(col_gradient_0_rt);% Set the threshold for determing the peak
          c_rt=find(col_gradient_0_rt<th_rt);% ID the first element which satisfies the condition
          eye_brow_row_rt(count_eye_rt)=c_rt(1);
          eye_brow_row_rt(count_eye_rt)= eye_brow_row_rt(count_eye_rt)+min(row_0)+find_r_min_rt_index;% Compute the Offset
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
      figure();
      imshow(face_img);
      hold on;
      % Compute the offsets
      row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
      row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
      col_rt_plot=min(rt_max_c+cmin);
      col_lt_plot=min(lt_max_c+cmid);
      plot(col_rt_plot,row_rt_plot,'c*');
      plot(col_lt_plot,row_lt_plot,'c*');
      % Plotting the bounding box around the eye
      rectangle('Position', [ col_rt_plot-70,row_rt_plot-20, 70, 40],...
        'EdgeColor','r', 'LineWidth', 3)
      rectangle('Position', [ col_lt_plot,row_lt_plot-20, 70, 40],...
        'EdgeColor','r', 'LineWidth', 3)
    
%% Determining the colums Boundary

col_data_lt=lt_eye(eye_brow_top_lt_row:eye_brow_top_lt_row+50,:);
mod_lt_eye=col_data_lt.*(col_data_lt>0.5);
[r,c]=find(mod_lt_eye>0);
mod_cmax_lt=max(c);
mod_cmin_lt=min(c);
mod_cmid_lt=(mod_cmax_lt+mod_cmin_lt)/2;
for i=1:size(mod_lt_eye,2)
Ph_n(i)=sum(mod_lt_eye(:,i));
end
Fx=gradient(Ph_n(1:size(Ph_n,2)-2));
th=(0.5).*Fx(floor(mod_cmid_lt)+1);
Fx1=Fx(size(Fx,2)-1:-1:1);
% figure();
% imshow(mod_lt_eye);
% figure();
% plot(Fx1)
r=find(Fx1>th);
r=mod_cmax_lt-r;
r(1)

end