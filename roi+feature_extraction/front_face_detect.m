function [face_img,mask_F,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row] = front_face_detect( image )
%% Obtain the mask of the face after segmentation using minimum error thresholding technique
%image = imread('C:\Users\ntnbs\Downloads\my_code\sample_og.jpg');
%subplot(1,3,1);
%imshow(image),title("1");
I_F_n=((image-min(image(:)))/(max(image(:))-min(image(:))))*255;
%imshow(I_F_n)
[level,~]=kittlerMinimimErrorThresholding_(I_F_n);  % READ ABOUT THIS % criterion changed to ~
BW = im2bw(I_F_n/255,level/255);
%imshow(BW)
BW=imfill(BW,'holes');
%imshow(BW)
mask_F=double(I_F_n).*double(BW);
%mask_F=(I_F_n).*(BW);
%imshow(mask_F)
mask_F=im2gray(mask_F);
%subplot(1,3,2);
%imshow(mask_F),title("2");

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
    
    %size(Fx)
    
    % Finding the Column Boundaries of the Face
    % Compute Vertical Projection
    for i=cmin:cmax
        Pv(i)=sum(mask_F(:,i));
    end
    %  Finding the most  prominent point to detect minimum row of face 
    [pks,locs,w,p]=findpeaks(Fx);  
    face_detect_min_r=locs(1); % Most Prominent Peak Obtained
    
    % Finding the Column Boundaries of the Face
    % Compute Vertical Projection
    for i=cmin:cmax
        Pv(i)=sum(mask_F(:,i));
    end
    
    %% Revisit this part
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
                I_new(i,j)=mask_F(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
    
 %% Harris Corner Detection
xmin1=rmax-ceil(0.3*(rmax-rmin)) ;I_new1=I_new(xmin1:end,(rt_boundary_col+1):(lt_boundary_col-1)); % Modified Image with updated boundaries
C=corner(I_new1); % Harris Corners Obtained
%C = detectHarrisFeatures(I_new1) % try these two by transposing below
%C = detectMinEigenFeatures(I_new1)
face_detect_max_r=median(C(:,2)); % Considering the median of all the obtained Harris corners
face_detect_max_r=face_detect_max_r+xmin1; % Addign the offset
lower_boundary_row=face_detect_max_r;

%% Face Cropping
for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if((j>rt_boundary_col) && j<((lt_boundary_col)) && (i>upper_boundary_row) && (i<lower_boundary_row))   %FRONTAL
                I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
        end
end
I_new=imfill(I_new,'holes'); 
%subplot(1,2,1);
%imshow(I_new)
lower_boundary_row=floor(lower_boundary_row);
I_F=im2gray(image);
%imshow(I_F)
face_img=double(I_F).*double(I_new);
%subplot(1,2,2);
%imshow(face_img)
end