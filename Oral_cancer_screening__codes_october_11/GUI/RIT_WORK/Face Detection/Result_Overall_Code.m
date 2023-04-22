clear all
load('Hausdorff_Overall_Viola_Optical.mat');

% M1=mean(IOU_Overall);
% M2=mean(E1_Overall);
% M3=mean(E2_Overall);
% 
% S1=std(IOU_Overall);
% S2=std(E1_Overall);
% S3=std(E2_Overall);

% Mean=mean(Dice_Ratio_Overall);
% STD=std(Dice_Ratio_Overall);

  M1=mean(Hausdorff_Overall);
  M2=mean(Modified_Hausdorff);
  
  S1=std(Hausdorff_Overall);
  S2=std(Modified_Hausdorff);
  
  
