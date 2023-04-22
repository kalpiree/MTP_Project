function AgeAdjust_GT_Normal_Texture_Profile_Face_thermal 
%%
clear;
clc;
close all;

%%
d = dir('..\..\..\ThermalDatabase\Normal_AgeAdjust');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
close all;
%----------------------------------------------------Read Frontal Thermal img-------------------------------------------------------------------------------------------%
I1_lt = xlsread(['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
I1_rt = xlsread(['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
    
            maxval_lt=max(max(I1_lt));
            minval_lt=min(min(I1_lt));
            range_lt=255/(maxval_lt-minval_lt);
            I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of 0.0-255.0
            I1_lt=uint8(I1_lt);
             
           
% 
            maxval_rt=max(max(I1_rt));
            minval_rt=min(min(I1_rt));
            range_rt=255/(maxval_rt-minval_rt);
            I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of 0.0-255.0
            I1_rt=uint8(I1_rt);
            [row_lt,col_lt]=size(I1_lt);

%-------------------Loading the left and right ROI ( Ground Truth) -------------------------------------------------------------------------------------------%
      folder_name=['..\..\..\ThermalDatabase\Normal_AgeAdjust\', nameFolds{folder_idx}, '\Profile_ROI_' nameFolds{folder_idx}];

                cd(folder_name);
                load('Face_Mask.mat');
                
                 mask_P_normal_lt(1:row_lt,1:col_lt)=0;
               col_mask=size(mask_P_normal_lt,2)-size(img_face_lt,2);
               mask_P_normal_lt(:,col_mask+1:size(mask_P_normal_lt,2))=img_face_lt;


               mask_P_normal_rt(1:row_lt,1:col_lt)=0;
               mask_P_normal_rt(:,1:size(img_face_rt,2))=img_face_rt;
                
               
               



ROI_img_face_rt=logical(mask_P_normal_rt);
ROI_img_face_lt=logical(mask_P_normal_lt);
GT_ROI_R=I1_rt.*uint8(ROI_img_face_rt);
GT_ROI_L=I1_lt.*uint8(ROI_img_face_lt);

cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');
%Calculation of haralik features on rotation invariant GLCM on rt half of
%the frontal face
GC_d1_theta0_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,0,ROI_img_face_rt); % calculating glcm for didtance=1 and theta=0
GC_d1_theta45_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,45,ROI_img_face_rt);% calculating glcm for didtance=1 and theta=45
GC_d1_theta90_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,90,ROI_img_face_rt);% calculating glcm for didtance=1 and theta=90
GC_d1_theta135_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,135,ROI_img_face_rt);% calculating glcm for didtance=1 and theta=135
sum_GC_d1_theta0_45_90_135_ROI_img_face_rt=GC_d1_theta0_ROI_img_face_rt+GC_d1_theta45_ROI_img_face_rt+GC_d1_theta90_ROI_img_face_rt+GC_d1_theta135_ROI_img_face_rt;%finding the sum of the 4 glcm founf above
sum_GC_d1_theta0_45_90_135_ROI_img_face_rt=sum_GC_d1_theta0_45_90_135_ROI_img_face_rt./(sum(sum_GC_d1_theta0_45_90_135_ROI_img_face_rt(:))); % averaging te glcm for distance = 1 and theta =0,45,90,135 to get the net GLCM . This GLCM is rotation invarinat. Haraliclic features are calculated on this GLCM
[GT_Normal_haralick_d1_theta0_45_90_135_ROI_img_face_rt]=haralick_ours(GT_ROI_R,sum_GC_d1_theta0_45_90_135_ROI_img_face_rt); % calculating haralik features on rotation invariant GLCM

%Calculation of haralik features on rotation invariant GLCM on lt half of
%the frontal face

GC_d1_theta0_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,0,ROI_img_face_lt);
GC_d1_theta45_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,45,ROI_img_face_lt);
GC_d1_theta90_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,90,ROI_img_face_lt);
GC_d1_theta135_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,135,ROI_img_face_lt);
sum_GC_d1_theta0_45_90_135_ROI_img_face_lt=GC_d1_theta0_ROI_img_face_lt+GC_d1_theta45_ROI_img_face_lt+GC_d1_theta90_ROI_img_face_lt+GC_d1_theta135_ROI_img_face_lt;%finding the sum of the 4 glcm founf above
sum_GC_d1_theta0_45_90_135_ROI_img_face_lt=sum_GC_d1_theta0_45_90_135_ROI_img_face_lt./(sum(sum_GC_d1_theta0_45_90_135_ROI_img_face_lt(:)));
[GT_Normal_haralick_d1_theta0_45_90_135_ROI_img_face_lt]=haralick_ours(GT_ROI_L,sum_GC_d1_theta0_45_90_135_ROI_img_face_lt);

%-------------Saving the Feature------------------------%

rel_path=['..\..\..\ThermalDatabase\Normal_AgeAdjust\' nameFolds{folder_idx} '\'];
cd(rel_path);
folder_name=['AgeAdjust_GT_Thermal_Texture_Profile_Results_' nameFolds{folder_idx}];
if ~exist(folder_name,'dir')
     mkdir(folder_name);
     cd(folder_name);
else
      cd(rel_path);
      rmdir(folder_name,'s');
      mkdir(folder_name);
      cd(folder_name);
end
save('AgeAdjust_GT_Normal_Haralick_Profile_Face_d1_theta0_45_90_135','GT_Normal_haralick_d1_theta0_45_90_135_ROI_img_face_rt','GT_Normal_haralick_d1_theta0_45_90_135_ROI_img_face_lt');
%-------------Saving the Feature------------------------%

cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');

end
end