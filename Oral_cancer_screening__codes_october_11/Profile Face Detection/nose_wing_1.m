
% =========================== nose_wing.m ====================================== %
% Description  : 
% in this code we calculate the cordinates of the nose wing hotspot
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%                    tip_row,tip_col = cordinates of the tip
%                    dist = is the distance  between chin and tip
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    cordinate of the nose wing
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
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
function [I, J]=nose_wing(tip_row,tip_col,mask,dist,csv)

    nw_row=0; 
    nw_col=0;
    mask(:,tip_col+round(dist):1:640)=0;
    mask(tip_row:-1:1,:)=0;
    mask(tip_row+round(dist/2):1:480,:)=0;
 
    
    temp = csv.*double(mask);
    
    
    %%% filter
    B = fspecial('gaussian');
    temp = conv2(temp,B,'same');
   %%%

    maxval=max(max(temp));
    minval=min(min(temp(mask>0)));
    range=255/(maxval-minval);
    temp_1=range.*(temp-minval); 
    I1 = uint8(temp_1);
    
    [I,J] = find(I1==max(max(I1)));
    I=mean(I);
    %J=mean(J);
    J= mean(J)+round(dist/6);%edited on 15.08.2019
    



end