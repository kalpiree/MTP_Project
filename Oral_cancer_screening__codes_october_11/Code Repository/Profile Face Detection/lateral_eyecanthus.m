 % =========================== lateral_eyecanthus.m ====================================== %
% Description  : 
% In this code we find the hot spot near the eye canthus
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%                    mask = MAsk of the image
%                    g_row,g_col = cordinates of the point in the mid of
%                    the eye
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
function [canthus_r, canthus_c] = lateral_eyecanthus(mask,g_row,g_col,dist,csv)
 canthus_r=0;
 canthus_c=0;
 
    mask = csv .* double(mask);
    mask(:,g_col+round(dist/2):1:640)=0;
    mask(g_row-round(dist/5):-1:1,:)=0;
    mask(g_row+round(dist/5):1:480,:)=0;
    mew = mask(g_row-round(dist/5):1:g_row+round(dist/5),g_col:1:g_col+round(dist/3));
  

  
%   B = double(ones(5,5));
  B = fspecial('gaussian');
  mew = conv2(mew,B,'same');
  
  [I,J] = find(mew==max(max(mew)));
%   
%   I_v= std(I);
%   I=mean(I);
%   J_v= std(J);
%   J= mean(J);
%   I=I+I_v;
%   J=J+J_v;
%   
  canthus_r= I+g_row-round(dist/5);
  %canthus_r= I+g_row-round(dist/10); % edited on 15.08.2019
  canthus_c=J+g_col;
  %canthus_c=J+g_col+round(dist/2.5)% edited on 15.08.2019
  
  
  
  




 
 
 end
 
 