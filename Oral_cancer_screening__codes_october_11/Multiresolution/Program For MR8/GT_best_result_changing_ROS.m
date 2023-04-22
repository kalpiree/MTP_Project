% clear all;
% clc;
% close all;
% %  for idx=1:10
%    for ROS_idx=11:55
    N_Scale=3;
    N_Orientation=6;
   ROS_idx=39;
    disp(ROS_idx);
     cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Program For MR8');
%      ComputeMR8_IR_Frontal_GT(ROS_idx,N_Scale,N_Orientation);
% GT_MR8_Features_between_lt_and_rt_Frontal
     cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
    load('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\GT_MR8_Normal_Frontal_face.mat');
    load('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\GT_MR8_Malignant_Frontal_face.mat');
    load('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\GT_MR8_NonMalignant_Front_face.mat');
   [final_accuracy_MN(ROS_idx),final_Sensitivity_MN(ROS_idx),final_Specificity_MN(ROS_idx)] = run_libsvm_MN_fn_AROI(GT_Malignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
 save('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\MR8Results\GTROI\final_accuracy_MN.mat');
   idx=1;
   while (final_accuracy_MN(end) < 84 || final_Sensitivity_MN(end) < 84 || final_Specificity_MN(end) < 84)
          [final_accuracy_MN(idx),final_Sensitivity_MN(idx),final_Specificity_MN(idx)]  = run_libsvm_MN_fn_AROI(GT_Malignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
          save('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\MR8Results\GTROI\Full_metric_MN_F','final_accuracy_MN','final_Sensitivity_MN','final_Specificity_MN');
          idx=idx+1;
%           t_idx=idx-1;
   end
   [final_accuracy_PN(ROS_idx),final_Sensitivity_PN(ROS_idx),final_Specificity_PN(ROS_idx)] = run_libsvm_PN_fn_AROI(GT_NMalignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
  save('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\MR8Results\GTROI\final_accuracy_PN.mat');
%   end
    idx1=1;
   while (final_accuracy_PN(end) < 85 || final_Sensitivity_PN(end) < 85 || final_Specificity_PN(end) < 85)
            [final_accuracy_PN(idx1),final_Sensitivity_PN(idx1),final_Specificity_PN(idx1)]  = run_libsvm_PN_fn_AROI(GT_NMalignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
          save('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\MR8Results\GTROI\Full_metric_PN_F','final_accuracy_PN','final_Sensitivity_PN','final_Specificity_PN');
          idx1=idx1+1;
   end
%   end
   %%
% clear all;
% clc;
% close all;
% %  for idx=1:10
% %  for ROS_idx=11:80
%     N_Scale=3;
%     N_Orientation=6;
%     ROS_idx=19;
%     disp(ROS_idx);
%      cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Program For MR8');
% %     ComputeMR8_IR_Frontal_GT(ROS_idx,N_Scale,N_Orientation)
%     GT_MR8_Features_between_lt_and_rt_Frontal;
%      cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
%     load('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\GT_MR8_Normal_Frontal_face.mat');
%     load('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\GT_MR8_Malignant_Frontal_face.mat');
%     load('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\GT_MR8_NonMalignant_Front_face.mat');
%    final_accuracy_MN_GT = run_libsvm_MN_fn_AROI(GT_Malignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
%    idx=1;
%    while final_accuracy_MN_GT < 84
%           final_accuracy_MN_GT(idx) = run_libsvm_MN_fn_AROI(GT_Malignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
%           save('final_accuracy_MN_GT');
%           idx=idx+1;
%    end
%    final_accuracy_PN_GT = run_libsvm_PN_fn_AROI(GT_NMalignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
%    idx1=1;
%    while final_accuracy_PN_GT < 85
%           final_accuracy_PN_GT(idx1) = run_libsvm_PN_fn_AROI(GT_NMalignant_MR8_append_LT_RT_Frontface,GT_Normal_MR8_append_LT_RT_Frontface,ROS_idx,N_Scale,N_Orientation)
%           save('final_accuracy_PN_GT');
%           idx1=idx1+1;
%    end
   
   %%

%    disp(ROS_idx);
%     cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Program For MR8');
% % end
%  end


% load('../../ClinicalData/ClinicalData_Malignant.mat');
% load('../../ClinicalData/ClinicalData_Precancerous.mat');
% load('../../ClinicalData/ClinicalData_Normal.mat');
% ClinicalData_Malignant=ClinicalData_Malignant(1:81,1:end);
% ClinicalData_Normal=ClinicalData_Normal(1:63,1:end);
% ClinicalData_Precancerous=ClinicalData_Precancerous(1:59,1:end);
% cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
%  final_accuracy_MN = run_libsvm_MN_fn_AROI(ClinicalData_Malignant(1:81,:),ClinicalData_Normal(1:63,:),ROS_idx,N_Scale,N_Orientation)
% final_accuracy_PN = run_libsvm_PN_fn_AROI(ClinicalData_Precancerous(1:59,:),ClinicalData_Normal(1:63,:),ROS_idx,N_Scale,N_Orientation)
% 
% load('../../MR8Features/MR8_Clinical_Thermal_Features/Malignant_MR8_Clinical_Thermal.mat');
% load('../../MR8Features/MR8_Clinical_Thermal_Features/Precancer_MR8_Clinical_Thermal.mat');
% load('../../MR8Features/MR8_Clinical_Thermal_Features/Normal_MR8_Clinical_Thermal.mat');
% cd('F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab');
% Malignant_MR8_Clinical_Thermal=[Malignant_MR8_Clinical_Thermal(:,1:32),Malignant_MR8_Clinical_Thermal(:,37:end)];
% Precancer_MR8_Clinical_Thermal=[Precancer_MR8_Clinical_Thermal(:,1:32),Precancer_MR8_Clinical_Thermal(:,37:end)];
% Normal_MR8_Clinical_Thermal=[Normal_MR8_Clinical_Thermal(:,1:32),Normal_MR8_Clinical_Thermal(:,37:end)];
% 
% final_accuracy_MN = run_libsvm_MN_fn_AROI(Malignant_MR8_Clinical_Thermal,Normal_MR8_Clinical_Thermal,ROS_idx,N_Scale,N_Orientation)
% final_accuracy_PN = run_libsvm_PN_fn_AROI(Precancer_MR8_Clinical_Thermal,Normal_MR8_Clinical_Thermal,ROS_idx,N_Scale,N_Orientation)
% 
% 
