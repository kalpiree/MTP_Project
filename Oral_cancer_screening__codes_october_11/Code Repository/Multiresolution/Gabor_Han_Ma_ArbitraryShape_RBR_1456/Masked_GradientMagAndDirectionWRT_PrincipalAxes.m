% ============================ FindAngle.m file ============================= %
%
% Description  : To find the Angle of Principal Texture Direction with X-Axis.
% Input parameter : Image Matrix 
% Output parameter:   Angle between Principal Texture Direction & X-Axis.
% Subroutine  called : Nothing  
% Called by :WaveletFeatures.m  
% Reference : 
% Author of the code:Rahul Das Gupta
% Date of creation:11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on     :    
% Modification details :    
% Modified By    :    
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== % 
function [GM,GD]=Masked_GradientMagAndDirectionWRT_PrincipalAxes(I,M)

I=double(I);
% E=edge(Mask,'canny');
G=[];
[m n]=size(I);
[dIX,dIY]=gradient(I);
[m n]=size(dIX);
dIX1=[];
dIY1=[];
%Computation of X & Y Components of Gradients at each points of Image
for i=2:m-1
    for j=2:n-1
        if  M(i-1,j-1)*M(i-1,j)*M(i-1,j+1)*M(i,j-1)*M(i,j)*M(i,j+1)*M(i+1,j-1)*M(i+1,j)*M(i+1,j+1)==1
            dIX1=[dIX1; dIX(i,j)];
            dIY1=[dIY1; dIY(i,j)];
        end
    end
end


G=[dIX1(:) dIY1(:)];
 

COV=cov(G);
%Principal Component Analysis
[eVector,eVlaue]=eig(COV);
[max_eValue,index]=max(diag(eVlaue));

EVec1=eVector(:,index)';
if(index==1)
    next=2;
else
    next=1;
end
EVec2=eVector(:,next)';

dIX_New=EVec1(1)*dIX+EVec1(2)*dIY;
dIY_New=EVec2(1)*dIX+EVec2(2)*dIY;
   
GM=sqrt(dIX_New.^2+dIY_New.^2);
dIX1=dIX_New+eps;
dIY1=dIY_New+eps;
GD=atan2(dIY1,dIX1);

end