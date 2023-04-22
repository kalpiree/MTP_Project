function GT_Profile_HaralickFeatureConcate_AgeAdjust
clear;
close all;
%%
 %Normal
d = dir('..\..\..\ThermalDatabase\Normal_AgeAdjust');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
sub_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\Normal_AgeAdjust\' nameFolds{folder_idx} '\' ];
cd([rel_path '\AgeAdjust_GT_Thermal_Texture_Profile_Results_' nameFolds{folder_idx}]);
load('AgeAdjust_GT_Normal_Haralick_Profile_Face_d1_theta0_45_90_135.mat')
GT_Normal_haralick_d1_theta_0_45_90_135_ProfileLTface(sub_idx,:)=GT_Normal_haralick_d1_theta0_45_90_135_ROI_img_face_lt';
GT_Normal_haralick_d1_theta_0_45_90_135_ProfileRTface(sub_idx,:)=GT_Normal_haralick_d1_theta0_45_90_135_ROI_img_face_rt';

sub_idx=sub_idx+1;
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');
end
GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface=[GT_Normal_haralick_d1_theta_0_45_90_135_ProfileLTface GT_Normal_haralick_d1_theta_0_45_90_135_ProfileRTface];
save('..\HaralickFeatures\AgeAdjust_GT_Haralick_Normal_Profile_face.mat','GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface');
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
cd([rel_path '\GT_Thermal_Texture_Profile_Results_' nameFolds{folder_idx}]);
load('GT_Malignant_Haralick_Profile_Face_d1_theta0_45_90_135.mat')
GT_Malignant_haralick_d1_theta_0_45_90_135_ProfileLTface(sub_idx,:)=GT_Malignant_haralick_d1_theta0_45_90_135_ROI_img_face_lt';
GT_Malignant_haralick_d1_theta_0_45_90_135_ProfileRTface(sub_idx,:)=GT_Malignant_haralick_d1_theta0_45_90_135_ROI_img_face_rt';

sub_idx=sub_idx+1;
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');
end
GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface=[GT_Malignant_haralick_d1_theta_0_45_90_135_ProfileLTface GT_Malignant_haralick_d1_theta_0_45_90_135_ProfileRTface];
save('..\HaralickFeatures\AgeAdjust_GT_Haralick_Malignant_Profile_face.mat','GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface');
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
cd([rel_path '\GT_Thermal_Texture_Profile_Results_' nameFolds{folder_idx}]);
load('GT_NonMalignant_Haralick_Profile_Face_d1_theta0_45_90_135.mat')
GT_NonMalignant_haralick_d1_theta_0_45_90_135_ProfileLTface(sub_idx,:)=GT_NonMalignant_haralick_d1_theta0_45_90_135_ROI_img_face_lt';
GT_NonMalignant_haralick_d1_theta_0_45_90_135_ProfileRTface(sub_idx,:)=GT_NonMalignant_haralick_d1_theta0_45_90_135_ROI_img_face_rt';

sub_idx=sub_idx+1;
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');
end
GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface=[GT_NonMalignant_haralick_d1_theta_0_45_90_135_ProfileLTface GT_NonMalignant_haralick_d1_theta_0_45_90_135_ProfileRTface];
save('..\HaralickFeatures\AgeAdjust_GT_Haralick_NMalignant_Profile_face.mat','GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface');

end