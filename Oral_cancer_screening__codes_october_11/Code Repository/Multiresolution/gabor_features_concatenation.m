n=2;
for sacle_idx=2:6
%d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Malignant');
d =dir("C:\Users\ntnbs\Downloads\common_database\malignant");
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
n= n+2;
AROI_Malignant_Gabor_HM_FrontalLTface=zeros(29,n);
AROI_Malignant_Gabor_HM_FrontalRTface=zeros(29,n);
AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface=zeros(29,n);
AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface=zeros(29,n);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
%rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Malignant\' nameFolds{folder_idx} '\' ];
rel_path=['C:\Users\ntnbs\Downloads\common_database\malignant\' nameFolds{folder_idx} '\'];
cd([rel_path '\AROI_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx} num2str(sacle_idx)]);
load('AROI_Gabor_H&M_Malignant_Front.mat')
AROI_Malignant_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_malignant_lt;
AROI_Malignant_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_malignant_rt;
AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Malignant_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Malignant_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Malignant_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Malignant_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
end
AROI_Malignant_Gabor_HM_append_LT_RT_Frontface=[AROI_Malignant_Gabor_HM_FrontalLTface AROI_Malignant_Gabor_HM_FrontalRTface];
%save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface','AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Malignant_Gabor_HM_append_LT_RT_Frontface');
save(['C:\Users\ntnbs\Downloads\common_database\malignant_frontal',num2str(sacle_idx),'.mat'],'AROI_Malignant_Gabor_HM_Diff_LT_RT_Frontface','AROI_Malignant_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Malignant_Gabor_HM_append_LT_RT_Frontface');
%n=n+2;
end

n=2;
for sacle_idx=2:6
%d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Normal');
d =dir("C:\Users\ntnbs\Downloads\common_database\normal");
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
n= n+2;
AROI_Normal_Gabor_HM_FrontalLTface=zeros(152,n);
AROI_Normal_Gabor_HM_FrontalRTface=zeros(152,n);
AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface=zeros(152,n);
AROI_Normal_Gabor_HM_mean_LT_RT_Frontface=zeros(152,n);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
%rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Normal\' nameFolds{folder_idx} '\' ];
rel_path=['C:\Users\ntnbs\Downloads\common_database\normal\' nameFolds{folder_idx} '\'];
cd([rel_path '\AROI_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx} num2str(sacle_idx)]);
load('AROI_Gabor_H&M_Normal_Front.mat')
AROI_Normal_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_normal_lt';
AROI_Normal_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_normal_rt';
AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Normal_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Normal_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Normal_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Normal_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Normal_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
end
AROI_Normal_Gabor_HM_append_LT_RT_Frontface=[AROI_Normal_Gabor_HM_FrontalLTface AROI_Normal_Gabor_HM_FrontalRTface];
%save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface','AROI_Normal_Gabor_HM_mean_LT_RT_Frontface','AROI_Normal_Gabor_HM_append_LT_RT_Frontface');
save(['C:\Users\ntnbs\Downloads\common_database\normal_frontal',num2str(sacle_idx),'.mat'],'AROI_Normal_Gabor_HM_Diff_LT_RT_Frontface','AROI_Normal_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Normal_Gabor_HM_append_LT_RT_Frontface');
end

n=2;
for sacle_idx=2:6
%d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\NonMalignant');
d =dir("C:\Users\ntnbs\Downloads\common_database\non_malignant");
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);  
error_idx=1;
n= n+2;
AROI_Precancer_Gabor_HM_FrontalLTface=zeros(34,n);
AROI_Precancer_Gabor_HM_FrontalRTface=zeros(34,n);
AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface=zeros(34,n);
AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface=zeros(34,n);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
%rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\' nameFolds{folder_idx} '\' ];
rel_path=['C:\Users\ntnbs\Downloads\common_database\non_malignant\' nameFolds{folder_idx} '\'];
cd([rel_path '\AROI_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx} num2str(sacle_idx)]);
load('AROI_Gabor_H&M_Precancer_Front.mat')
AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_precancer_lt';
AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_precancer_rt';
AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:))/2;

error_idx=error_idx+1;
 cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
end
AROI_Precancer_Gabor_HM_append_LT_RT_Frontface=[AROI_Precancer_Gabor_HM_FrontalLTface AROI_Precancer_Gabor_HM_FrontalRTface];
%save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface','AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface','AROI_Precancer_Gabor_HM_append_LT_RT_Frontface');
save(['C:\Users\ntnbs\Downloads\common_database\non_malignant_frontal',num2str(sacle_idx),'.mat'],'AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface','AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Precancer_Gabor_HM_append_LT_RT_Frontface');
end