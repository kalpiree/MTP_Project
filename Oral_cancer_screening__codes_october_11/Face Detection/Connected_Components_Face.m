function [ face_img ] = Connected_Components_Face( face_img,op_img1,lower_lip_row )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
max_face_img=max(face_img(:));
[face_img_max_X,face_img_max_Y]=find(face_img==max_face_img);
face_img_temp=face_img(1:lower_lip_row,:);
face_img_avg = mean( nonzeros(face_img_temp));
tolerance=(max_face_img-face_img_avg);
tolerance=ceil(10*tolerance)/10;
face_img_avg=ceil(10*face_img_avg)/10;
face_img_avg_mat=(face_img>0).*face_img_avg;
dist_face_img_and_faceimgavg=abs(face_img-face_img_avg_mat);
[x_dist_face_img_and_faceimgavg,y_dist_face_img_and_faceimgavg]=find(dist_face_img_and_faceimgavg==min(nonzeros(dist_face_img_and_faceimgavg(:))));


BW_face_img = grayconnected(face_img,x_dist_face_img_and_faceimgavg(1),y_dist_face_img_and_faceimgavg(1),tolerance);

BW_face_img=imfill(BW_face_img,'holes');
face_img=face_img.*(BW_face_img);
% figure, imshow (face_img,[]);

new_face_region=strcat(op_img1,'_face_segmented');



end

