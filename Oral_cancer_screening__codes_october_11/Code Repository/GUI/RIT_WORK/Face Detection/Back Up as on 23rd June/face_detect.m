function [I_new,mask_F,r_min1] = face_detect( I_F )
%% Documentation
% face_detect:-
% Called by funtion: Try_Anova_New_Code.m
% Functions called in this fn: neck_detection.m
%                              modified_min_det.m
% i/p parameters to the fn: I_F ( The input image )
% o/p parameters of the fn: I_new ( The binarized detected face image )
%                           r_min1

% Variable names: 
%                   1. I_F_n    :: Thermal image mapped to intensities (0-255)
%                   2. level    :: Determined threshold using Minimum Error thresholding 
%                   3. BW       :: Binarized image after thresholding  
%                   4. mask_F   :: Mask of the thresholded face image
%                   5. Ph       :: Horizontal Projection
%                   6. Pv       :: Vertical Projection
%                   7. xmin     :: Minimum row offset for determining projections
%                   8. Fx       :: Gradient of Horizontally Projected vector  
%                   9. pks,locs :: Peaks and locations of peaks using findpeaks
%                   10. face_detect_min_r :: Identifying the top boundary of the face
%                   11. Fy_c    :: Smoothened Verically projected vector (using imboxfilt)
%                   12. c1      :: Left Boundary of face
%                   13. c2      :: Right Boundary of face
%                   14. I_new   :: Cropped face image
%                   15. 
%                   16. 
%                   17. 
%                   18. 
%                   19. 
%                   20. 
                 
%%

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
    %p_sort=sort(p,'descend');
   % p_loc=find(p_sort(1)==p);
    face_detect_min_r=locs(1)
    %face_detect_min_r=locs(p_loc)

    
   % face_detect_min_r=find(Fx==max(Fx));
    temp=[1:size(mask_F,2)];
%     figure();
%     imshow(I_F_n/255);title('Bounding Box');
%     hold on;
%     plot(temp,r_max,'c*');
    r_min1=find(Fx1==min(Fx1));
    r_min1=r_min1+xmin1;
    temp=[1:size(mask_F,2)];
    %plot(temp,r_min1,'c*');
   

    for i=cmin:size(mask_F,2)
        Pv(i)=sum(mask_F(:,i));
    end
%      for i=162:508
%         Pv(i)=sum(mask_F(:,i));
%     end
    
    Fy=gradient(Pv);
    temp=[1:size(mask_F,1)];
                                               
%     max_mask=[-1 0 2 0 -1];
    Fy_c=imboxfilt(Fy,21);
%     Fy_c=conv(max_mask,Fyy);
%     figure();plot(Fy_c);
    th=floor((1/2).*max(abs(Fy_c))); 
    c1=find(Fy_c>th);
%     plot((c2(1)+min(row_0)),temp,'c*');
                                                
%     min_mask=[1 0 -2 0 1];
%     Fy_c1=conv(min_mask,Fyy(length(Fyy):-1:1));
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21);
%     figure();plot(Fy_c1);
    th_min=floor((1/2).*max(abs(Fy_c1)));
     %  Finding the most  prominent point to detect minimum row of face 
    c2=find(abs(Fy_c1)>th_min);
    c2=length(Fy)-c2;
    %     plot((c2(1)+min(row_0)),temp,'c*');
                                                
  
%% Face Cropping-Initial
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((c1(1))) && j<((c2(1))) && (i>face_detect_min_r))   %FRONTAL
         %   if(j<c2)       %lEFT
%             if(j>c1)       %right
                I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
%% Harris Corner Detection
%                                             C=corner(I_new(r_min1:end,:),'Harris');
%                                             %imshow(I_new);hold on;plot(C(:,1),(C(:,2)+r_min1),'c*');
%                                             face_detect_max_r=median(C(:,2));
%                                             face_detect_max_r=face_detect_max_r+r_min1;
% %% Boundary Plot
%                                             figure();
%                                             imshow(mat2gray(I_F));title('AFTER FILLING');
%                                             temp=[1:size(mask_F,1)];
%                                             hold on;
%                                             plot(c2(1),temp,'c*');
%                                             plot(c1(1),temp,'c*');
%                                             temp=[1:size(mask_F,2)];  
%                                             plot(temp,face_detect_max_r,'c*');
%                                             plot(temp,face_detect_min_r,'c*');
%                                             hold off;
%% Projection Plots
                                            % figure();
                                            % plot(temp,Pv);title('Vertical Projection');
% temp=[1:xmin]; 
                                            % figure();
                                            %   plot(temp,Ph);title('Horizontal Projection');
%% Gradient Plots
                                            % figure();
%                                           Fy_c_length=[1:length(Fy_c)];
%                                           Fy_c1_length=[1:length(Fy_c1)];
                                            % plot(Fy_c_length,Fy_c);title('Vertical Projection Max - Double Gradient');
                                            % figure();
                                            % plot(Fy_c_length,Fy_c1);title('Vertical Projection Min -Double Gradient');
%% Face Cropping
%                                             for i=1:size(mask_F,1)
%                                                     for j=1:size(mask_F,2)
%                                                        if((j>c1(1)) && j<((c2(1))) && (i>face_detect_min_r) && (i<face_detect_max_r))   %FRONTAL
%                                                      %   if(j<c2)       %lEFT
%                                             %             if(j>c1)       %right
%                                                             I_new(i,j)=BW(i,j);
%                                                         else
%                                                             I_new(i,j)=0;
%                                                         end
%                                                     end
%                                             end
%                                                 I_new=imfill(I_new,'holes');

%% Finding the req_row

    I_F=mat2gray(I_F);
    face_img=(I_F).*double(I_new);
    [modified_r_min] = modified_min_det( face_img )
    [r,c]=find(face_img>0);
    rmin=min(r);
    rmax=max(r);
%     column_id_data=face_img(modified_r_min,:);
%     c=find(column_id_data>0);
    cmin=min(c);
    cmax=max(c);
    cmid=ceil((min(c)+max(c))/2);
    
    req_dist=cmax-cmin;
    max_face_row=modified_r_min+req_dist;
    if(max_face_row > rmax)
        max_face_row=rmax;
    end
    min_row=modified_r_min;
    cmid=ceil((cmin+cmax)/2);
   % figure();
   % imshow(face_img);title(nameFolds{folder_idx});
   % hold on;
   % plot(cmid,max_face_row,'r*');
    
    modified_min_row_nose=ceil((1/2)*(max_face_row-min_row)+min_row); 
    
    temp=[];
    nose_img=face_img(modified_min_row_nose:max_face_row,min(c):max(c));
    for i=1:size(nose_img,1)
         temp(i,:)=(gradient(nose_img(i,:)));
         variance(i)=var(temp(i,:));
         Fx_temp=(gradient(nose_img(i,:)));
    end
     
     cropped_variance=variance(1:((3/4)*size(variance,2)));
     thresh=0.6*max(cropped_variance);
     local_max=find(cropped_variance>=thresh);
     local_max=local_max(1);
     % [pks_lt,locs_lt,w_lt,p_lt] = findpeaks(cropped_variance);
     counter=local_max;
     difference=cropped_variance(counter+1)-cropped_variance(counter)
    
     while(difference>=0)
         difference=cropped_variance(counter+1)-cropped_variance(counter);
         counter=counter+1;
     end
     while(difference<=0&&counter<size(cropped_variance,2))
         difference=cropped_variance(counter+1)-cropped_variance(counter);
         counter=counter+1;
     end
     req_row=counter-1+modified_min_row_nose;
     
     %% Neck Detection
     
    [ p,x,y ] = neck_detection( face_img,req_row )
   
    length_init=length(1:min(c));
    length_final=length(max(c):size(mask_F,2));
    zero_1=(zeros(length_init,1))';
    zero_2=(zeros(length_final,1))';
    y=[zero_1 y zero_2];
    figure();
    imshow(I_F,[]);title('Neck Detection');
    hold on;
    x=[1:length(y)];
    plot(x,y);
    
    %% Face_Cropping
     for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((c1(1))) && j<((c2(1))) && (i>face_detect_min_r) && i<y(j) )   %FRONTAL
         %   if(j<c2)       %lEFT
%             if(j>c1)       %right
                I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
figure();
imshow(I_new,[]);title('Final Face Detected image');
     

end
     
     