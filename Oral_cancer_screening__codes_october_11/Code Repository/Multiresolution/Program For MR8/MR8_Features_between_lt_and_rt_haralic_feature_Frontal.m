 clear;
close all;
%%
 %Normal
d = dir('..\..\..\ThermalDatabase_OOC\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:63
disp(nameFolds(folder_idx)); 
rel_path=['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\Normal\' nameFolds{folder_idx} '\' ];
cd([rel_path 'MR8_Normal_Front_' nameFolds{folder_idx}]);
load('MR8_Normal_Front.mat')
Normal_MR8_FrontalLTface(error_idx,:)=MR8_F_normal_lt';
Normal_MR8_FrontalRTface(error_idx,:)=MR8_F_normal_rt';
Normal_MR8_Diff_LT_RT_Frontface(error_idx,:)=abs(Normal_MR8_FrontalLTface(error_idx,:)-Normal_MR8_FrontalRTface(error_idx,:));
Normal_MR8_mean_LT_RT_Frontface(error_idx,:)=(Normal_MR8_FrontalLTface(error_idx,:)+Normal_MR8_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';
end
Normal_MR8_append_LT_RT_Frontface=[Normal_MR8_FrontalLTface Normal_MR8_FrontalRTface];
save('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\MR8_Normal_Frontal_face.mat','Normal_MR8_Diff_LT_RT_Frontface','Normal_MR8_mean_LT_RT_Frontface','Normal_MR8_append_LT_RT_Frontface');
%%
 %Malignant
d = dir('..\..\..\ThermalDatabase_OOC\Malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\Malignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\MR8_Malignant_Front_' nameFolds{folder_idx}]);
load('MR8_Malignant_Front.mat')
Malignant_MR8_FrontalLTface(error_idx,:)=MR8_F_malignant_lt';
Malignant_MR8_FrontalRTface(error_idx,:)=MR8_F_malignant_rt';
Malignant_MR8_Diff_LT_RT_Frontface(error_idx,:)=abs(Malignant_MR8_FrontalLTface(error_idx,:)-Malignant_MR8_FrontalRTface(error_idx,:));
Malignant_MR8_mean_LT_RT_Frontface(error_idx,:)=(Malignant_MR8_FrontalLTface(error_idx,:)+Malignant_MR8_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';
end
Malignant_MR8_append_LT_RT_Frontface=[Malignant_MR8_FrontalLTface Malignant_MR8_FrontalRTface];
save('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\MR8_Malignant_Frontal_face.mat','Malignant_MR8_Diff_LT_RT_Frontface','Malignant_MR8_mean_LT_RT_Frontface' ,'Malignant_MR8_append_LT_RT_Frontface');

%%
 %Non Malignant
d = dir('..\..\..\ThermalDatabase_OOC\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\MR8_Precancer_Front_' nameFolds{folder_idx}]);
load('MR8_Precancer_Front.mat')
NMalignant_MR8_FrontLTface(error_idx,:)=MR8_F_precancer_lt';
NMalignant_MR8_FrontRTface(error_idx,:)=MR8_F_precancer_rt';
NMalignant_MR8_Diff_LT_RT_Frontface(error_idx,:)=abs(NMalignant_MR8_FrontLTface(error_idx,:)-NMalignant_MR8_FrontRTface(error_idx,:));
NMalignant_MR8_mean_LT_RT_Frontface(error_idx,:)=(NMalignant_MR8_FrontLTface(error_idx,:)+NMalignant_MR8_FrontRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';
end
NMalignant_MR8_append_LT_RT_Frontface=[NMalignant_MR8_FrontLTface NMalignant_MR8_FrontRTface];
save('F:\MS\matlab_code\WORK\SPIE_2017\MR8Features\MR8_NonMalignant_Front_face.mat','NMalignant_MR8_Diff_LT_RT_Frontface','NMalignant_MR8_mean_LT_RT_Frontface' ,'NMalignant_MR8_append_LT_RT_Frontface');

