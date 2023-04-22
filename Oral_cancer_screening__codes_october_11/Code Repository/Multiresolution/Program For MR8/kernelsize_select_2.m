clear;
kernel_idx=1;
  for ROS_idx=5:2:65%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AROI frontal %%%%%%%%%%%%%%%%%%%%%%%%%
    N_Scale=3;
    N_Orientation=6;
    disp(ROS_idx);
     cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Program For MR8');
     ComputeMR8_IR_Frontal_AROI(ROS_idx,N_Scale,N_Orientation);
     AROI_MR8_Features_between_lt_and_rt_Frontal(ROS_idx)
    cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
    load(['F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\Full_AROI_MR8_Normal_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
    load(['F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\Full_AROI_MR8_Malignant_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
    load(['F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\Full_AROI_MR8_NonMalignant_Front_face_ROS_',num2str(ROS_idx),'.mat']);
    AROI_Full_Malignant_allKernel(:,:,kernel_idx)=AROI_Malignant_MR8_append_LT_RT_Frontface;
    AROI_Full_Normal_allKernel(:,:,kernel_idx)=AROI_Normal_MR8_append_LT_RT_Frontface;
    AROI_Full_NonMalignant_allKernel(:,:,kernel_idx)=AROI_NMalignant_MR8_append_LT_RT_Frontface;
    kernel_idx=kernel_idx+1;



  end 
%   cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
  cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel\oncemore');

  save('AROI_Full_Malignant_allKernel','AROI_Full_Malignant_allKernel');
    save('AROI_Full_Normal_allKernel','AROI_Full_Normal_allKernel');
  save('AROI_Full_NonMalignant_allKernel','AROI_Full_NonMalignant_allKernel');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
% ROS_idx=5:2:65;
% N_Scale=3;
% N_Orientation=6;
%  load('GT_Age_Malignant_allKernel','GT_Age_Malignant_allKernel');
%  load('GT_Age_Normal_allKernel','GT_Age_Normal_allKernel');
%  load('GT_Age_NonMalignant_allKernel','GT_Age_NonMalignant_allKernel');
%  viz_case='GT_Age_MN'
% [AgeAdjust_final_accuracy_MN(ROS_idx),AgeAdjust_final_Sensitivity_MN(ROS_idx),AgeAdjust_final_Specificity_MN(ROS_idx)] = run_libsvm_MN_fn_GT_AgeAdjust(GT_Age_Malignant_allKernel,GT_Age_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case);
%  viz_case='GT_Age_PN'
% [AgeAdjust_final_accuracy_PN(ROS_idx),AgeAdjust_final_Sensitivity_PN(ROS_idx),AgeAdjust_final_Specificity_PN(ROS_idx)] = run_libsvm_PN_fn_GT_AgeAdjust(GT_Age_NonMalignant_allKernel,GT_Age_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case)
% 
% 
% 
%%
%Classification automated roi
%   cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
% 
%  load('AROI_AgeAdjust_Malignant_allKernel','AROI_AgeAdjust_Malignant_allKernel');
%  load('AROI_AgeAdjust_Normal_allKernel','AROI_AgeAdjust_Normal_allKernel');
%  load('AROI_AgeAdjust_NonMalignant_allKernel','AROI_AgeAdjust_NonMalignant_allKernel');
%  cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
%   ROS_idx=5:2:65;
% N_Scale=3;
% N_Orientation=6;
%  viz_case='AROI_AgeAdjust_MN'
%  [AgeAdjust_final_accuracy_MN,AgeAdjust_final_Sensitivity_MN,AgeAdjust_final_Specificity_MN] = run_libsvm_MN_fn_AROI_AgeAdjust(AROI_AgeAdjust_Malignant_allKernel,AROI_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case);
% 
%  while AgeAdjust_final_accuracy_MN <78
% [AgeAdjust_final_accuracy_MN,AgeAdjust_final_Sensitivity_MN,AgeAdjust_final_Specificity_MN] = run_libsvm_MN_fn_AROI_AgeAdjust(AROI_AgeAdjust_Malignant_allKernel,AROI_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case);
%  end
%  viz_case='AROI_AgeAdjust_PN'
%  [AgeAdjust_final_accuracy_PN,AgeAdjust_final_Sensitivity_PN,AgeAdjust_final_Specificity_PN] = run_libsvm_PN_fn_AROI_AgeAdjust(AROI_AgeAdjust_NonMalignant_allKernel,AROI_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case)
% 
%  while AgeAdjust_final_accuracy_PN <79
% [AgeAdjust_final_accuracy_PN,AgeAdjust_final_Sensitivity_PN,AgeAdjust_final_Specificity_PN] = run_libsvm_PN_fn_AROI_AgeAdjust(AROI_AgeAdjust_NonMalignant_allKernel,AROI_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case)
%  end
%%
%Classification ground truth ROI


% cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
% 
%  load('GT_AgeAdjust_Malignant_allKernel','GT_AgeAdjust_Malignant_allKernel');
%  load('GT_AgeAdjust_Normal_allKernel','GT_AgeAdjust_Normal_allKernel');
%  load('GT_AgeAdjust_NonMalignant_allKernel','GT_AgeAdjust_NonMalignant_allKernel');
%  cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
%   ROS_idx=5:2:65;
% N_Scale=3;
% N_Orientation=6;
% %  viz_case='GT_AgeAdjust_MN'
% %  [AgeAdjust_final_accuracy_MN,AgeAdjust_final_Sensitivity_MN,AgeAdjust_final_Specificity_MN] = run_libsvm_MN_fn_GT_AgeAdjust(GT_AgeAdjust_Malignant_allKernel,GT_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case);
% % 
% %  while AgeAdjust_final_accuracy_MN <78
% % [AgeAdjust_final_accuracy_MN,AgeAdjust_final_Sensitivity_MN,AgeAdjust_final_Specificity_MN] = run_libsvm_MN_fn_GT_AgeAdjust(GT_AgeAdjust_Malignant_allKernel,GT_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case);
% %  end
%  viz_case='GT_AgeAdjust_PN'
%  [AgeAdjust_final_accuracy_PN,AgeAdjust_final_Sensitivity_PN,AgeAdjust_final_Specificity_PN] = run_libsvm_PN_fn_GT_AgeAdjust(GT_AgeAdjust_NonMalignant_allKernel,GT_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case)
% 
%  while AgeAdjust_final_accuracy_PN <79
% [AgeAdjust_final_accuracy_PN,AgeAdjust_final_Sensitivity_PN,AgeAdjust_final_Specificity_PN] = run_libsvm_PN_fn_GT_AgeAdjust(GT_AgeAdjust_NonMalignant_allKernel,GT_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case)
%  end
% 




%%

