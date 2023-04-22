% =========================== AgeAdjust_GT_ComputeGaborIR_Frontal.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  AgeAdjust_GT_Gabor_H&M_Precancer_Front 
%                    GT_gabor_F_precancer_lt 
%                    GT_gabor_F_precancer_rt
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: TexturalFeatureExtraction_RIGabor_HanAndMa.m
% Called by :  runGabor_HaanAndMa.m
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

function AgeAdjust_GT_ComputeGaborIR_Frontal(sacle_idx)
%%

clc;
close all;

%%'Normal Subjects' 
            d = dir('..\..\..\ThermalDatabase\Normal_AgeAdjust');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);

%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval); %bringing the image to a scale of 0-255
            
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0



            [row,col]=size(I1);
            
%             I1 = adapthisteq(uint8(I1));
            I1 = adapthisteq((I1));
 %-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

                folder_name=['..\..\..\ThermalDatabase\Normal_AgeAdjust\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

                cd(folder_name);
                load('Face_Mask.mat');
              
               mask_F_normal_lt(1:row,1:col)=0;
               col_mask=size(mask_F_normal_lt,2)-size(img_face_lt,2);
               mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=img_face_lt;


               mask_F_normal_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
               mask_F_normal_rt(:,1:size(img_face_rt,2))=img_face_rt;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
            GT_gabor_F_normal_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_normal_lt),sacle_idx);
            GT_gabor_F_normal_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_normal_rt),sacle_idx);


            rel_path=['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('AgeAdjust_GT_Gabor_H&M_Normal_Front','GT_gabor_F_normal_lt','GT_gabor_F_normal_rt');
            
            cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
            end
          
%%Malignant Subjects  

            d = dir('..\..\..\ThermalDatabase\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);

%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval); %bringing the image to a scale of 0-255

            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0

            [row,col]=size(I1);
%             I1 = adapthisteq(uint8(I1));
            I1 = adapthisteq((I1));

              %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\ThermalDatabase\Malignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            mask_F_malignant_lt(1:row,1:col)=0;
            col_mask=size(mask_F_malignant_lt,2)-size(img_face_lt,2);
            mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=img_face_lt;


            mask_F_malignant_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_malignant_rt(:,1:size(img_face_rt,2))=img_face_rt;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');

            GT_gabor_F_malignant_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_malignant_lt),sacle_idx);
            GT_gabor_F_malignant_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_malignant_rt),sacle_idx);


            rel_path=['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                   cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_GT_Gabor_H&M_Malignant_Front','GT_gabor_F_malignant_lt','GT_gabor_F_malignant_rt');

            cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';

            end     
%% 'Precancerous Subjects'  

            d = dir('..\..\..\ThermalDatabase\NonMalignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);

%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval); %bringing the image to a scale of 0-255
            
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
%              I1 = adapthisteq(uint8(I1));
             I1 = adapthisteq((I1));

            %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['..\..\..\ThermalDatabase\NonMalignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            mask_F_precancer_lt(1:row,1:col)=0;
            col_mask=size(mask_F_precancer_lt,2)-size(img_face_lt,2);
            mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=img_face_lt;


            mask_F_precancer_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_precancer_rt(:,1:size(img_face_rt,2))=img_face_rt;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');

            GT_gabor_F_precancer_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_precancer_lt),sacle_idx);
            GT_gabor_F_precancer_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_precancer_rt),sacle_idx);


            rel_path=['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_GT_Gabor_H&M_Precancer_Front','GT_gabor_F_precancer_lt','GT_gabor_F_precancer_rt');

            cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';

    
           end
end