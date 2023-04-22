function [row_lip,col_lip] = lip_detection_thermal( face_img,col_rt_eye,col_lt_eye,row_mean_eye )

euclideanDistance = sqrt((col_rt_eye-col_lt_eye)^2);
col_lip=ceil((col_rt_eye+col_lt_eye)/2);
row_lip=(1.8*euclideanDistance)+row_mean_eye;




end

