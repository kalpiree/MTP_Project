% =========================== GT_Profile_FeatureConcate.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : GT_Histogram_Error_FrontFace.mat
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  GT_Full_ErrorHistogram_Normal_Frontal_face.mat 
%                    MAE128_Front_Normal 
%                    GT_Full_ErrorHistogram_Malignant_Frontal_face.mat 
%                    MAE128_Front_Malignant 
%                    GT_Full_ErrorHistogram_NonMalignant_Frontal_face.mat 
%                    MAE128_Front_NonMalignant 
%                      
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: Nil
% Called by :  run_Histogram_Frontal.m
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
function GT_Profile_FeatureConcate
%%
clear;
clc;
close all;

%%
 %Normal
d = dir('..\..\ThermalDatabase\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\ThermalDatabase\Normal\' nameFolds{folder_idx} '\' ];
cd([rel_path '\GT_Profile_Histogram_Error_' nameFolds{folder_idx}]);
load('GT_Histogram_Error_ProfileFace.mat')
MAE128_Profile_Normal(error_idx)=MAE128;
error_idx=error_idx+1;
cd('..\..\..\..\code repository\SPIE_2016');
end
save('ErrorHistogram\GT_Full_ErrorHistogram_Normal_Profile_face.mat','MAE128_Profile_Normal');

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
save('ErrorHistogram\GT_Full_ErrorHistogram_Malignant_Profile_face.mat','MAE128_Profile_Malignant');

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
save('ErrorHistogram\GT_Full_ErrorHistogram_NonMalignant_Profile_face.mat','MAE128_Profile_NonMalignant');
end