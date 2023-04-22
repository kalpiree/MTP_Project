function FG = TexturalFeatureExtraction_RIGabor_HanAndMa(I,M,sacle_idx)

   M=double(M);
   [CI,CM]= ImageCropping(I,M);
   CI=double(CI);
   CM=double(CM);
  
%   [dIX_g,dIY_g]=gradient(CI); 
% 
%   L=logical(CM>0);
% 
%   E=circshift(L,[0,1]);E(:,1)=zeros(size(E,1),1);
%   W=circshift(L,[0,-1]);W(:,end)=zeros(size(W,1),1);
%   N=circshift(L,[-1,0]); N(end,:)=zeros(1,size(N,2));
%   S=circshift(L,[1,0]); S(1,:)=zeros(1,size(S,2));
%   
% 
%   W_CI=circshift(CI,[0,-1]); W_CI(:,end)=zeros(size(W_CI,1),1);
%   E_CI=circshift(CI,[0,1]); E_CI(:,1)=zeros(size(E_CI,1),1);
%   S_CI=circshift(CI,[1,0]); S_CI(1,:)=zeros(1,size(S_CI,2));
%   N_CI=circshift(CI,[-1,0]); N_CI(end,:)=zeros(1,size(N_CI,2));
%   
%   
%   dIX=dIX_g.*double(E.*L.*W)+(W_CI-CI).*double(~E.*L.*W)+(CI-E_CI).*double(E.*L.*~W);
%   dIY=dIY_g.*double(N.*L.*S)+(N_CI-CI).*double(N.*L.*~S)+(CI-S_CI).*double(~N.*L.*S);
%    
%   dIX1=dIY+eps;
%   dIY1=dIX+eps;
%   GM=sqrt(dIX1.^2+dIY1.^2);
%   GD=(atan2(dIY1,dIX1)+pi)*(180/pi);
%   Mean_GD=mean(GD(L));
%   GD_ZM=mod(GD-Mean_GD,360)*(pi/180);
   
%    Ul=0.05;
%    Uh=0.25;
%  Uh=0.08;
% Uh=0.1;
%   Uh=0.35;
%%%%
% Ul=0.01;
% Uh=0.08;
%%%%
Ul=0.01;
Uh=0.05;

%    S=4;
  S=sacle_idx;
   K=6;
   
   FG1=Masked_RIGaborFeatures(CI,CM,Ul,Uh,S,K);
%    FG2=Masked_RIGaborFeatures(GM,CM,Ul,Uh,S,K);
%    FG3=Masked_RIGaborFeatures(GD_ZM,CM,Ul,Uh,S,K);  
%    
%    FG=[FG1,FG2,FG3];
   
FG=FG1;
end


