% =====================Evaluation_Of_Retrieval_Performance_WithoutIF.m ============================= %
% Description  :

% It will generate Feature Vectors by analysing the Spatial Distributions of
% intensity (I), gradient magnitude (GM) and  gradient direcion (GD)
% corresponding to all images of arbitrary shape having a well defined ROI 
%(Region of Interest) using Gabor filters in the following  way: 

%  Feature Extraction After Alignment: 
%     Evaluating texture features with respect to some standard direction 
%     called Principal Texture Direction.


% It compute all possible pairs of distance between images (in the form of Distance 
% Matrix).

% Finally evaluate Average Percentage Recall and area under PR-curves 
% corresponding to following 7 combination of fundamental image profiles:
% I, GM, GD, I+GM, I+GD, GM+GD and I+GM+GD
% ====================================================================================%
% Input parameter :  Nothing  
% Output parameter:  Nothing  
% Subroutine  called : 
%             #1: TexturalFeatureExtraction
%             #2: CityBlockDist
%             #3: Recall
%             #4: AreaOfPrecisionVsRecallCurve

% Called by :  None (Main Program)
% Reference:    

% Author of the code:  Rahul Das Gupta  
% Date of creation :    11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    12-03-2016
% Modification details:    
% Modified By :   Rahul Das Gupta 
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
tic;
clc;
clear;

while 1
  s=input(['Press \n 1 for Rotated Brodatz Texture Database',... 
              '\n 2 for Non rotated Brodatz Texture Database',...
              '\n 3 for UIUC Texture Database',...
              '\n 4 for Outex Texture Database',...
              '\n Enter your choice (1-4):']); 
  if s==1 || s==2 || s==3 || s==4
       break;
  else
      clc
      disp('Wrong choice. Input your choice correctly again !!')
  end       
end


if s==1         
   N=1456;
   N_Class=13;
   N_Sample_Per_Class=112;
   N_Relevant=111;
 
elseif s==2
   N=2675;
   N_Class=107;
   N_Sample_Per_Class=25;
   N_Relevant=24;
  
elseif s==3
   N=4000;
   N_Class=25;
   N_Sample_Per_Class=160;
   N_Relevant=159;
 
elseif s==4
   N=6380;
   N_Class=319;
   N_Sample_Per_Class=20;
   N_Relevant=19;
   
end

    

LG=48;

FM_A=zeros(N,LG);


for i=1:N
         Mask_No= mod(i-1,N_Sample_Per_Class)+1;
         if s==1
             Input=strcat('../RBR_1456/Images/Tex (',num2str(i),').tiff');
             Im_Mask=strcat('../RBR_1456/Masks/Mask (',num2str(Mask_No),').tif');
         elseif s==2
             Input=strcat('../NBR_2675/Images/X_Tex (',num2str(i),').tiff');
             Im_Mask=strcat('../NBR_2675/Masks/Mask (',num2str(Mask_No),').tif');
         elseif s==3
             Input=strcat('../UIUC_4000/Images/Tex (',num2str(i),').tiff');
             Im_Mask=strcat('../UIUC_4000/Masks/Mask (',num2str(Mask_No),').tif');
         elseif s==4
             k=i-1;
             Input=strcat('../Outex_6380/Images/',num2str(k,'%06i'),'.ras');
             Im_Mask=strcat('../Outex_6380/Masks/Mask (',num2str(Mask_No),').tif');
         end
         
         I=double(imread(Input));        
         Mask=double(imread(Im_Mask));
         
         M=Mask(:,:,1);
         MAX=max(M(:));
         M=M./MAX;    % M = Binary mask to define ROI (Region of Interest)


         I=double(I);
         
         FG_A=TexturalFeatureExtraction_IGMGD_MR8(I,M);
                
         % Feature vector derived from analysis of spatial distribution
         % of intensity (I), gradient magnitude (GM) and 
         % gradient direction (GD) using Gabor filter after alignment.
                  
         FM_A(i,:)=FG_A; 
         
         clc;
         i
end



FM1_A=FM_A;

SDG_A=sqrt(var(FM_A));

% Normalisation of features
for i=1:N
         
    for j=1:LG
         if SDG_A(j)==0 
               FM1_A(i,j)=FM_A(i,j)/0.00000000001; % to avoid zero division error
         else
               FM1_A(i,j)=FM_A(i,j)/SDG_A(j);
         end   
    end
    
end

%======= Feature derived from I ===%
Dist_Matrix_I=zeros(N,N);

for i=1:N
    for j=1:N
                              
           FX_A=FM1_A(i,1:LG/3);
           FY_A=FM1_A(j,1:LG/3);
           
           Dist_Matrix_I(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_I Dist_Matrix_I;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_I Dist_Matrix_I;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_I Dist_Matrix_I;  
elseif s==4   
   save ../Outex_6380/Result_MR8/DistanceMatrix_I Dist_Matrix_I;
end

%======= Feature derived from GM ===%
Dist_Matrix_GM=zeros(N,N);
for i=1:N
    for j=1:N
        
           FX_A=FM1_A(i,LG/3+1:2*LG/3);
           FY_A=FM1_A(j,LG/3+1:2*LG/3);
           
           Dist_Matrix_GM(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_GM Dist_Matrix_GM;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_GM Dist_Matrix_GM;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_GM Dist_Matrix_GM;  
elseif s==4   
   save ../Outex_6380/Result_MR8/DistanceMatrix_GM Dist_Matrix_GM;
end

%======= Feature derived from GD ===%
Dist_Matrix_GD=zeros(N,N);
for i=1:N
    for j=1:N
          
           FX_A=FM1_A(i,2*LG/3+1:LG);
           FY_A=FM1_A(j,2*LG/3+1:LG);
                      
           Dist_Matrix_GD(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_GD Dist_Matrix_GD;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_GD Dist_Matrix_GD;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_GD Dist_Matrix_GD;  
elseif s==4   
   save ../Outex_6380/Result_MR8/DistanceMatrix_GD Dist_Matrix_GD;
end

%======= Feature derived from I+GM ===%
Dist_Matrix_IGM=zeros(N,N);
for i=1:N
    for j=1:N
           
           FX_A=FM1_A(i,[1:LG/3 LG/3+1:2*LG/3]);
           FY_A=FM1_A(j,[1:LG/3 LG/3+1:2*LG/3]);
           
           Dist_Matrix_IGM(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_IGM Dist_Matrix_IGM;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_IGM Dist_Matrix_IGM;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_IGM Dist_Matrix_IGM;  
elseif s==4   
   save ../Outex_6380/Result_MR8/DistanceMatrix_IGM Dist_Matrix_IGM;
end

%======= Feature derived from I+GD ===%
Dist_Matrix_IGD=zeros(N,N);
for i=1:N
    for j=1:N
           
           FX_A=FM1_A(i,[1:LG/3 2*LG/3+1:LG]);
           FY_A=FM1_A(j,[1:LG/3 2*LG/3+1:LG]);
           
           Dist_Matrix_IGD(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_IGD Dist_Matrix_IGD;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_IGD Dist_Matrix_IGD;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_IGD Dist_Matrix_IGD;  
elseif s==4   
   save ../Outex_6380/Result_MR8/DistanceMatrix_IGD Dist_Matrix_IGD;
end

%======= Feature derived from GM+GD ===%
Dist_Matrix_GMGD=zeros(N,N);
for i=1:N
    for j=1:N
           
           FX_A=FM1_A(i,[LG/3+1:2*LG/3 2*LG/3+1:LG]);
           FY_A=FM1_A(j,[LG/3+1:2*LG/3 2*LG/3+1:LG]);
           
           Dist_Matrix_GMGD(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_GMGD Dist_Matrix_GMGD;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_GMGD Dist_Matrix_GMGD;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_GMGD Dist_Matrix_GMGD;  
elseif s==4   
   save ../Outex_6380/Result_MR8/DistanceMatrix_GMGD Dist_Matrix_GMGD;
end

%======= Feature derived from I+GM+GD ===%
Dist_Matrix_IGMGD=zeros(N,N);
for i=1:N
    for j=1:N
           
           
           FX_A=FM1_A(i,:);
           FY_A=FM1_A(j,:);
           
           Dist_Matrix_IGMGD(i,j)=CityBlockDist(FX_A,FY_A);
    end
end
if s==1
   save ../RBR_1456/Result_MR8/DistanceMatrix_IGMGD Dist_Matrix_IGMGD;
elseif s==2
   save ../NBR_2675/Result_MR8/DistanceMatrix_IGMGD Dist_Matrix_IGMGD;
elseif s==3   
   save ../UIUC_4000/Result_MR8/DistanceMatrix_IGMGD Dist_Matrix_IGMGD;  
elseif s==4   
   save ./Outex_6380/Result_MR8/DistanceMatrix_IGMGD Dist_Matrix_IGMGD;
end


Percentage=125;

[R1,P1,CR1,CP1,VR1,VP1,AR1,AP1]=Recall(Dist_Matrix_I,N_Class,Percentage);
[R2,P2,CR2,CP2,VR2,VP2,AR2,AP2]=Recall(Dist_Matrix_GM,N_Class,Percentage);
[R3,P3,CR3,CP3,VR3,VP3,AR3,AP3]=Recall(Dist_Matrix_GD,N_Class,Percentage);
[R4,P4,CR4,CP4,VR4,VP4,AR4,AP4]=Recall(Dist_Matrix_IGM,N_Class,Percentage);
[R5,P5,CR5,CP5,VR5,VP5,AR5,AP5]=Recall(Dist_Matrix_IGD,N_Class,Percentage);
[R6,P6,CR6,CP6,VR6,VP6,AR6,AP6]=Recall(Dist_Matrix_GMGD,N_Class,Percentage);
[R7,P7,CR7,CP7,VR7,VP7,AR7,AP7]=Recall(Dist_Matrix_IGMGD,N_Class,Percentage);


RecallMatrix=[AR1,AR2,AR3,AR4,AR5,AR6,AR7]

if s==1
   save ../RBR_1456/Result_MR8/PercentageRecallMatrix RecallMatrix;
elseif s==2
   save ../NBR_2675/Result_MR8/PercentageRecallMatrix RecallMatrix;
elseif s==3   
   save ../UIUC_4000/Result_MR8/PercentageRecallMatrix RecallMatrix;  
elseif s==4   
   save ../Outex_6380/Result_MR8/PercentageRecallMatrix RecallMatrix;
end

save PercentageRecallMatrix RecallMatrix;

A_WithoutIF=AreaOfPrecisionVsRecallCurve(Dist_Matrix_I,Dist_Matrix_GM,...
  Dist_Matrix_GD,Dist_Matrix_IGM,Dist_Matrix_IGD,Dist_Matrix_GMGD,...                               
  Dist_Matrix_IGMGD,N_Class)

if s==1
   save ../RBR_1456/Result_MR8/Area_WithoutFusion A_WithoutIF;
elseif s==2
   save ../NBR_2675/Result_MR8/Area_WithoutFusion A_WithoutIF;
elseif s==3   
   save ../UIUC_4000/Result_MR8/Area_WithoutFusion A_WithoutIF;  
elseif s==4   
   save ../Outex_6380/Result_MR8/Area_WithoutFusion A_WithoutIF;
end


toc;
