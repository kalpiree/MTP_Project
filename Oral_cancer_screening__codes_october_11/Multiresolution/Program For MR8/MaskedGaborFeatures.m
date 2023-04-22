% =========================== Masked_GaborFeatures.m ====================================== %
% Description  : 
% Generate a texture feature vector from the largest possible central 
% circular zone within an image.
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%                    M  = Lagest possible central circular zone
%                         from which Energy and Standard Deviation
%                         are evaluated to constructed feature vector.
%                    Ul = Lowwer Central Half Frequency
%                    Uh = Upper Central Half Frequency
%                    K  = No. of Directions
%                    S  = No. of Scales
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    F = Texture feature vector
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: GaborKernel.m
%   #2: BandFeature_Mask.m
% Called by :  TexturalFeatureExtraction_3D_DWT.m
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] J. Han and K. K. Ma, " Rotation-invariant and scale-invariant Gabor 
%    features for texture image retrieval," Image and vision computing, 
%    vol. 25, no. 9, pp. 1474-1481, 2007.

% Author of the code:  Rahul Das Gupta  
% Date of creation :    11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    12-03-2016
% Modification details:    
% Modified By :   Rahul Das Gupta 
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function F= MaskedGaborFeatures(I,M,Ul,Uh,S,K)

F=[];
M=double(M);
 for m=0:S-1
     for n=0:K-1
         
         [KR,KI]= GaborKernel(Ul,Uh,S,K,m,n);
         [p,q]=size(KR);
         
         U=ones(p,q);
         C=conv2(M,U,'same');
         Max_C=max(C(:));
         L=(C==Max_C);
         
         JR=conv2(I,KR,'same');
         JI=conv2(I,KI,'same');
                           
         F=[F,[BandFeature_Mask(JR,L),BandFeature_Mask(JI,L)]];

     end
 end

end
%*********************************************************************
function f=BandFeature_Mask(I,L)

   f=[mean(abs(I(L))),sqrt(var(I(L)))];
   
end
