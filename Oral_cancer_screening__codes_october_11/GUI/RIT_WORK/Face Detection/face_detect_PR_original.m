function [I_new,mask_F] = face_detect_PR_original( I_F,nameFolds,folder_idx )

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
    I_F_n=mat2gray(I_F_n);
    level=graythresh(I_F_n);
    BW = im2bw(I_F_n,level); 
    mask_F=I_F_n.*double(BW);
    mask_F=imfill(mask_F,'holes');
    BW=imfill(BW,'holes');
                                                 
    
%% Boundary Formation
%     figure();
%     imshow(mask_F,[]);
%     hold on;
    Ph=[];
    Pv=[];
    [row,col]=find (BW>0);
    rmin=min(row);
    rmax=max(row);
    cmin=min(col);
    cmax=max(col);
    for i=1:480
       Ph(i)=sum(mask_F(i,:));
    end
    off=find(Ph>0,1);
    Ph=Ph(off+1:end);
    Fx=gradient(Ph);
           
    face_detect_min_r=find(max(Fx)==Fx,1)+off;
    face_detect_max_r=find(min(Fx)==Fx,1)+off;
  
    for i=cmin+1:cmax
        Pv(i-cmin)=sum(BW(:,i));
    end
    
    Fy=gradient(Pv);
      
    c2(1)=find(Fy==min(Fy),1);
    c1(1)=find(Fy==max(Fy),1);
    
    c2(1)=c2(1)+cmin;
    c1(1)=c1(1)+cmin;
    
    rt_boundary_col=c1(1);
    lt_boundary_col=c2(1);
    lower_boundary_row=face_detect_max_r;
    upper_boundary_row=face_detect_min_r;
%% Face Cropping-Initial
 for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if((j>rt_boundary_col) && j<(lt_boundary_col) && (i>upper_boundary_row) && (i<lower_boundary_row))   %FRONTAL
                I_new(i,j)=mask_F(i,j);
            else
                I_new(i,j)=0;
            end
        end
end
    I_new=imfill(I_new,'holes');
%%
if isempty(rt_boundary_col)==isempty([])
    rt_boundary_col=1;
end
if isempty(lt_boundary_col)==isempty([])
    lt_boundary_col=1;
end
if isempty(lower_boundary_row)==isempty([])
    lower_boundary_row=1;
end
if isempty(upper_boundary_row)==isempty([])
    upper_boundary_row=1;
end
% direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
% direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
  direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
save(direc,'rt_boundary_col','lt_boundary_col','lower_boundary_row','upper_boundary_row');
end