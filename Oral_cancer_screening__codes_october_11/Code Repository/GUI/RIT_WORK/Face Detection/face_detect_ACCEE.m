function [I_new,mask_F,Result_ratio] = face_detect_ACCEE( I_F,nameFolds,folder_idx )

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
    for i=1:rmax
       Ph(i)=sum(BW(i,:));
    end
    off=find(Ph>0,1);
    Ph=Ph(off:end);
    Fx=gradient(Ph);
    %Fx=Ph;
    Ph=imboxfilt(Ph,21);
    
    Fx=gradient(Ph);
       
    shoulder_row=find(min(Fx)==Fx,1)+off;
    
    for i=cmin+1:size(BW,2)
        Pv(i-cmin)=sum(BW(:,i));
    end
   
    face_detect_min_r=481-max(Pv);
   
 %  Pv=imboxfilt(Pv);
    Fy=gradient(Pv);
%    Fyy=gradient(Fy);
      
    c2(1)=find(Fy==min(Fy),1);
    c1(1)=find(Fy==max(Fy),1);
    
   
    Head_distance=abs(shoulder_row-face_detect_min_r);
    face_detect_max_r=Head_distance+face_detect_min_r;
    
    c2(1)=c2(1)+cmin;
    c1(1)=c1(1)+cmin;
%     temp=[1:size(BW,1)];
%     % Finding the Left face boundary                                     
%     Fy_c=imboxfilt(Fy,21);
%     th=floor((1/2).*max(abs(Fy_c))); 
%     c1=find(Fy_c>th);
%     Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21);
%     th_min=floor((1/2).*max(abs(Fy_c1)));
%     % Finding the most  prominent point to detect minimum row of face 
%     c2=find(abs(Fy_c1)>th_min);
%     c2=length(Fy)-c2;
%     plot(c1(1),temp,'b*');
%     plot(c2(1),temp,'b*');                                            
%     hold off;
%% Face Cropping-Initial
 for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if((j>c1(1)) && j<((c2(1))) && (i>face_detect_min_r) && (i<face_detect_max_r))   %FRONTAL
                I_new(i,j)=mask_F(i,j);
            else
                I_new(i,j)=0;
            end
        end
end
    I_new=imfill(I_new,'holes');
    
    lt_boundary_col=c2(1);
    rt_boundary_col=c1(1);
    lower_boundary_row=face_detect_max_r;
    upper_boundary_row=face_detect_min_r;
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
%     %%
%       direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
%   direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
  direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
  save(direc,'rt_boundary_col','lt_boundary_col','lower_boundary_row','upper_boundary_row');
end