% ===========================GT_MN_pvalue_AUC_FrontalFace.m ====================================== %
% Description  : This function Computes the AUC and P value for the
% haralick features. Only those features are selected for classification which has
%p_value <=.05 and AUC>=0.6
%
% ================================================================================== %
% Input Parameters :
%                   
%                    
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  
%  GT_Significant_Haralick_MalignantNormal_Frontal
 
%  GT_SignificantMalignant_Frontal_LTandRT_append 
%  GT_SignificantNormal_Frontal_LTandRT_append  

%
%
%
%
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1:AUC_Features : It calculates the AUC of feature
%   #2: ttest2      : this function is used to evaluate p-value
%
% Called by :  GT_MN_pvalue_AUC_FrontalFace.m
%------------------------------------------------------------------------------------%
% Reference:    
%
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

function GT_MN_pvalue_AUC_FrontalFace
clear;


enter_pvalue=0.05;

load('..\HaralickFeatures\GT_Haralick_Malignant_Frontal_face.mat');
load('..\HaralickFeatures\GT_Haralick_Normal_Frontal_face.mat');

%%
%Calculation of signigicant AUC and P value for concatination feature(concatinate btwn lt and rt haralick feature of frontal img) 
% Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface=Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface(1:81,:);
GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface=GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface;
GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface=GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface;
Trainingset_concatinate=[GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface;GT_Normal_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface];

dataTrainMalignant_concatinate =Trainingset_concatinate(1:size(GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface,1),:);
dataTrainNormal_concatinate =Trainingset_concatinate((size(GT_Malignant_haralick_d1_theta_0_45_90_135_append_LT_RT_Fface,1)+1):end,:);
[~,p_concatinate,~,~] = ttest2(dataTrainMalignant_concatinate,dataTrainNormal_concatinate,'Vartype','unequal'); % calculate p value of features
significant_p_concatinate=(p_concatinate<enter_pvalue).*p_concatinate; %consider only those featurewhere p-value<0.5 and AUC>0.6

for concatinate_feature_idx=1:size(Trainingset_concatinate,2)
   Malignant_data_AUC_concatinate= dataTrainMalignant_concatinate(1:end,concatinate_feature_idx);
   Normal_data_AUC_concatinate=dataTrainNormal_concatinate(1:end,concatinate_feature_idx);
   AUC_concatinate(concatinate_feature_idx)=AUC_Features(Malignant_data_AUC_concatinate,Normal_data_AUC_concatinate);
    
end
significant_AUC_concatinate=(AUC_concatinate>0.6).*AUC_concatinate; %consider only those featurewhere p-value<0.5 and AUC>0.6
idx_significantfeatures_concatinate =find(significant_AUC_concatinate~=0 & significant_p_concatinate~=0); %consider index of significant feature






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





%==============Significant Features
GT_SignificantMalignant_Frontal_LTandRT_append=dataTrainMalignant_concatinate(1:end,idx_significantfeatures_concatinate);
GT_SignificantNormal_Frontal_LTandRT_append=dataTrainNormal_concatinate(1:end,idx_significantfeatures_concatinate);
%%
%=====Save Significant Features============
save('..\HaralickFeatures\SignifantFeatures\GT_Significant_Haralick_MalignantNormal_Frontal','GT_SignificantMalignant_Frontal_LTandRT_append','GT_SignificantNormal_Frontal_LTandRT_append');


end


