% =========================== chin.m ====================================== %
% Description  : 
% In this code we generate the keypoints used for  chin corner etc 
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%  mAsk = mask generaed after thresholding
%  cordinates of the point on neck and nose tip
% 
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
function [ch_col, ch_row]= chin(mask,neck_row, neck_col,tip_row,tip_col)

mask= edge(mask,'Canny',.48,1);

mask(1:tip_row, :) =  0;

mask(:,neck_col :640) =  0;

dist_min=10000000000;
ch_row=0;
ch_col=0;
  for r=tip_row:1:neck_row
    for c=1:1:neck_col
    
    if mask(r,c)==1
        dist= sqrt(abs(neck_row-r)^2+abs(tip_col-20-c)^2);
        
        if(dist<dist_min)
        dist_min= dist;
        ch_row=r;
        ch_col=c;
        end
    end
    
    
    
    end
 end
 
 
 

end