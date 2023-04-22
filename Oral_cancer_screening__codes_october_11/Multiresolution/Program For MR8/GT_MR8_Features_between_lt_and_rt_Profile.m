% ===========================  GT_MR8_Features_between_lt_and_rt_Profile.m ====================================== %
% Description  : 
% 
% ================================================================================== %
% Input Parameters :
%                    ROS_idx:
%                  
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                 GT_Normal_MR8_Diff_LT_RT_Profileface 
%                GT_Normal_MR8_mean_LT_RT_Profileface 
%                GT_Normal_MR8_append_LT_RT_Profileface
%                 GT_Malignant_MR8_Diff_LT_RT_Profileface
%                GT_Malignant_MR8_mean_LT_RT_Profileface 
%                GT_Malignant_MR8_append_LT_RT_Profileface
%                 GT_NMalignant_MR8_Diff_LT_RT_Profileface
%                 GT_NMalignant_MR8_mean_LT_RT_Profileface 
%                 GT_NMalignant_MR8_append_LT_RT_Profileface
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   Nil
%  
% Called by :  kernelsize_select_1.m
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] %%%%
%
%
% Author of the code:  Manashi Chakraborty  
% Date of creation :   
% ------------------------------------------------------------------------------------------------------- %
% Modified on :  
% Modification details:    
% Modified By :   Manashi Chakraborty
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function GT_MR8_Features_between_lt_and_rt_Profile(ROS_idx)
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
cd([rel_path 'GT_MR8_Normal_Profile_' nameFolds{folder_idx} ]);
load('GT_MR8_Normal_Profile.mat')
Normal_MR8_ProfileLTface(error_idx,:)=GT_MR8_F_normal_lt';
Normal_MR8_ProfileRTface(error_idx,:)=GT_MR8_F_normal_rt';
GT_Normal_MR8_Diff_LT_RT_Profileface(error_idx,:)=abs(Normal_MR8_ProfileLTface(error_idx,:)-Normal_MR8_ProfileRTface(error_idx,:));
GT_Normal_MR8_mean_LT_RT_Profileface(error_idx,:)=(Normal_MR8_ProfileLTface(error_idx,:)+Normal_MR8_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Program For MR8';
end
GT_Normal_MR8_append_LT_RT_Profileface=[Normal_MR8_ProfileLTface Normal_MR8_ProfileRTface];
save(['..\MR8Features\Full_GT_MR8_Normal_Profile_face_ROS_',num2str(ROS_idx),'.mat'],'GT_Normal_MR8_Diff_LT_RT_Profileface','GT_Normal_MR8_mean_LT_RT_Profileface','GT_Normal_MR8_append_LT_RT_Profileface');
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
cd([rel_path 'GT_MR8_Malignant_Profile_' nameFolds{folder_idx}]);
load('GT_MR8_Malignant_Profile.mat')
Malignant_MR8_ProfileLTface(error_idx,:)=GT_MR8_F_malignant_lt';
Malignant_MR8_ProfileRTface(error_idx,:)=GT_MR8_F_malignant_rt';
GT_Malignant_MR8_Diff_LT_RT_Profileface(error_idx,:)=abs(Malignant_MR8_ProfileLTface(error_idx,:)-Malignant_MR8_ProfileRTface(error_idx,:));
GT_Malignant_MR8_mean_LT_RT_Profileface(error_idx,:)=(Malignant_MR8_ProfileLTface(error_idx,:)+Malignant_MR8_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Program For MR8';
end
GT_Malignant_MR8_append_LT_RT_Profileface=[Malignant_MR8_ProfileLTface Malignant_MR8_ProfileRTface];
save(['..\MR8Features\Full_GT_MR8_Malignant_Profile_face_ROS_',num2str(ROS_idx),'.mat'],'GT_Malignant_MR8_Diff_LT_RT_Profileface','GT_Malignant_MR8_mean_LT_RT_Profileface' ,'GT_Malignant_MR8_append_LT_RT_Profileface');

%%
 %Non Malignant
d = dir('..\..\..\ThermalDatabase\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path 'GT_MR8_precancer_Profile_' nameFolds{folder_idx}]);
load('GT_MR8_Precancer_Profile.mat')
NMalignant_MR8_ProfileLTface(error_idx,:)=GT_MR8_F_precancer_lt';
NMalignant_MR8_ProfileRTface(error_idx,:)=GT_MR8_F_precancer_rt';
GT_NMalignant_MR8_Diff_LT_RT_Profileface(error_idx,:)=abs(NMalignant_MR8_ProfileLTface(error_idx,:)-NMalignant_MR8_ProfileRTface(error_idx,:));
GT_NMalignant_MR8_mean_LT_RT_Profileface(error_idx,:)=(NMalignant_MR8_ProfileLTface(error_idx,:)+NMalignant_MR8_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\code repository\Multiresolution\Program For MR8';
end
GT_NMalignant_MR8_append_LT_RT_Profileface=[NMalignant_MR8_ProfileLTface NMalignant_MR8_ProfileRTface];
save(['..\MR8Features\Full_GT_MR8_NonMalignant_Profile_face_ROS_',num2str(ROS_idx),'.mat'],'GT_NMalignant_MR8_Diff_LT_RT_Profileface','GT_NMalignant_MR8_mean_LT_RT_Profileface' ,'GT_NMalignant_MR8_append_LT_RT_Profileface');

end