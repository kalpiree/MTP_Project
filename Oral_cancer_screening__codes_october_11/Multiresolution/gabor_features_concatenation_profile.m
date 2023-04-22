n=2;
for sacle_idx=2:6
d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
n= n+2;
AROI_Malignant_Gabor_HM_ProfileLTface=zeros(71,n);
AROI_Malignant_Gabor_HM_ProfileRTface=zeros(71,n);
AROI_Malignant_Gabor_HM_Diff_LT_RT_Profileface=zeros(71,n);
AROI_Malignant_Gabor_HM_mean_LT_RT_Profileface=zeros(71,n);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Malignant\' nameFolds{folder_idx} '\' ];
cd([rel_path '\AROI_Gabor_Han&Ma_Malignant_Profile_' nameFolds{folder_idx} num2str(sacle_idx)]);
load('AROI_Gabor_H&M_Malignant_Profile.mat')
AROI_Malignant_Gabor_HM_ProfileLTface(error_idx,:)=AROI_gabor_P_malignant_lt;
AROI_Malignant_Gabor_HM_ProfileRTface(error_idx,:)=AROI_gabor_P_malignant_rt;
AROI_Malignant_Gabor_HM_Diff_LT_RT_Profileface(error_idx,:)=abs(AROI_Malignant_Gabor_HM_ProfileLTface(error_idx,:)-AROI_Malignant_Gabor_HM_ProfileRTface(error_idx,:));
AROI_Malignant_Gabor_HM_mean_LT_RT_Profileface(error_idx,:)=(AROI_Malignant_Gabor_HM_ProfileLTface(error_idx,:)+AROI_Malignant_Gabor_HM_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
end
AROI_Malignant_Gabor_HM_append_LT_RT_Profileface=[AROI_Malignant_Gabor_HM_ProfileLTface AROI_Malignant_Gabor_HM_ProfileRTface];
save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Malignant_Profile_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Malignant_Gabor_HM_Diff_LT_RT_Profileface','AROI_Malignant_Gabor_HM_mean_LT_RT_Profileface' ,'AROI_Malignant_Gabor_HM_append_LT_RT_Profileface');
%n=n+2;
end

n=2;
for sacle_idx=2:6
d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
n= n+2;
AROI_Normal_Gabor_HM_ProfileLTface=zeros(258,n);
AROI_Normal_Gabor_HM_ProfileRTface=zeros(258,n);
AROI_Normal_Gabor_HM_Diff_LT_RT_Profileface=zeros(258,n);
AROI_Normal_Gabor_HM_mean_LT_RT_Profileface=zeros(258,n);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Normal\' nameFolds{folder_idx} '\' ];
cd([rel_path 'AROI_Gabor_Han&Ma_Normal_Profile_' nameFolds{folder_idx} num2str(sacle_idx)]);
load('AROI_Gabor_H&M_Normal_Profile.mat')
AROI_Normal_Gabor_HM_ProfileLTface(error_idx,:)=AROI_gabor_P_normal_lt';
AROI_Normal_Gabor_HM_ProfileRTface(error_idx,:)=AROI_gabor_P_normal_rt';
AROI_Normal_Gabor_HM_Diff_LT_RT_Profileface(error_idx,:)=abs(AROI_Normal_Gabor_HM_ProfileLTface(error_idx,:)-AROI_Normal_Gabor_HM_ProfileRTface(error_idx,:));
AROI_Normal_Gabor_HM_mean_LT_RT_Profileface(error_idx,:)=(AROI_Normal_Gabor_HM_ProfileLTface(error_idx,:)+AROI_Normal_Gabor_HM_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
end
AROI_Normal_Gabor_HM_append_LT_RT_Profileface=[AROI_Normal_Gabor_HM_ProfileLTface AROI_Normal_Gabor_HM_ProfileRTface];
save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Normal_Profile_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Normal_Gabor_HM_Diff_LT_RT_Profileface','AROI_Normal_Gabor_HM_mean_LT_RT_Profileface','AROI_Normal_Gabor_HM_append_LT_RT_Profileface');
end
%%
n=2;
for sacle_idx=2:6
d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
n= n+2;
AROI_Precancer_Gabor_HM_ProfileLTface=zeros(71,n);
AROI_Precancer_Gabor_HM_ProfileRTface=zeros(71,n);
AROI_Precancer_Gabor_HM_Diff_LT_RT_Profileface=zeros(71,n);
AROI_Precancer_Gabor_HM_mean_LT_RT_Profileface=zeros(71,n);
for folder_idx=200:no_dir
disp(nameFolds(folder_idx)); 
rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\' nameFolds{folder_idx} '\' ];
cd([rel_path 'AROI_Gabor_Han&Ma_precancer_Profile_' nameFolds{folder_idx} num2str(sacle_idx)]);
load('AROI_Gabor_H&M_Precancer_Profile.mat')
AROI_Precancer_Gabor_HM_ProfileLTface(error_idx,:)=AROI_gabor_P_precancer_lt';
AROI_Precancer_Gabor_HM_ProfileRTface(error_idx,:)=AROI_gabor_P_precancer_rt';
AROI_Precancer_Gabor_HM_Diff_LT_RT_Profileface(error_idx,:)=abs(AROI_Precancer_Gabor_HM_ProfileLTface(error_idx,:)-AROI_Precancer_Gabor_HM_ProfileRTface(error_idx,:));
AROI_Precancer_Gabor_HM_mean_LT_RT_Profileface(error_idx,:)=(AROI_Precancer_Gabor_HM_ProfileLTface(error_idx,:)+AROI_Precancer_Gabor_HM_ProfileRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
end
AROI_Precancer_Gabor_HM_append_LT_RT_Profileface=[AROI_Precancer_Gabor_HM_ProfileLTface AROI_Precancer_Gabor_HM_ProfileRTface];
save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Profile_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Precancer_Gabor_HM_Diff_LT_RT_Profileface','AROI_Precancer_Gabor_HM_mean_LT_RT_Profileface','AROI_Precancer_Gabor_HM_append_LT_RT_Profileface');
end