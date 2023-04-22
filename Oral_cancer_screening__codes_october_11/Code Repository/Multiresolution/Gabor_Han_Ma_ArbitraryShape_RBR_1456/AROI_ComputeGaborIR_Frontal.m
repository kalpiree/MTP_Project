% =========================== AROI_ComputeGaborIR_Frontal.m ====================================== %
% Description  : 
% 
%
%
% ================================================================================== %
% Input Parameters : sacle_idx: scale of gabor filter
%                    
%------------------------------------------------------------------------------------%  
% Output parameter:  AROI_Gabor_H&M_Normal_Front 
%                    AROI_GT_gabor_F_normal_lt   
%                    AROI_GT_gabor_F_normal_rt
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

function AROI_ComputeGaborIR_Frontal(sacle_idx)
%%

close all;

%%'Normal Subjects' 
            d = dir('..\..\..\ThermalDatabase\Normal');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           

          
            I1 = adapthisteq((I1)); 
 
            [row,col]=size(I1);
            

           %-------------------Loading the left and right ROI (Automated ROI) -------------------------------------------------------------------------------------------%
            rel_path=['..\..\..\ThermalDatabase\Normal\' nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
            cd(folder_name);
            load('A_ROI_Front.mat');
            AROI_mask_F_normal_lt=A_ROI_L;
            AROI_mask_F_normal_rt=A_ROI_R;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
            AROI_gabor_F_normal_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_normal_lt),sacle_idx);
            AROI_gabor_F_normal_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_normal_rt),sacle_idx);


            rel_path=['..\..\..\ThermalDatabase\Normal\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AROI_Gabor_Han&Ma_Normal_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name,'dir')
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('AROI_Gabor_H&M_Normal_Front','AROI_gabor_F_normal_lt','AROI_gabor_F_normal_rt');
            
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
            I1 = adapthisteq((I1)); 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            [row,col]=size(I1);
             %-------------------Loading the left and right ROI (Automated ROI) -------------------------------------------------------------------------------------------%
            rel_path=['..\..\..\ThermalDatabase\Malignant\' nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
            cd(folder_name);
            load('A_ROI_Front.mat');
            AROI_mask_F_malignant_lt=A_ROI_L;
            AROI_mask_F_malignant_rt=A_ROI_R;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');

            AROI_gabor_F_malignant_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_malignant_lt),sacle_idx);
            AROI_gabor_F_malignant_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_malignant_rt),sacle_idx);


            rel_path=['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AROI_Gabor_Han&Ma_Malignant_Front_' nameFolds{folder_idx}];
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
               save('AROI_Gabor_H&M_Malignant_Front','AROI_gabor_F_malignant_lt','AROI_gabor_F_malignant_rt');

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            I1 = adapthisteq((I1)); 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
           

            [row,col]=size(I1);
             %-------------------Loading the left and right ROI (Automated ROI) -------------------------------------------------------------------------------------------%
            rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
            cd(folder_name);
            load('A_ROI_Front.mat');
            AROI_mask_F_precancer_lt=A_ROI_L;
            AROI_mask_F_precancer_rt=A_ROI_R;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd('..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');

            AROI_gabor_F_precancer_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_precancer_lt),sacle_idx);
            AROI_gabor_F_precancer_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_precancer_rt),sacle_idx);


            rel_path=['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AROI_Gabor_Han&Ma_precancer_Front_' nameFolds{folder_idx}];
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
               save('AROI_Gabor_H&M_Precancer_Front','AROI_gabor_F_precancer_lt','AROI_gabor_F_precancer_rt');

            cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';

    
           end
end