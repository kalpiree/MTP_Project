% ============================ MaskedFindAngle.m file ============================= %
%
% Description  : To find the Angle of Principal Texture Direction with positive X-Axis.
% Input parameter : 
%             I = Input Image  
%             M = Binary mask to define ROI(Region of Interest)
% Output parameter:   
%             angle = Angle between Principal Texture Direction & positive X-Axis.
% Subroutine  called : Nothing  
% Called by : TexturalFeatureExtraction_Gabor_Alignment_ProposedMethod.m  
% Reference : 
% [1] R. D. Gupta, J. K. Dash, and M. Sudipta, \Rotation invariant textural
%     feature extraction for image retrieval using eigen value analysis of 
%     intensity gradients and multi-resolution analysis," Pattern Recognition,
%     vol. 46, no. 12, pp. 3256-3267, 2013.
% Author of the code: Rahul Das Gupta
% Date of creation: 11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on     :    
% Modification details :    
% Modified By    :    
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== % 
function angle=MaskedFindAngle(I,M)

I=double(I);

R=conv2(M,ones(3,3),'same');
L=(R==9);
[dIX dIY]=gradient(I);



G=[dIX(L) dIY(L)];
 

COV=cov(G);
%Principal Component Analysis
[eVector eVlaue]=eig(COV);
[max_eValue index]=max(diag(eVlaue));

angle=atan2(eVector(2,index),eVector(1,index))*180/pi;

end