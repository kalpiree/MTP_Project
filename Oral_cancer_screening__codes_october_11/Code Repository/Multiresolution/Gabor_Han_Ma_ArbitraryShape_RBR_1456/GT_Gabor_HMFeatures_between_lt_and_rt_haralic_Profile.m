% =========================== GT_Gabor_HMFeatures_between_lt_and_rt_Profile.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                   GT_Precancer_Gabor_HM_Diff_LT_RT_Profileface   
%                   GT_Precancer_Gabor_HM_mean_LT_RT_Profileface 
%                   GT_Precancer_Gabor_HM_append_LT_RT_Profileface
%                   GT_Malignant_Gabor_HM_Diff_LT_RT_Profileface  
%                   GT_Malignant_Gabor_HM_mean_LT_RT_Profileface
%                   GT_Malignant_Gabor_HM_append_LT_RT_Profileface
%                   GT_Normal_Gabor_HM_Diff_LT_RT_Profileface 
%                   GT_Normal_Gabor_HM_mean_LT_RT_Profileface 
%                   GT_Normal_Gabor_HM_append_LT_RT_Profileface
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



function GT_Gabor_HMFeatures_between_lt_and_rt_haralic_Profile(sacle_idx)
close all;
%%
 %Normal
d = dir('..\..\..\ThermalDatabase\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\Normal\' nameFolds{folder_idx} '\' ];
cd([rel_path 'GT_Gabor_Han&Ma_Normal_Profile_' nameFolds{folder_idx}]);
load('GT_Gabor_H&M_Normal_Profile.mat')
GT_Normal_Gabor_HM_ProfileLTface(error_idx,:)=GT_gabor_P_normal_lt';
GT_Normal_Gabor_HM_ProfileRTface(error_idx,:)=GT_gabor_P_normal_rt';
GT_Normal_Gabor_HM_Diff_LT_RT_Profileface(error_idx,:)=abs(GT_Normal_Gabor_HM_ProfileLTface(error_idx,:)-GT_Normal_Gabor_HM_ProfileRTface(error_idx,:));
GT_Normal_Gabor_HM_mean_LT_RT_Profileface(error_idx,:)=(GT_Normal_Gabor_HM_ProfileLTface(error_idx,:)+GT_Normal_Gabor_HM_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
GT_Normal_Gabor_HM_append_LT_RT_Profileface=[GT_Normal_Gabor_HM_ProfileLTface GT_Normal_Gabor_HM_ProfileRTface];
save(['..\GaborFeatures_HM_allScale\GT_Gabor_HM_Normal_Profile_face_scale_',num2str(sacle_idx),'.mat'],'GT_Normal_Gabor_HM_Diff_LT_RT_Profileface','GT_Normal_Gabor_HM_mean_LT_RT_Profileface','GT_Normal_Gabor_HM_append_LT_RT_Profileface');
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
cd([rel_path 'GT_Gabor_Han&Ma_Malignant_Profile_' nameFolds{folder_idx}]);
load('GT_Gabor_H&M_Malignant_Profile.mat')
GT_Malignant_Gabor_HM_ProfileLTface(error_idx,:)=GT_gabor_P_malignant_lt';
GT_Malignant_Gabor_HM_ProfileRTface(error_idx,:)=GT_gabor_P_malignant_rt';
GT_Malignant_Gabor_HM_Diff_LT_RT_Profileface(error_idx,:)=abs(GT_Malignant_Gabor_HM_ProfileLTface(error_idx,:)-GT_Malignant_Gabor_HM_ProfileRTface(error_idx,:));
GT_Malignant_Gabor_HM_mean_LT_RT_Profileface(error_idx,:)=(GT_Malignant_Gabor_HM_ProfileLTface(error_idx,:)+GT_Malignant_Gabor_HM_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
GT_Malignant_Gabor_HM_append_LT_RT_Profileface=[GT_Malignant_Gabor_HM_ProfileLTface GT_Malignant_Gabor_HM_ProfileRTface];
save(['..\GaborFeatures_HM_allScale\GT_Gabor_HM_Malignant_Profile_face_scale_',num2str(sacle_idx),'.mat'],'GT_Malignant_Gabor_HM_Diff_LT_RT_Profileface','GT_Malignant_Gabor_HM_mean_LT_RT_Profileface' ,'GT_Malignant_Gabor_HM_append_LT_RT_Profileface');

%%
 %Precancerous
d = dir('..\..\..\ThermalDatabase\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path 'GT_Gabor_Han&Ma_precancer_Profile_' nameFolds{folder_idx}]);
load('GT_Gabor_H&M_precancer_Profile.mat')
GT_Precancer_Gabor_HM_ProfileLTface(error_idx,:)=GT_gabor_P_precancer_lt';
GT_Precancer_Gabor_HM_ProfileRTface(error_idx,:)=GT_gabor_P_precancer_rt';
GT_Precancer_Gabor_HM_Diff_LT_RT_Profileface(error_idx,:)=abs(GT_Precancer_Gabor_HM_ProfileLTface(error_idx,:)-GT_Precancer_Gabor_HM_ProfileRTface(error_idx,:));
GT_Precancer_Gabor_HM_mean_LT_RT_Profileface(error_idx,:)=(GT_Precancer_Gabor_HM_ProfileLTface(error_idx,:)+GT_Precancer_Gabor_HM_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
GT_Precancer_Gabor_HM_append_LT_RT_Profileface=[GT_Precancer_Gabor_HM_ProfileLTface GT_Precancer_Gabor_HM_ProfileRTface];
save(['..\GaborFeatures_HM_allScale\GT_Gabor_HM_Precancer_Profile_face_scale_',num2str(sacle_idx),'.mat'],'GT_Precancer_Gabor_HM_Diff_LT_RT_Profileface','GT_Precancer_Gabor_HM_mean_LT_RT_Profileface' ,'GT_Precancer_Gabor_HM_append_LT_RT_Profileface');
end