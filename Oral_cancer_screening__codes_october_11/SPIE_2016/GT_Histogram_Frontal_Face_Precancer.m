% =========================== GT_Histogram_Frontal_Face_Precancer.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : Face_Mask.mat
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  GT_Histogram_Error_FrontFace
%                    MAE128
%                     
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: run_Histogram_Frontal.m
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
function GT_Histogram_Frontal_Face_Precancer
%%
clear;
clc;
close all;

%%
d = dir('..\..\ThermalDatabase\NonMalignant');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
close all;
%----------------------------------------------------Read Frontal  img-------------------------------------------------------------------------------------------%
I1 = xlsread(['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
maxval=max(max(I1));
minval=min(min(I1));
range=255/(maxval-minval);
I1=range.*(I1-minval);
I1=uint8(I1);
[row,col]= size(I1);


%-------------------Loading the left and right ROI ( Ground Truth) -------------------------------------------------------------------------------------------%
       folder_name=['..\..\ThermalDatabase\NonMalignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

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

%-------------------Loading the left and right ROI ( Ground Truth) END -------------------------------------------------------------------------------------------%





%Calculate the Histogram of Left Face and Right Face for 128
%labels
[counts_lt1,binLocations_lt1]  = imhist(GT_ROI_L(GT_ROI_L>0),128);
[counts_rt1,binLocations_rt1]  = imhist(GT_ROI_R(GT_ROI_R>0),128);
%Calculate the histogram error

MAE128=zeros(128,1);


for MAE128_idx=1:128
    
         MAE128(MAE128_idx) = (abs(counts_lt1(MAE128_idx) - counts_rt1(MAE128_idx)))/128;
         
end
MAE128=sum(MAE128); % Mean Absolute Error is the feature

%-------------Saving the Feature------------------------%
rel_path='..\';
cd(rel_path);
folder_name=['GT_Histogram_Error_' nameFolds{folder_idx}];
if ~exist(folder_name,'dir')
     mkdir(folder_name);
     cd(folder_name);
else
   
     rmdir(folder_name,'s');
      mkdir(folder_name);
      cd(folder_name);
end
save('GT_Histogram_Error_FrontFace','MAE128');
%-------------Saving the Feature------------------------%

cd('..\..\..\..\code repository\SPIE_2016');
end
end