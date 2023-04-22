
% =========================== AROI_Gabor_HMFeatures_between_lt_and_rt_Frontal.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                   AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface   
%                   AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface 
%                   AROI_Precancer_Gabor_HM_append_LT_RT_Frontface
%                   AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface   
%                   AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface 
%                   AROI_Malignant_Gabor_HM_append_LT_RT_Frontface
%                   AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface   
%                   AROI_Normal_Gabor_HM_mean_LT_RT_Frontface 
%                   AROI_Normal_Gabor_HM_append_LT_RT_Frontface
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

function AROI_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx)

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
cd([rel_path 'AROI_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx}]);
load('AROI_Gabor_H&M_Normal_Front.mat')
AROI_Normal_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_normal_lt';
AROI_Normal_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_normal_rt';
AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Normal_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Normal_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Normal_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Normal_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Normal_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
AROI_Normal_Gabor_HM_append_LT_RT_Frontface=[AROI_Normal_Gabor_HM_FrontalLTface AROI_Normal_Gabor_HM_FrontalRTface];
save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface','AROI_Normal_Gabor_HM_mean_LT_RT_Frontface','AROI_Normal_Gabor_HM_append_LT_RT_Frontface');
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
cd([rel_path '\AROI_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx}]);
load('AROI_Gabor_H&M_Malignant_Front.mat')
AROI_Malignant_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_malignant_lt';
AROI_Malignant_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_malignant_rt';
AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Malignant_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Malignant_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Malignant_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Malignant_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
AROI_Malignant_Gabor_HM_append_LT_RT_Frontface=[AROI_Malignant_Gabor_HM_FrontalLTface AROI_Malignant_Gabor_HM_FrontalRTface];
save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface','AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Malignant_Gabor_HM_append_LT_RT_Frontface');

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
cd([rel_path '\AROI_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}]);
load('AROI_Gabor_H&M_precancer_Front.mat')
AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_precancer_lt';
AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_precancer_rt';
AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
end
AROI_Precancer_Gabor_HM_append_LT_RT_Frontface=[AROI_Precancer_Gabor_HM_FrontalLTface AROI_Precancer_Gabor_HM_FrontalRTface];
save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface','AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Precancer_Gabor_HM_append_LT_RT_Frontface');
end