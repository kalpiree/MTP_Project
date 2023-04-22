function GT_Profile_FeatureConcate_AgeAdjust
%%
clear;
clc;
close all;

%%
 %Normal
d = dir('..\..\ThermalDatabase\Normal_AgeAdjust');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\ThermalDatabase\Normal_AgeAdjust\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Profile_Histogram_Error_' nameFolds{folder_idx}]);
load('GT_Histogram_Error_ProfileFace.mat')
MAE128_Profile_Normal(error_idx)=MAE128;

error_idx=error_idx+1;
cd('..\..\..\..\code repository\SPIE_2016');

end
save('ErrorHistogram\AgeAdjust_GT_ErrorHistogram_Normal_Profile_face.mat','MAE128_Profile_Normal');

%%
%Malignant
d = dir('..\..\ThermalDatabase\Malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\ThermalDatabase\Malignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Profile_Histogram_Error_' nameFolds{folder_idx}]);
load('GT_Histogram_Error_ProfileFace.mat')
MAE128_Profile_Malignant(error_idx)=MAE128;

error_idx=error_idx+1;
cd('..\..\..\..\code repository\SPIE_2016');

end
save('ErrorHistogram\AgeAdjust_GT_ErrorHistogram_Malignant_Profile_face.mat','MAE128_Profile_Malignant');

%%
%NonMalignant
d = dir('..\..\ThermalDatabase\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Profile_Histogram_Error_' nameFolds{folder_idx}]);
load('GT_Histogram_Error_ProfileFace.mat')
MAE128_Profile_NonMalignant(error_idx)=MAE128;
error_idx=error_idx+1;
cd('..\..\..\..\code repository\SPIE_2016');

end
save('ErrorHistogram\AgeAdjust_GT_ErrorHistogram_NonMalignant_Profile_face.mat','MAE128_Profile_NonMalignant');
end