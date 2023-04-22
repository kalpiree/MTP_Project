function FG = TexturalFeatureExtraction_IGMGD_MR8(I,M,ROS_idx,N_Scale,N_Orientation)

   M=double(M);
   [CI,CM]= ImageCropping(I,M);
   CI=double(CI);
   CM=double(CM);
   
   %[GM,GD_Std]=GradientMagnitudeAndDirection(CI,CM);
     
   F_I=Masked_MR8_Features(CI,CM,ROS_idx,N_Scale,N_Orientation); % Intensity
   %F_GM=Masked_MR8_Features(GM,CM); 
   %F_GD=Masked_MR8_Features(GD_Std,CM);  
   
   
   %FG=[F_I, F_GM, F_GD];
   FG=F_I;
   
end


function [GM,GD_Std]=GradientMagnitudeAndDirection(I,M)
 
  [dIX_g,dIY_g]=gradient(I); 

  L=logical(M>0);

  E=circshift(L,[0,1]);E(:,1)=zeros(size(E,1),1);
  W=circshift(L,[0,-1]);W(:,end)=zeros(size(W,1),1);
  N=circshift(L,[-1,0]); N(end,:)=zeros(1,size(N,2));
  S=circshift(L,[1,0]); S(1,:)=zeros(1,size(S,2));
  

  W_I=circshift(I,[0,-1]); W_I(:,end)=zeros(size(W_I,1),1);
  E_I=circshift(I,[0,1]); E_I(:,1)=zeros(size(E_I,1),1);
  S_I=circshift(I,[1,0]); S_I(1,:)=zeros(1,size(S_I,2));
  N_I=circshift(I,[-1,0]); N_I(end,:)=zeros(1,size(N_I,2));
  
  
  dIX=dIX_g.*double(E.*L.*W)+(W_I-I).*double(~E.*L.*W)+(I-E_I).*double(E.*L.*~W);
  dIY=dIY_g.*double(N.*L.*S)+(N_I-I).*double(N.*L.*~S)+(I-S_I).*double(~N.*L.*S);
   
  dIX1=dIY+eps;
  dIY1=dIX+eps;
  GM=sqrt(dIX1.^2+dIY1.^2);
  GD=(atan2(dIY1,dIX1)+pi)*(180/pi);
  L=logical(M>0);
  %Mean_GD=mean(GD(L));
  A=MaskedFindAngle(I,M);
  GD_Std=mod(GD-A,360)*(pi/180);
   
end

