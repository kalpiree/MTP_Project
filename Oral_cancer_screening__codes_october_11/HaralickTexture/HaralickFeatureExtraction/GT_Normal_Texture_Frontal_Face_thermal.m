% ===========================GT_Normal_Texture_Frontal_Face_thermal.m ====================================== %
% Description  : This function Computes the Haralick features
% from rotational invariant Gray level coccurence matrix of the Frontal
% image  
% ================================================================================== %
% Input Parameters :
%                   
%                    
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  
%  GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_lt (13x1 double)
%                  
%  GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_rt (13x1 double)
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: GLCM_D_THETA.m
%   #2: haralick_ours.m
% Called by :  GT_Normal_Texture_Frontal_Face_thermal.m
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] R. M. Haralick, K. Shanmugam, and I. H. Dinstein, “Textural features
% for image classification,” Systems, Man and Cybernetics, IEEE
% Transactions on, no. 6, pp. 610–621, 1973.
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
function GT_Normal_Texture_Frontal_Face_thermal
%%
clear;
clc;
close all;

%%
d = dir('..\..\..\ThermalDatabase\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
for folder_idx=1:no_dir 
disp(nameFolds(folder_idx)); 
close all;
%----------------------------------------------------Read Frontal Thermal img-------------------------------------------------------------------------------------------%
I1 = xlsread(['..\..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
maxval=max(max(I1));
minval=min(min(I1));
range=255/(maxval-minval);
I1=range.*(I1-minval); %bringing the image to a scale of 0-255
I1=uint8(I1);
[row,col]=size(I1);

% figure, set(gca,'color','none');imshow(I1,[]);title('Org Thermal image');
%-------------------Loading the left and right ROI ( Ground Truth) -------------------------------------------------------------------------------------------%
       folder_name=['..\..\..\ThermalDatabase\Normal\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

                cd(folder_name);
                load('Face_Mask.mat');
              
               mask_F_normal_lt(1:row,1:col)=0;
               col_mask=size(mask_F_normal_lt,2)-size(img_face_lt,2);
               mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=img_face_lt;


               mask_F_normal_rt(1:row,1:col)=0;
               mask_F_normal_rt(:,1:size(img_face_rt,2))=img_face_rt;  
               
ROI_img_face_rt=logical(mask_F_normal_rt);
ROI_img_face_lt=logical(mask_F_normal_lt);
GT_ROI_R=I1.*uint8(ROI_img_face_rt);
GT_ROI_L=I1.*uint8(ROI_img_face_lt);
%-------------------Loading the left and right ROI ( Ground Truth) -------------------------------------------------------------------------------------------%


%Calculation of haralik features on rotation invariant GLCM on rt half of
%the frontal face
cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');

GC_d1_theta0_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,0,ROI_img_face_rt); % calculating glcm for didtance=1 and theta=0
GC_d1_theta45_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,45,ROI_img_face_rt);% calculating glcm for didtance=1 and theta=45
GC_d1_theta90_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,90,ROI_img_face_rt);% calculating glcm for didtance=1 and theta=90
GC_d1_theta135_ROI_img_face_rt=GLCM_D_THETA(GT_ROI_R,1,135,ROI_img_face_rt);% calculating glcm for didtance=1 and theta=135
sum_GC_d1_theta0_45_90_135_ROI_img_face_rt=GC_d1_theta0_ROI_img_face_rt+GC_d1_theta45_ROI_img_face_rt+GC_d1_theta90_ROI_img_face_rt+GC_d1_theta135_ROI_img_face_rt;%finding the sum of the 4 glcm founf above
sum_GC_d1_theta0_45_90_135_ROI_img_face_rt=sum_GC_d1_theta0_45_90_135_ROI_img_face_rt./(sum(sum_GC_d1_theta0_45_90_135_ROI_img_face_rt(:))); % averaging te glcm for distance = 1 and theta =0,45,90,135 to get the net GLCM . This GLCM is rotation invarinat. Haraliclic features are calculated on this GLCM
[GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_rt]=haralick_ours(GT_ROI_R,sum_GC_d1_theta0_45_90_135_ROI_img_face_rt); % calculating haralik features on rotation invariant GLCM

%Calculation of haralik features on rotation invariant GLCM on lt half of
%the frontal face



GC_d1_theta0_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,0,ROI_img_face_lt);
GC_d1_theta45_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,45,ROI_img_face_lt);
GC_d1_theta90_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,90,ROI_img_face_lt);
GC_d1_theta135_ROI_img_face_lt=GLCM_D_THETA(GT_ROI_L,1,135,ROI_img_face_lt);
sum_GC_d1_theta0_45_90_135_ROI_img_face_lt=GC_d1_theta0_ROI_img_face_lt+GC_d1_theta45_ROI_img_face_lt+GC_d1_theta90_ROI_img_face_lt+GC_d1_theta135_ROI_img_face_lt;%finding the sum of the 4 glcm founf above
sum_GC_d1_theta0_45_90_135_ROI_img_face_lt=sum_GC_d1_theta0_45_90_135_ROI_img_face_lt./(sum(sum_GC_d1_theta0_45_90_135_ROI_img_face_lt(:)));
[GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_lt]=haralick_ours(GT_ROI_L,sum_GC_d1_theta0_45_90_135_ROI_img_face_lt);


%-------------Saving the Feature------------------------%

rel_path=['..\..\..\ThermalDatabase\Normal\' nameFolds{folder_idx} '\'];
cd(rel_path);
folder_name=['GT_Thermal_Texture_Front_Results_' nameFolds{folder_idx}];
if ~exist(folder_name,'dir')
     mkdir(folder_name);
     cd(folder_name);
else
      cd(rel_path);
      rmdir(folder_name,'s');
      mkdir(folder_name);
      cd(folder_name);
end
save('GT_Normal_Haralick_Frontal_Face_d1_theta0_45_90_135','GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_rt','GT_Normal_haralick_d1_theta_0_45_90_135_ROI_img_face_lt');
%-------------Saving the Feature------------------------%

cd('..\..\..\..\code repository\HaralickTexture\HaralickFeatureExtraction');

end
end