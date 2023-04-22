function [I_new,mask_F,r_min1] = face_detect_with_neck( I_F )
%% Documentation
% face_detect:-
% Called by funtion          : Try_Anova_New_Code.m
% Functions called in this fn: neck_detection.m
%                              modified_min_det.m
% i/p parameters to the fn   : I_F ( The input image )
% o/p parameters of the fn   : I_new ( The binarized detected face image )
%                              

% Variable names: 
%                    1. I_F_n    :: Thermal image mapped to intensities (0-255)
%                    2. level    :: Determined threshold using Minimum Error thresholding 
%                    3. BW       :: Binarized image after thresholding  
%                    4. mask_F   :: Mask of the thresholded face image
%                    5. Ph       :: Horizontal Projection
%                    6. Pv       :: Vertical Projection
%                    7. xmin     :: Minimum row offset for determining projections
%                    8. Fx       :: Gradient of Horizontally Projected vector  
%                    9. pks,locs :: Peaks and locations of peaks using findpeaks
%                   10. face_detect_min_r :: Identifying the top boundary of the face
%                   11. Fy_c    :: Smoothened Verically projected vector (using imboxfilt)
%                   12. c1      :: Left Boundary of face
%                   13. c2      :: Right Boundary of face
%                   14. I_new   :: Cropped face image
%                   15. modified_r_min :: Row index representing hair line
%                   16. max_face_row :: Project the horizontal maximum of the face from modified_r_min to obtain maximum face row
%                   17. modified_min_row_nose :: Represent the half of nose. 
%                   18. variance :: Store the row-wise variance.
%                   19. cropped_variance :: Reject the latter 25% of variance
%                   20. thresh :: threshold to identify the required peak.
%                   21. local_max :: Locate the first peak satifying the threshold
%                   22. difference :: Compute the successive differences to ID the peak
%                   23. req_row :: Represents the row between the mouth and the nose.
                   
%% Obtain the mask of the face after segmentation using minimum error thresholding technique

    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))))*255;
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_n);
    BW = im2bw(I_F_n/255,level/255); 
    mask_F=I_F_n.*double(BW);
%     mask_F=imfill(mask_F,'holes');
    BW=imfill(BW,'holes');
                                                 
    
%% Boundary Formation
    Ph=[];
    Pv=[];
    [row,col]=find (mask_F>0);
    rmin=min(row);
    cmin=min(col);
    xmin = round(1/2.5*(size(mask_F,1)-rmin))+rmin;
% Finding the horizontal projection  
    for i=1:xmin
       Ph(i)=sum(mask_F(i,:));
    end
    Fx=gradient(Ph);
% Finding the most  prominent point to detect minimum row of face 
    [pks,locs,w,p]=findpeaks(Fx);
    face_detect_min_r=locs(1);
% Finding the horizontal boundaries
    for i=cmin:size(mask_F,2)
        Pv(i)=sum(mask_F(:,i));
    end
% Finding the Right face boundary    
    Fy=gradient(Pv);
    Fy_c=imboxfilt(Fy,21);
    th=floor((1/2).*max(abs(Fy_c))); 
    c1=find(Fy_c>th);   
% % Finding the Left face boundary 
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21); % Reversing the array
    th_min=floor((1/2).*max(abs(Fy_c1)));
% Finding the most  prominent point to detect minimum row of face 
%     c2=find(min(Fy_c1)); 
    c2=find(abs(Fy_c1)>th_min); 
    c2=length(Fy)-c2; % Offset for reversed array
    
%% Face Cropping-Initial
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((c1(1))) && j<((c2(1))) && (i>face_detect_min_r))   
%                 if(j<((c2(1))) && (i>face_detect_min_r))   
               I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
%% Finding the req_row

    I_F=mat2gray(I_F);
    face_img=(I_F).*double(I_new);
    [lt,rt,find_r_min_lt,find_r_min_rt,find_r_min_lt_index,find_r_min_rt_index,find_col_lt,find_col_rt,r_eye_lt_region_max,r_eye_rt_region_max] = modified_min_det( face_img );
    modified_r_min=ceil((find_r_min_lt_index+find_r_min_rt_index)/2);
    [r,c]=find(face_img>0);
    rmin=min(r);
    rmax=max(r);
    cmin=min(c);
    cmax=max(c);
    cmid=ceil((min(c)+max(c))/2);
%  Projecting the horizontal length vertically to obtain max face row
    req_dist=cmax-cmin;
    max_face_row=modified_r_min+req_dist;
    if(max_face_row > rmax)         % Trivial case
        max_face_row=rmax;
    end
    min_row=modified_r_min;
    cmid=ceil((cmin+cmax)/2);
      
    modified_min_row_nose=ceil((1/2)*(max_face_row-min_row)+min_row); % To avoid the eye hotspots. 
    
    temp=[];
    nose_img=face_img(modified_min_row_nose:max_face_row,min(c):max(c));
    for i=1:size(nose_img,1)
         temp(i,:)=(gradient(nose_img(i,:)));
         variance(i)=var(temp(i,:));
    end
     
    cropped_variance=variance(1:((3/4)*size(variance,2))); % Consider only the first 75%
    thresh=0.6*max(cropped_variance);
    local_max=find(cropped_variance>=thresh);
    local_max=local_max(1);
    counter=local_max;
    difference=cropped_variance(counter+1)-cropped_variance(counter);
% Identify the local Maximum
    while(difference>=0)
        difference=cropped_variance(counter+1)-cropped_variance(counter);
        counter=counter+1;
    end
% Identify the local Minima
    while(difference<=0&&counter<size(cropped_variance,2))
        difference=cropped_variance(counter+1)-cropped_variance(counter);
        counter=counter+1;
    end
% Row between the nose and mouth  
    req_row=counter-1+modified_min_row_nose;
    
     %% Neck Detection
     
    [p,x,y]=neck_detection(face_img,req_row);
    length_init=length(1:min(c));
    length_final=length(max(c):size(mask_F,2));
    zero_1=(zeros(length_init,1))';
    zero_2=(zeros(length_final,1))';
    y=[zero_1 y zero_2]; % append zeros otherwise
    x=[1:length(y)];
    
    
    %% Face_Cropping with 4 boundaries
     for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((c1(1))) && j<((c2(1))) && (i>face_detect_min_r) && i<y(j) )   %FRONTAL
%                 if(j<((c2(1))) && (i>face_detect_min_r) && i<y(j))   
               I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
end
     
     