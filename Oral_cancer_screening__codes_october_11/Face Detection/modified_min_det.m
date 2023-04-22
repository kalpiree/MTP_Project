function [ lt_eye,rt_eye,find_r_min_lt,find_r_min_rt,find_r_min_lt_index,find_r_min_rt_index,find_col_lt,find_col_rt,r_eye_lt_region_max,r_eye_rt_region_max] = modified_min_det( face_img )
%% Documentation
% modified_min_det:-
% Called by funtion          : face_detect.m
% Functions called in this fn: Nil
% i/p parameters to the fn   : face_img ( The input image )
% o/p parameters of the fn   : mean_find_r_min_index ( modified_r_min )
%                              
% Variable names: 
%                    1. reduced_face_img :: First 30% of the face_img
%                    2. red_r :: Vector consisting of rows of Non Zeroes pixels
%                    3. red_c :: Vector consisting of rows of Non Zeroes pixels  
%                    4. reduced_cmin :: Minimum of the red_c vector
%                    5. reduced_cmax :: Maximum of the red_c vector
%                    6. number_of_splits :: Number of column selections on either sides                  
%                    7. offset_eye_max :: Offset to detect the maximum row for eye
%                    8. th_rmin :: Threshold for segmenting hair pixels 
%                    9. c_lt_1 :: Contains data of sampled columns of left face                     
%                   10. c_rt_1 :: Contains data of sampled columns of right face  
%                   11. rt_eye :: Right half of the image
%                   12. lt_eye :: Left half of the image
%                   13. find_c1_rt :: The point satisfying the threshold in a particular column in the right face
%                   14. find_c1_lt :: The point satisfying the threshold in a particular column in the right face
%                   15. find_col_lt :: Vector containing the selected columns on the right face
%                   16. find_col_rt :: Vector containing the selected columns on the left face
%                   17. find_r_min_lt :: Vector containing the ending of hair pixels on the right face
%                   18. find_r_min_rt ::  Vector containing the ending of hair pixels on the right face
%                   19. r_eye_lt_region_max :: r_max is computed to be 40% from the modified r_min of each half
%                   20. r_eye_rt_region_max :: r_max is computed to be 40% from the modified r_min of each half
%                   21. mean_find_r_min_index :: modified_r_min-Avoiding the hair pixels
%% Finding the modified_r_min
     [row,col]=find (face_img>0);
     rmin=min(row);
     cmin=min(col);
     rmax=max(row);
     cmax=max(col);
 
     cmid=ceil((cmax+cmin)/2);
     
     % cmid modification
     reduced_face_img=face_img(rmin:floor((1/3)*(rmax-rmin)+rmin),:);
     [reduce_r,reduce_c]=find(reduced_face_img>0);
     reduced_cmin=min(reduce_c);
     reduced_cmax=max(reduce_c);
     
     % Selecting the Columns for Processing each half image

     number_of_splits=5;            % Number of columns on either side of the face
    
     th_rmin=0.65;                  % Threshold is set for removal of hair
     
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
     %
     find_c2_lt=find(c_lt_2>th_rmin);
     if isempty(find_c2_lt)==isempty([])
        find_c2_lt=find_c1_lt;
     end 
     find_c2_lt=find_c2_lt(1);
     %
     find_c3_lt=find(c_lt_3>th_rmin);
     if isempty(find_c3_lt)==isempty([])
       find_c3_lt=find_c2_lt;
     end
     find_c3_lt=find_c3_lt(1);
     %
     find_c4_lt=find(c_lt_4>th_rmin);
     if isempty(find_c4_lt)==isempty([])
       find_c4_lt=find_c3_lt;
     end
     find_c4_lt=find_c4_lt(1);
     %
     find_c5_lt=find(c_lt_5>th_rmin);
     if isempty(find_c5_lt)==isempty([])
       find_c5_lt=find_c4_lt;
     end
     find_c5_lt=find_c5_lt(1);
     
      % Right Face
     find_c1_rt=find(c_rt_1>th_rmin);
     if isempty(find_c1_rt)==isempty([])
        find_c1_rt=rmin;
     end
     find_c1_rt=find_c1_rt(1);
     %
     find_c2_rt=find(c_rt_2>th_rmin);
     if isempty(find_c2_rt)==isempty([])
        find_c2_rt=find_c1_rt;
     end 
     find_c2_rt=find_c2_rt(1);
     %
     find_c3_rt=find(c_rt_3>th_rmin);
     if isempty(find_c3_rt)==isempty([])
       find_c3_rt=find_c2_rt;
     end
     find_c3_rt=find_c3_rt(1);
     %
     find_c4_rt=find(c_rt_4>th_rmin);
     if isempty(find_c4_rt)==isempty([])
       find_c4_rt=find_c3_rt;
     end
     find_c4_rt=find_c4_rt(1);
     %
     find_c5_rt=find(c_rt_5>th_rmin);
     if isempty(find_c5_rt)==isempty([])
       find_c5_rt=find_c4_rt;
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

     mean_find_r_min_index=ceil((find_r_min_lt_index+find_r_min_rt_index)/2);
end

