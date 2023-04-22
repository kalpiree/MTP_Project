% =========================== GT_ComputeGaborIR_Frontal.m ====================================== %
% Description  : Computing Gabor features for each part of the frontal
% image(LT & RT), for each scale and storing them in the folder
% e.g.-> GT_Gabor_Han&Ma_Normal_Front_T001
%
% Read .csv file--->make an array of image intensity(0-1)---> load the
% mask's ---> calculate gabor features--->store them.
% 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  GT_Gabor_H&M_Normal_Front 
%                    GT_gabor_F_normal_lt   
%                    GT_gabor_F_normal_rt
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

function GT_ComputeGaborIR_Frontal(sacle_idx)
%%

close all;

%%
%'Normal Subjects' 
            d = dir('..\..\..\ThermalDatabase\Normal');%%% d stores a structure of 6 fields
           
            isub = [d(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
            nameFolds = {d(isub).name}'; 
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            nameFolds1=nameFolds;
            
            
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            %I1 = '..\..\..\ThermalDatabase\Normal\',xlsread([nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);
            I1 = xlsread(['..\..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
            %I1 = xlsread(['F:\IIT KHARAGPUR STUDY\Project\FinalDB 28aug2017\Final Codes(ULTIMATE BACKUP)\ThermalDatabase\Normal',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);


            %%%%%%%bringing the image to a scale of floating point 0.0-1.0
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            [row,col]=size(I1); %%%% Get rows and cols value
           
            %%%%%%%%%%%% histogram equalization 
            % I1 = adapthisteq(uint8(I1));
            I1 = adapthisteq((I1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

               folder_name=['..\..\..\ThermalDatabase\Normal\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];
               cd(folder_name);
               load('Face_Mask.mat');
               
               %%% trial(anjali_29_8_19)
               %mask_F_normal_lt=img_face_lt;
                %mask_F_normal_rt=img_face_rt;
              %%%%%%%%%%creating the mask from Ground truth ROI
               mask_F_normal_lt(1:row,1:col)=0; 
               col_mask=size(mask_F_normal_lt,2)-size(img_face_lt,2);
               mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=img_face_lt;
               mask_F_normal_rt(1:row,1:col)=0;
               mask_F_normal_rt(:,1:size(img_face_rt,2))=img_face_rt;
               %figure;imshow(mask_F_normal_lt);
               %figure;imshow(mask_F_normal_rt);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%% Extract Gabor features
            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
            GT_gabor_F_normal_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_normal_lt),sacle_idx); %%%%%% Input : Image , Mask , Scale Idx
            GT_gabor_F_normal_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_normal_rt),sacle_idx); %%%%%% Input : Image , Mask , Scale Idx
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            rel_path=['..\..\..\ThermalDatabase\Normal\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['GT_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name,'dir')% if folder name is there e.g('GT_Gabor_Han&Ma_Normal_Front_) no excecution
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('GT_Gabor_H&M_Normal_Front','GT_gabor_F_normal_lt','GT_gabor_F_normal_rt');
            
            cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';
            end
          
%%
%Malignant Subjects  

            d = dir('..\..\..\ThermalDatabase\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            nameFolds2=nameFolds;
            
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);


            %%%%%%%bringing the image to a scale of floating point 0.0-1.0
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [row,col]=size(I1);
            I1 = adapthisteq((I1));

              %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\ThermalDatabase\Malignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            %%%%%%%%%%creating the mask from Ground truth ROI
            mask_F_malignant_lt(1:row,1:col)=0;
            col_mask=size(mask_F_malignant_lt,2)-size(img_face_lt,2);
            mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=img_face_lt;
            mask_F_malignant_rt(1:row,1:col)=0;
            mask_F_malignant_rt(:,1:size(img_face_rt,2))=img_face_rt;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%% Extract Gabor features
            
            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
            GT_gabor_F_malignant_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_malignant_lt),sacle_idx);
            GT_gabor_F_malignant_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_malignant_rt),sacle_idx);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            rel_path=['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['GT_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx}];
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
               save('GT_Gabor_H&M_Malignant_Front','GT_gabor_F_malignant_lt','GT_gabor_F_malignant_rt');

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

            %%%%%%%bringing the image to a scale of floating point 0.0-1.0
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            [row,col]=size(I1);
             I1 = adapthisteq((I1));

            %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['..\..\..\ThermalDatabase\NonMalignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
             %%%%%%%%%%creating the mask from Ground truth ROI
            mask_F_precancer_lt(1:row,1:col)=0;
            col_mask=size(mask_F_precancer_lt,2)-size(img_face_lt,2);
            mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=img_face_lt;
            mask_F_precancer_rt(1:row,1:col)=0;
            mask_F_precancer_rt(:,1:size(img_face_rt,2))=img_face_rt;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

           %%%%% Extract Gabor features
            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
            GT_gabor_F_precancer_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_precancer_lt),sacle_idx);
            GT_gabor_F_precancer_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_precancer_rt),sacle_idx);
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

            rel_path=['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['GT_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}];
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
               save('GT_Gabor_H&M_Precancer_Front','GT_gabor_F_precancer_lt','GT_gabor_F_precancer_rt');

            cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';

    
            end
            


end