% function [rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row,I_new,mask_F,r_min1] = face_detect( I_F,nameFolds,folder_idx )
function [I_new,mask_F,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row] = face_detect_Harris_specs( I_F,nameFolds,folder_idx )


%%%% Documentation
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
%                   15. C :: Detected Harris corners
%                   16. face_detect_max_r :: Determining the lower boundary of the face ( median of the corner points )
%                   
  
%% Obtain the mask of the face after segmentation using minimum error thresholding technique

    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))))*255;
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_n);
    BW = im2bw(I_F_n/255,level/255);
    BW=imfill(BW,'holes');
    mask_F=I_F_n.*double(BW);
                                            %     figure();
                                            % imshow(mask_F);title('BEFORE FILLING');
%     mask_F=imfill(mask_F,'holes');
    mask_F=mat2gray(mask_F); 
        
%% Boundary Formation
    Ph=[];
    Pv=[];
    [row,col]=find (mask_F>0);
    rmin=min(row);
    rmax=max(row);
    cmin=min(col);
    cmax=max(col);
    xmin = round(1/2.5*(rmax-rmin))+rmin;
    % Finding the horizontal projection  
    for i=1:rmax
       Ph(i)=sum(mask_F(i,:)); % This section is for finding upper row boundary
    end
    
    xmin1 = round(2.5/3*(rmax-rmin))+rmin;
    
%     for i=xmin1:(xmin1+40)
%        Ph1(i)=sum(mask_F(i,:));
%     end
%     
%     Ph2=Ph1((xmin1+1):(xmin1+15)); % (xmin1+1) This + 1 is coz. if we take just xmin, then point of xmin will give max. gradient as it compares with Ph1(xmin1-1) which is 0
    Fx=gradient(Ph);
%     Fx1=gradient(Ph2);
    
    %  Finding the most  prominent point to detect minimum row of face 
    [pks,locs,w,p]=findpeaks(Fx);
        
    face_detect_min_r=locs(1)
       
%     temp=[1:size(mask_F,2)];
%     r_min1=find(Fx1==min(Fx1));
%     r_min1=r_min1+xmin1;
   
    % Finding the Right face boundary    
    for i=cmin:cmax
        Pv(i)=sum(mask_F(:,i));
    end
    
    Fy=gradient(Pv);
    temp=[1:size(mask_F,1)];
    % Finding the Left face boundary                                     
    Fy_c=imboxfilt(Fy,21);
    th_right=floor((1/2).*max(abs(Fy_c))); 
    c1=find(Fy_c>th_right);
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21);
    th_left=floor((1/2).*max(abs(Fy_c1)));
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
     while(BW(row_traverse,rt_boundary_col)==0&&row_traverse~=size(BW,1))
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
xmin1=rmax-ceil(0.3*(rmax-rmin)) ;I_new1=I_new(xmin1:end,(rt_boundary_col+1):(lt_boundary_col-1));

C=corner(I_new1);
imshow(I_new);hold on;plot((C(:,1)+(rt_boundary_col+1)),(C(:,2)+xmin1),'c*');
face_detect_max_r=median(C(:,2));
face_detect_max_r=face_detect_max_r+xmin1;
lower_boundary_row=face_detect_max_r;
figure();temp_r=[1:640];
imshow(mask_F);hold on;plot(temp_r,lower_boundary_row,'c*');
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
%     imshow(I_new*255);
  