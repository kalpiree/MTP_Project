
% =========================== nose_tip.m ====================================== %
% Description  : 
% In this code we calculate the cordinates of the nose tip which we
% calculate
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%                    mask = mask generated from the face
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    cordinates of the nose tip
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
function[y_cordinate, x_cordinate,BW,Index_ver_pro] = nose_tip(mask)

[~, col] = size(mask);

BW= mask;

%horizontal and vertical projection

horpro1= sum(BW,2); %vertical array
verpro= sum(BW,1);  
[max_ver_pro,Index_ver_pro]=max(verpro);

BW(:,Index_ver_pro:640)=0;  
horpro2 = sum(BW,2);
[max_hor_pro2,Indexnose]=max(horpro2);

arr=mask(Indexnose,:);

x_cordinate = min(find(arr>0));
y_cordinate = Indexnose;


















end