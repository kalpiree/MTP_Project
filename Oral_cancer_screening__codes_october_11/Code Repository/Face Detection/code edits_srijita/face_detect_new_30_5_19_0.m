function [BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row] = face_detect_new(filename,pathname); % Called by function          : Face_Detection_Keypoint_Cleaned_Code.m
%% i/p parameters to the fn   : I_F ( The input image )(MASKED)
% i/p parameters to the fn    : filename (The input image) (MINE)
%% o/p parameters of the fn   : I_new ( The binarized detected face image)
% )(MASKED)
% o/p parameters of the fn    : BW_mask_F ( The binarized detected face
% image) (MINE)
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
%%                   14. I_new   :: Cropped face image (MASKED)
%                   14. BW_mask_F:: Cropped face image (MINE)
%                   15. C :: Detected Harris corners
%                   16. face_detect_max_r :: Determining the lower boundary of the face ( median of the corner points )
%                   
  
%% Obtain the mask of the face after segmentation using minimum error thresholding technique
    %I_F=imread(filename);
    I_F_n=((filename-min(filename(:)))/(max(filename(:))-min(filename(:))))*255; % Normalizing the Face Image to the range [0,255].
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_n); % Computing threshold using Minimum Error Thresholding Segmentation.
    BW = im2bw(I_F_n/255,level/255); % Obtain the binary version of the face image after thresholding.
    BW=imfill(BW,'holes'); % Fill the holes 
    mask_F=I_F_n.*double(BW); % Convolving the thresholded mask with the original face image, to obtain the Face Mask
    mask_F=mat2gray(mask_F); 
  
%% Boundary Formation
    Ph=[]; %Horizontal Projection Vector.
    Pv=[]; % Vertical Projection Vector.
    [row,col]=find (mask_F>0);
    % Computing Boundaries of the Face Mask     
    rmin=min(row);
    rmax=max(row);
    cmin=min(col);
    cmax=max(col);%%%%%%%%%%%%rmin and rmax are the first nonzero row and last non zero row
    
    % Finding the horizontal projection  
    for i=1:rmax
       Ph(i)=sum(mask_F(i,:)); % This section is for finding upper row boundary
    end
    
    Fx=gradient(Ph); % Compute the gradient for horizontal projection.
    %  Finding the most  prominent point to detect minimum row of face 
   % [pks,locs,w,p]=findpeaks(Fx);  (MASKED)
    [pks,locs,w,p]=findpeaks(Fx);
    face_detect_min_r=locs(1); % Most Prominent Peak Obtained
       
    % Finding the Column Boundaries of the Face
    % Compute Vertical Projection
    for i=cmin:cmax
        Pv(i)=sum(mask_F(:,i));
    end
    
    Fy=gradient(Pv);  % Compute the gradient for vertical projection.
    % Finding the Left face boundary                                     
    Fy_c=imboxfilt(Fy,21);
    th_right=floor((1/2).*max(abs(Fy_c))); % Setting a threshold for the gradient of vertical projection
    c1=find(Fy_c>th_right);
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21); % Reversing the vector
    th_left=floor((1/2).*max(abs(Fy_c1))); % Setting a threshold for the gradient of vertical projection
    % Finding the most  prominent point to detect minimum row of face 
    c2=find(abs(Fy_c1)>th_left);
    c2=length(Fy)-c2;
    if isempty(c1)==isempty([])
    c1(1)=cmin;
    end
    if isempty(c2)==isempty([])
    c2(1)=cmax;
    end
    %Boundary points of face
    rt_boundary_col=c1(1);
    lt_boundary_col=c2(1);
    upper_boundary_row=face_detect_min_r;
%     row_traverse=1;
%% FACE BOUNDARY Adjustments
count=1;
while(count==1)
    row_traverse=1;
    while(BW(row_traverse,rt_boundary_col)==0&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
    end
     while(BW(row_traverse,rt_boundary_col)==1&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
        count=1;
     end
     while(BW(row_traverse,rt_boundary_col)==0&&row_traverse~=size(BW,1))%%%%%%
        row_traverse=row_traverse+1;
        count=2;
     end
     if(count==1)
    rt_boundary_col=rt_boundary_col+1;
     end
end

    count=1;
while(count==1)
    row_traverse=1;
    while(BW(row_traverse,lt_boundary_col)==0&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
    end
     while(BW(row_traverse,lt_boundary_col)==1&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
        count=1;
     end
     while(BW(row_traverse,lt_boundary_col)==0&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
        count=2;
     end
     if(count==1)
    lt_boundary_col=lt_boundary_col-1;
     end
end
%% Face Cropping-Initial
% Cropping the face based on te 3 obtained boundaries.
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((rt_boundary_col)) && j<((lt_boundary_col)) && (i>upper_boundary_row))   %FRONTAL
                BW_mask_F(i,j)=mask_F(i,j);
            else
                BW_mask_F(i,j)=0;
            end
        end
    end
%% Harris Corner Detection
xmin1=rmax-ceil(0.3*(rmax-rmin)) ;I_new1=BW_mask_F(xmin1:end,(rt_boundary_col+1):(lt_boundary_col-1)); % Modified Image with updated boundaries
C=corner(I_new1); % Harris Corners Obtained
face_detect_max_r=median(C(:,2)); % Considering the median of all the obtained Harris corners
face_detect_max_r=face_detect_max_r+xmin1; % Addign the offset
lower_boundary_row=face_detect_max_r;
                                           

%% Face Cropping
for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if((j>rt_boundary_col) && j<((lt_boundary_col)) && (i>upper_boundary_row) && (i<lower_boundary_row))   %FRONTAL
                BW_mask_F(i,j)=BW(i,j);
            else
                BW_mask_F(i,j)=0;
            end
        end
end
    BW_mask_F=imfill(BW_mask_F,'holes'); 
    %%
    

end
