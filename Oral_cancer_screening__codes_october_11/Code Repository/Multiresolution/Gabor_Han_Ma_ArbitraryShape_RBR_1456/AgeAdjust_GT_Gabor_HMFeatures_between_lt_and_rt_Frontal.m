% =========================== AgeAdjusted_GT_Gabor_HMFeatures_between_lt_and_rt_Frontal.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                   AgeAdjust_GT_Precancer_Gabor_HM_Diff_LT_RT_Frontface   
%                   AgeAdjust_GT_Precancer_Gabor_HM_mean_LT_RT_Frontface 
%                   AgeAdjust_GT_Precancer_Gabor_HM_append_LT_RT_Frontface
%                   AgeAdjust_GT_Malignant_Gabor_HM_Diff_LT_RT_Frontface   
%                   AgeAdjust_GT_Malignant_Gabor_HM_mean_LT_RT_Frontface 
%                   AgeAdjust_GT_Malignant_Gabor_HM_append_LT_RT_Frontface
%                   AgeAdjust_GT_Normal_Gabor_HM_Diff_LT_RT_Frontface   
%                   AgeAdjust_GT_Normal_Gabor_HM_mean_LT_RT_Frontface 
%                   AgeAdjust_GT_Normal_Gabor_HM_append_LT_RT_Frontface
%                    
%                  
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : Nil
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] to be written

% Author of the code: Manashi Chakraborty
% Date of creation :    
% ------------------------------------------------------------------------------------------------------- %
% Modified on :   
% Modification details:    
% Modified By :  Manashi Chakraborty
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %


function AgeAdjust_GT_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx)

close all;
%%
 %Normal
d = dir('..\..\..\ThermalDatabase\Normal_AgeAdjust');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\Normal_AgeAdjust\' nameFolds{folder_idx} '\' ];
cd([rel_path 'AgeAdjust_GT_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx}]);
load('AgeAdjust_GT_Gabor_H&M_Normal_Front.mat')
GT_Normal_Gabor_HM_FrontalLTface(error_idx,:)=GT_gabor_F_normal_lt';
GT_Normal_Gabor_HM_FrontalRTface(error_idx,:)=GT_gabor_F_normal_rt';
GT_Normal_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(GT_Normal_Gabor_HM_FrontalLTface(error_idx,:)-GT_Normal_Gabor_HM_FrontalRTface(error_idx,:));
GT_Normal_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(GT_Normal_Gabor_HM_FrontalLTface(error_idx,:)+GT_Normal_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
GT_Normal_Gabor_HM_append_LT_RT_Frontface=[GT_Normal_Gabor_HM_FrontalLTface GT_Normal_Gabor_HM_FrontalRTface];
save(['..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'GT_Normal_Gabor_HM_Diff_LT_RT_Frontface','GT_Normal_Gabor_HM_mean_LT_RT_Frontface','GT_Normal_Gabor_HM_append_LT_RT_Frontface');
%%
 %Malignant
d = dir('..\..\..\ThermalDatabase\Malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\Malignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\AgeAdjust_GT_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx}]);
load('AgeAdjust_GT_Gabor_H&M_Malignant_Front.mat')
GT_Malignant_Gabor_HM_FrontalLTface(error_idx,:)=GT_gabor_F_malignant_lt';
GT_Malignant_Gabor_HM_FrontalRTface(error_idx,:)=GT_gabor_F_malignant_rt';
GT_Malignant_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(GT_Malignant_Gabor_HM_FrontalLTface(error_idx,:)-GT_Malignant_Gabor_HM_FrontalRTface(error_idx,:));
GT_Malignant_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(GT_Malignant_Gabor_HM_FrontalLTface(error_idx,:)+GT_Malignant_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
GT_Malignant_Gabor_HM_append_LT_RT_Frontface=[GT_Malignant_Gabor_HM_FrontalLTface GT_Malignant_Gabor_HM_FrontalRTface];
save(['..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'GT_Malignant_Gabor_HM_Diff_LT_RT_Frontface','GT_Malignant_Gabor_HM_mean_LT_RT_Frontface' ,'GT_Malignant_Gabor_HM_append_LT_RT_Frontface');

%%
%  %Precancerous
d = dir('..\..\..\ThermalDatabase\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\AgeAdjust_GT_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}]);
load('AgeAdjust_GT_Gabor_H&M_precancer_Front.mat')
GT_Precancer_Gabor_HM_FrontalLTface(error_idx,:)=GT_gabor_F_precancer_lt';
GT_Precancer_Gabor_HM_FrontalRTface(error_idx,:)=GT_gabor_F_precancer_rt';
GT_Precancer_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(GT_Precancer_Gabor_HM_FrontalLTface(error_idx,:)-GT_Precancer_Gabor_HM_FrontalRTface(error_idx,:));
GT_Precancer_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(GT_Precancer_Gabor_HM_FrontalLTface(error_idx,:)+GT_Precancer_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
GT_Precancer_Gabor_HM_append_LT_RT_Frontface=[GT_Precancer_Gabor_HM_FrontalLTface GT_Precancer_Gabor_HM_FrontalRTface];
save(['..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'GT_Precancer_Gabor_HM_Diff_LT_RT_Frontface','GT_Precancer_Gabor_HM_mean_LT_RT_Frontface' ,'GT_Precancer_Gabor_HM_append_LT_RT_Frontface');
end