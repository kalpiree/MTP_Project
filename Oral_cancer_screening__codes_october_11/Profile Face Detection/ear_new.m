% =========================== ear.m ====================================== %
% Description  : 
% IN THIS CODE WE CALCULATE THE CORDINATES OF THE CENTER OF THE HOTSPOT
% INSIDE EAR
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%                    Mask = mask of the image
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    Cordinates of keypoints shown in figure
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
% 
% 
% Called by : ~~~~
%------------------------------------------------------------------------------------%
% Reference:    
%~~~~~~~~~~~~
%~~~~~~~~~~~~
% Author of the code:  Ankit Tiwari  
% Date of creation :    10-05-2018
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    ~~
% Modification details:    ~~
% Modified By :  ~~ 
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %

function [ear_row, ear_col,mask,mask_temp] = ear(mask,tip_row,tip_col,chin_row, chin_col,e_row, e_col,csv,Index_ver_pro)
ear_row=0;
ear_col=0;

%  dist = round(sqrt(abs(chin_row-e_row)^2+abs(chin_col-e_col)^2));
 dist = round(chin_row-tip_row)/2;

% mask(:,tip_col+(dist/2):-1:1)=0;
% 
% mask(tip_row-.5*dist:-1:1,:)=0;
% 
% mask(tip_row+.5*dist:1:480,:)=0;

%  mask(:,tip_col+dist*2:-1:1)=0;  
 mask(:,Index_ver_pro:-1:1)=0;
 %mask(tip_row-dist:-1:1,:)=0; (MASKED)
 mask(floor(tip_row-dist):-1:1,:)=0;
 %mask(tip_row+dist:1:480,:)=0; (MASKED)
 mask(floor(tip_row+dist):1:480,:)=0;


    temp=csv.*double(mask);

    maxval=max(max(temp));
    minval=min(min(temp(mask>0)));
    range=255/(maxval-minval);
    temp_1=range.*(temp-minval); 
    
    


 temp_1= uint8(temp_1);
 %figure,imshow(temp_1);

 
 thres=maxval-(maxval-minval)*(.10);


  mask_temp = temp>thres; %%%mask_temp ear
  mask_temp = bwareafilt(logical(mask_temp),1);
%   nhood = [1 1 1; 1 1 1; 1 1 1];
%   mask_temp = imdilate(mask_temp,nhood);
  
%    CC=bwconncomp(mask_temp);
%   L=labelmatrix(CC);
%   stats = regionprops(L,'Eccentricity');
%   mask_temp=bwpropfilt(mask_temp,'Eccentricity',[0.8,1]);

%   temp_1=temp_1.*uint8(mask_temp);
  %figure,imshow(mask_temp);
 
 [I,J] = find(mask_temp==1);

 ear_row = mean(I);
 ear_col = mean(J)-dist/10;
 %ear_col = mean(J)-dist/2.5; % edited on 15.08.2019
end