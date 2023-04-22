function GT_PN_pvalue_AUC_ProfileFace
clear;

enter_pvalue=0.05;

load('..\HaralickFeatures\GT_Haralick_Normal_Profile_face.mat');
load('..\HaralickFeatures\GT_Haralick_NMalignant_Profile_face.mat');

%%
%Calculation of signigicant AUC and P value for concatination feature(concatinate btwn lt and rt haralick feature of frontal img) 
GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface=GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface;
GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface=GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface;

Trainingset_concatinate=[GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface;GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface];
dataTrainPrecancerous_concatinate =Trainingset_concatinate(1:size(GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface,1),:);
dataTrainNormal_concatinate =Trainingset_concatinate((size(GT_NMalignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Pface,1)+1):end,:);
[h_concatinate,p_concatinate,ci_concatinate,stat_concatinate] = ttest2(dataTrainPrecancerous_concatinate,dataTrainNormal_concatinate,'Vartype','unequal');
significant_p_concatinate=(p_concatinate<enter_pvalue).*p_concatinate;

for concatinate_feature_idx=1:size(Trainingset_concatinate,2)
   Precancerous_data_AUC_concatinate= dataTrainPrecancerous_concatinate(1:end,concatinate_feature_idx);
   Normal_data_AUC_concatinate=dataTrainNormal_concatinate(1:end,concatinate_feature_idx);
   AUC_concatinate(concatinate_feature_idx)=AUC_Features(Precancerous_data_AUC_concatinate,Normal_data_AUC_concatinate);
    
end
significant_AUC_concatinate=(AUC_concatinate>0.6).*AUC_concatinate;

 idx_significantfeatures_concatinate =find(significant_AUC_concatinate~=0 & significant_p_concatinate~=0);
 

%==========Select paired significant feature from left and right halves of face (START) 

var_mod13=mod(idx_significantfeatures_concatinate,13); % modulo by 13 to select paired feature
var_mod13(var_mod13==0)=13;  % if the selected feature is 26th Feature, replace by number 13 
freq = zeros(size(var_mod13));
for i = 1:length(var_mod13)
freq(i) = sum(var_mod13==var_mod13(i)); %to ensure we select only the paired feature, calculate frequency
end
paired_feature_idx=find(freq==2); %get those indices where frequency is 2, this ensure feature is selected both from left and right cheeck
idx_significantfeatures_concatinate=idx_significantfeatures_concatinate(paired_feature_idx); %select the paired significant feature
%==========Select paired significant feature from left and right halves of face (STOP) 
% idx_significantfeatures_concatinate= [ 5,18,8,21];

GT_SignificantPrecancerous_Profile_LTandRT_append=dataTrainPrecancerous_concatinate(1:end,idx_significantfeatures_concatinate);
GT_SignificantNormal_Profile_LTandRT_append=dataTrainNormal_concatinate(1:end,idx_significantfeatures_concatinate);


%%
save('..\HaralickFeatures\SignifantFeatures\GT_Significant_Haralick_PrecancerousNormal_Profile','GT_SignificantPrecancerous_Profile_LTandRT_append','GT_SignificantNormal_Profile_LTandRT_append');


end


