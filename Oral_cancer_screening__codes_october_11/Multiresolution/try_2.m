%d = dir('..\..\..\ThermalDatabase\NonMalignant');
%isub = [d(:).isdir]; %# returns logical vector
%nameFolds = {d(isub).name}';
%nameFolds=nameFolds(3:end);
%no_dir=numel(nameFolds);  
error_idx=1;
%for folder_idx=1:no_dir
%disp(nameFolds(folder_idx)); 
%rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx} '\' ];
%cd([rel_path '\AROI_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}]);
cd("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129\AROI_Gabor_Han&Ma_precancer_Front_P0129");
load('AROI_Gabor_H&M_precancer_Front.mat')
%AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)=AROI_gabor_F_precancer_lt';
AROI_Precancer_Gabor_HM_FrontalLTface=AROI_gabor_F_precancer_lt';
%AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:)=AROI_gabor_F_precancer_rt';
AROI_Precancer_Gabor_HM_FrontalRTface=AROI_gabor_F_precancer_rt';
%AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface(error_idx,:)=abs(AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)-AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:));
AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface=abs(AROI_Precancer_Gabor_HM_FrontalLTface-AROI_Precancer_Gabor_HM_FrontalRTface);
%AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface(error_idx,:)=(AROI_Precancer_Gabor_HM_FrontalLTface(error_idx,:)+AROI_Precancer_Gabor_HM_FrontalRTface(error_idx,:))/2;
AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface=(AROI_Precancer_Gabor_HM_FrontalLTface+AROI_Precancer_Gabor_HM_FrontalRTface)/2;


error_idx=error_idx+1;
 %cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
 cd ("C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456");
 
%end
AROI_Precancer_Gabor_HM_append_LT_RT_Frontface=[AROI_Precancer_Gabor_HM_FrontalLTface AROI_Precancer_Gabor_HM_FrontalRTface];
%save(['..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat'],'AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface','AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Precancer_Gabor_HM_append_LT_RT_Frontface');
save('..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Frontal_face_scale_7.mat',"AROI_Precancer_Gabor_HM_Diff_LT_RT_Frontface",'AROI_Precancer_Gabor_HM_mean_LT_RT_Frontface' ,'AROI_Precancer_Gabor_HM_append_LT_RT_Frontface');
%end