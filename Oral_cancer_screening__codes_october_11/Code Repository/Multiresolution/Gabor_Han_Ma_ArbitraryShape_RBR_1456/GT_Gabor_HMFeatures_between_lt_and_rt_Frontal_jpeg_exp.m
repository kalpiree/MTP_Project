% =========================== GT_Gabor_HMFeatures_between_lt_and_rt_Frontal.m ====================================== %
% Description : All features for each image are combined to a single 2-D matrix. 
% their difference and mean is calculated , their lt and rt features ae appened and stored 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                   GT_Precancer_Gabor_HM_Diff_LT_RT_Frontface   
%                   GT_Precancer_Gabor_HM_mean_LT_RT_Frontface 
%                   GT_Precancer_Gabor_HM_append_LT_RT_Frontface
%                   GT_Malignant_Gabor_HM_Diff_LT_RT_Frontface   
%                   GT_Malignant_Gabor_HM_mean_LT_RT_Frontface 
%                   GT_Malignant_Gabor_HM_append_LT_RT_Frontface
%                   GT_Normal_Gabor_HM_Diff_LT_RT_Frontface   
%                   GT_Normal_Gabor_HM_mean_LT_RT_Frontface 
%                   GT_Normal_Gabor_HM_append_LT_RT_Frontface
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



function GT_Gabor_HMFeatures_between_lt_and_rt_Frontal_jpeg_exp(sacle_idx)
close all;
%%

 %Normal
d = dir('..\..\..\Thermal db\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
%%%merge all features into a single matrix
for folder_idx=1:12
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\Thermal db\Normal\' nameFolds{folder_idx} '\' ];
cd([rel_path 'GT_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx}]);
load('GT_Gabor_H&M_Normal_Front.mat')
GT_Normal_Gabor_HM_FrontalLTface(error_idx,:)=GT_gabor_F_normal_lt';
GT_Normal_Gabor_HM_FrontalRTface(error_idx,:)=GT_gabor_F_normal_rt';
GT_Normal_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(GT_Normal_Gabor_HM_FrontalLTface(error_idx,:)-GT_Normal_Gabor_HM_FrontalRTface(error_idx,:));
GT_Normal_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(GT_Normal_Gabor_HM_FrontalLTface(error_idx,:)+GT_Normal_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Append the features
GT_Normal_Gabor_HM_append_LT_RT_Frontface=[GT_Normal_Gabor_HM_FrontalLTface GT_Normal_Gabor_HM_FrontalRTface];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save(['..\GaborFeatures_HM_allScale\GT_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'GT_Normal_Gabor_HM_Diff_LT_RT_Frontface','GT_Normal_Gabor_HM_mean_LT_RT_Frontface','GT_Normal_Gabor_HM_append_LT_RT_Frontface');
%%
 %Malignant
d = dir('..\..\..\Thermal db\Malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
%%%merge all features into a single matrix
for folder_idx=1:12
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\Thermal db\Malignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx}]);
load('GT_Gabor_H&M_Malignant_Front.mat')
GT_Malignant_Gabor_HM_FrontalLTface(error_idx,:)=GT_gabor_F_malignant_lt';
GT_Malignant_Gabor_HM_FrontalRTface(error_idx,:)=GT_gabor_F_malignant_rt';
GT_Malignant_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(GT_Malignant_Gabor_HM_FrontalLTface(error_idx,:)-GT_Malignant_Gabor_HM_FrontalRTface(error_idx,:));
GT_Malignant_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(GT_Malignant_Gabor_HM_FrontalLTface(error_idx,:)+GT_Malignant_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Append the features
GT_Malignant_Gabor_HM_append_LT_RT_Frontface=[GT_Malignant_Gabor_HM_FrontalLTface GT_Malignant_Gabor_HM_FrontalRTface];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save(['..\GaborFeatures_HM_allScale\GT_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'GT_Malignant_Gabor_HM_Diff_LT_RT_Frontface','GT_Malignant_Gabor_HM_mean_LT_RT_Frontface' ,'GT_Malignant_Gabor_HM_append_LT_RT_Frontface');

%%
%  %Precancerous
d = dir('..\..\..\Thermal db\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
%%%merge all features into a single matrix
for folder_idx=1:12
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\Thermal db\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}]);
load('GT_Gabor_H&M_precancer_Front.mat')
GT_Precancer_Gabor_HM_FrontalLTface(error_idx,:)=GT_gabor_F_precancer_lt';
GT_Precancer_Gabor_HM_FrontalRTface(error_idx,:)=GT_gabor_F_precancer_rt';
GT_Precancer_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(GT_Precancer_Gabor_HM_FrontalLTface(error_idx,:)-GT_Precancer_Gabor_HM_FrontalRTface(error_idx,:));
GT_Precancer_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(GT_Precancer_Gabor_HM_FrontalLTface(error_idx,:)+GT_Precancer_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Append the features
GT_Precancer_Gabor_HM_append_LT_RT_Frontface=[GT_Precancer_Gabor_HM_FrontalLTface GT_Precancer_Gabor_HM_FrontalRTface];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save(['..\GaborFeatures_HM_allScale\GT_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'GT_Precancer_Gabor_HM_Diff_LT_RT_Frontface','GT_Precancer_Gabor_HM_mean_LT_RT_Frontface' ,'GT_Precancer_Gabor_HM_append_LT_RT_Frontface');
end