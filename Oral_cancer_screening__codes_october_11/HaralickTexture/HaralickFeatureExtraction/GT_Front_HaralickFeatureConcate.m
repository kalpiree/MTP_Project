% ===========================GT_append_diff_mean_haralic_feature_Frontal.m ====================================== %
% Description  : This function conacatenates the 
% the left and right computed haralick features for each image .This is done for
% each category of patients (Malignant , Normal ,Non Malignant)
%  
% ================================================================================== %
% Input Parameters :
%                   
%                    
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  

%  GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface    (No. of subjects x 26 double)               

%  GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface (No. of subjects x 26 double)

%  GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface(No. of subjects x 26 double)
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   NIL
%
% 
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] R. M. Haralick, K. Shanmugam, and I. H. Dinstein, “Textural features
% for image classification,” Systems, Man and Cybernetics, IEEE
% Transactions on, no. 6, pp. 610–621, 1973.
%     
%    

% Author of the code:  Manashi chakraborty  
% Date of creation :   
% ------------------------------------------------------------------------------------------------------- %
% Modified on :   
% Modification details:    
% Modified By :  Manashi chakraborty 
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function GT_Front_HaralickFeatureConcate
clear;
close all;
%%
 %Normal
d = dir('..\..\..\ThermalDatabase\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
sub_idx=1;
for folder_idx=1:no_dir  
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\Normal\' nameFolds{folder_idx} '\' ];
cd([rel_path 'GT_Thermal_Texture_Front_Results_' nameFolds{folder_idx}]);
load('GT_Normal_Haralick_Frontal_Face_d1_theta0_45_90_135.mat')
GT_Normal_haralick_d1_theta_0_45_90_135_FrontalLTface(sub_idx,:)=GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_lt';
GT_Normal_haralick_d1_theta_0_45_90_135_FrontalRTface(sub_idx,:)=GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_rt';

sub_idx=sub_idx+1;
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');
end
GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface=[GT_Normal_haralick_d1_theta_0_45_90_135_FrontalLTface GT_Normal_haralick_d1_theta_0_45_90_135_FrontalRTface];
save('..\HaralickFeatures\GT_Haralick_Normal_Frontal_face.mat','GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface');
%%
 %Malignant
d = dir('..\..\..\ThermalDatabase\Malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
sub_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\Malignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Thermal_Texture_Front_Results_' nameFolds{folder_idx}]);
load('GT_Malignant_Haralick_Frontal_Face_d1_theta0_45_90_135.mat')
GT_Malignant_haralick_d1_theta_0_45_90_135_FrontalLTface(sub_idx,:)=GT_Malignant_haralick_d1_theta0_45_90_135_ROI_img_face_lt';
GT_Malignant_haralick_d1_theta_0_45_90_135_FrontalRTface(sub_idx,:)=GT_Malignant_haralick_d1_theta0_45_90_135_ROI_img_face_rt';

sub_idx=sub_idx+1;
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');

end
GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface=[GT_Malignant_haralick_d1_theta_0_45_90_135_FrontalLTface GT_Malignant_haralick_d1_theta_0_45_90_135_FrontalRTface];
save('..\HaralickFeatures\GT_Haralick_Malignant_Frontal_face.mat','GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface');
%%
%Non Malignant
d = dir('..\..\..\ThermalDatabase\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
sub_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Thermal_Texture_Front_Results_' nameFolds{folder_idx}]);
load('GT_NonMalignant_Haralick_Frontal_Face_d1_theta0_45_90_135.mat')
GT_NonMalignant_haralick_d1_theta_0_45_90_135_FrontalLTface(sub_idx,:)=GT_NonMalignant_haralick_d1_theta0_45_90_135_ROI_img_face_lt';
GT_NonMalignant_haralick_d1_theta_0_45_90_135_FrontalRTface(sub_idx,:)=GT_NonMalignant_haralick_d1_theta0_45_90_135_ROI_img_face_rt';

sub_idx=sub_idx+1;
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');

end
GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface=[GT_NonMalignant_haralick_d1_theta_0_45_90_135_FrontalLTface GT_NonMalignant_haralick_d1_theta_0_45_90_135_FrontalRTface];
save('..\HaralickFeatures\GT_Haralick_NMalignant_Frontal_face.mat','GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface');

 end