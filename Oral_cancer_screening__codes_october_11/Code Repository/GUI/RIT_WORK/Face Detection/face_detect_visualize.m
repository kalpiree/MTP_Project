function [I_new,mask_F,Result_ratio,c1,c2,face_detect_min_r,face_detect_max_r] = face_detect_visualize( I_F,nameFolds,folder_idx  )
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
    mask_F=I_F_n.*double(BW);
                                            %     figure();
                                            % imshow(mask_F);title('BEFORE FILLING');
    mask_F=imfill(mask_F,'holes');
                                                 
    
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
    
    xmin1 = round(2.5/3*(size(mask_F,1)-rmin))+rmin;
    
    for i=xmin1:(xmin1+40)
       Ph1(i)=sum(mask_F(i,:));
    end
    
    Ph2=Ph1((xmin1+1):(xmin1+15));
    Fx=gradient(Ph);
    Fx1=gradient(Ph2);
    
    %  Finding the most  prominent point to detect minimum row of face 
    [pks,locs,w,p]=findpeaks(Fx);
    figure();
    plot(Fx);
    
    face_detect_min_r=locs(1)
       
    temp=[1:size(mask_F,2)];
    r_min1=find(Fx1==min(Fx1));
    r_min1=r_min1+xmin1;
   
    % Finding the Right face boundary    
    for i=cmin:size(mask_F,2)
        Pv(i)=sum(mask_F(:,i));
    end
    
    Fy=gradient(Pv);
    temp=[1:size(mask_F,1)];
    % Finding the Left face boundary                                     
    Fy_c=imboxfilt(Fy,21);
    th=floor((1/2).*max(abs(Fy_c))); 
    c1=find(Fy_c>th);
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21);
    th_min=floor((1/2).*max(abs(Fy_c1)));
    % Finding the most  prominent point to detect minimum row of face 
    c2=find(abs(Fy_c1)>th_min);
    c2=length(Fy)-c2;
                                                
  
%% Face Cropping-Initial
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((c1(1))) && j<((c2(1))) && (i>face_detect_min_r))   %FRONTAL
                I_new(i,j)=mask_F(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
%% Harris Corner Detection
C=corner(I_new(xmin1:end,:),'Harris');
%imshow(I_new);hold on;plot(C(:,1),(C(:,2)+r_min1),'c*');
face_detect_max_r=median(C(:,2));
face_detect_max_r=face_detect_max_r+r_min1;
%% Boundary Plot
                                            figure();
                                            imshow(mat2gray(I_F));title('AFTER FILLING');
                                            temp=[1:size(mask_F,1)];
                                            hold on;
                                            plot(c2(1),temp,'c*');
                                            plot(c1(1),temp,'c*');
                                            temp=[1:size(mask_F,2)];  
                                            plot(temp,face_detect_max_r,'c*');
                                            plot(temp,face_detect_min_r,'c*');
                                            hold off;
%% Projection Plots
                                            % figure();
                                            % plot(temp,Pv);title('Vertical Projection');
temp=[1:xmin]; 
                                            % figure();
                                            %   plot(temp,Ph);title('Horizontal Projection');
%% Gradient Plots
                                            % figure();
Fy_c_length=[1:length(Fy_c)];
Fy_c1_length=[1:length(Fy_c1)];
                                            % plot(Fy_c_length,Fy_c);title('Vertical Projection Max - Double Gradient');
                                            % figure();
                                            % plot(Fy_c_length,Fy_c1);title('Vertical Projection Min -Double Gradient');
%% Face Cropping
for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if((j>c1(1)) && j<((c2(1))) && (i>face_detect_min_r) && (i<face_detect_max_r))   %FRONTAL
                I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
        end
end
    I_new=imfill(I_new,'holes');   
     %%
  %   direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Ground_Truth_F_',nameFolds{folder_idx},'.mat'];
    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_',nameFolds{folder_idx},'.mat'];
 %    direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_',nameFolds{folder_idx},'.mat'];
     
     load(direc);
     
     detected_left_col=c1(1);
     detected_top_row=face_detect_min_r;
     detected_bottom_row=face_detect_max_r;
     detected_right_col=c2(1);
     
     [ground_row,ground_col]=find(save_img > 0);
     ground_left_col=min(ground_col);
     ground_top_row=min(ground_row);
     ground_bottom_row=max(ground_row);
     ground_right_col=max(ground_col);
     
     intersection_top_row=[];
     intersection_bottom_row=[];
     intersection_left_col=[];
     intersection_right_col=[];
     
     union_top_row=[];
     union_bottom_row=[];
     union_left_col=[];
     union_right_col=[];
     
     if(detected_left_col > ground_left_col)
         intersection_left_col=detected_left_col;
         union_left_col=ground_left_col;
     else
         intersection_left_col=ground_left_col;
         union_left_col=detected_left_col;
     end
     
     if(detected_right_col > ground_right_col)
         intersection_right_col=ground_right_col;
         union_right_col=detected_right_col;
     else
         intersection_right_col=detected_right_col;
         union_right_col=ground_right_col;
     end
     
     if(detected_top_row > ground_top_row)
         intersection_top_row=detected_top_row;
         union_top_row=ground_top_row;
     else
         intersection_top_row=ground_top_row;
         union_top_row=detected_top_row;
     end
     
     if(detected_bottom_row > ground_bottom_row)
         intersection_bottom_row=ground_bottom_row;
         union_bottom_row=detected_bottom_row;
     else
         intersection_bottom_row=detected_bottom_row;
         union_bottom_row=ground_bottom_row;
     end
     
     area_intersection=(intersection_bottom_row-intersection_top_row)*(intersection_right_col-intersection_left_col);
     area_union=(union_bottom_row-union_top_row)*(union_right_col-union_left_col);
     
     Result_ratio=(area_intersection)/(area_union);
end
