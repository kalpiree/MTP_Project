function [ mean_find_r_min_lt_index] = modified_min_det( face_img )
     [row,col]=find (face_img>0);
     rmin=min(row);
     cmin=min(col);
     rmax=max(row);
     cmax=max(col);
     
     rmid=ceil((rmax+rmin)/2);
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

     mean_find_r_min_lt_index=ceil((find_r_min_lt_index+find_r_min_rt_index)/2);
end

