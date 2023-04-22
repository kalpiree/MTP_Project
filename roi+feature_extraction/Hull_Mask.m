function [ face_region,mid_mouth,face_keypt_X,face_keypt_Y ] = Hull_Mask( face_img,req_col_mouth_rt,req_col_mouth_lt,c_rt,c_lt,r_rt,r_lt,mouth_row_index_req,lower_lip_row )
%% Documentation
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            req_col_mouth_rt 
%                            req_col_mouth_lt 
%                            c_rt, r_rt 
%                            c_lt, r_lt 
%                            col_lt_eye 
%                            mouth_row_index_req
%                            lower_lip_row
% o/p parameters of the fn:  face_region 
%                            

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. face_keypt_X :: Contains the col coord of Hull pts.
%                    2. face_keypt_Y :: Contains the row coord of Hull pts.
%                    3. BW :: Binary mask of the ROI 
%                    4. face_portion_masked :: Contains only the Hull region around the mouth.
%                    5. face_region :: Contains the req. face image with
%                    the region around the mouth blacked out.
%                  
%%
mid_mouth=ceil((req_col_mouth_rt+req_col_mouth_lt)/2);
[img_size_X,img_size_Y]=size(face_img); % Determining the size of the image
face_keypt_X=[c_rt(1)-20;c_lt(1)+20;req_col_mouth_lt+20;req_col_mouth_rt-20;mid_mouth]; % Column coordinates of the Hull Points
face_keypt_Y=[r_rt-20;r_lt-20;mouth_row_index_req;mouth_row_index_req;lower_lip_row+10]; % Row coordinates of the Hull Points
% face_keypt_X=[c_rt(1);c_lt(1);req_col_mouth_lt;req_col_mouth_rt;mid_mouth]; % Column coordinates of the Hull Points
% face_keypt_Y=[r_rt;r_lt;mouth_row_index_req;mouth_row_index_req;lower_lip_row]; % Row coordinates of the Hull Points

k = convhull(face_keypt_X,face_keypt_Y); % Formation of the convex Hull
BW = poly2mask(face_keypt_X(k),face_keypt_Y(k),img_size_X,img_size_Y); % Computing the Binary ROI for the region marked above.
face_portion_masked = bwconvhull(BW); % Contains only the Hull region around the mouth.
face_portion_masked=~face_portion_masked; 
face_portion_masked=double(face_portion_masked);
face_region = face_img.*face_portion_masked; % Convolving the original image with the marked mask to obtain the required ROI.
%figure;imshow(face_region);
%hold on;
%plot(face_keypt_X(k),face_keypt_Y(k),'LineWidth',3,'Color','r');

% plot(face_keypt_X(k),face_keypt_Y(k),'r-',face_keypt_X,face_keypt_Y,'b*');title('Convhull of poly2mask')


end

