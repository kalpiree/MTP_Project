

%function AROI_ComputeGaborIR_Frontal(sacle_idx)

close all;

%sacle_idx= 2;

% 'Precancerous Subjects'  

            %d = dir('..\..\..\ThermalDatabase\NonMalignant');
           
            %isub = [d(:).isdir]; %# returns logical vector
            %nameFolds = {d(isub).name}';
            %nameFolds=nameFolds(3:end);
            %no_dir=numel(nameFolds);
            %for folder_idx=1:no_dir
            %disp(nameFolds(folder_idx)); 
            %close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            %I1 = xlsread(['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
            I1 = xlsread('C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129\P0129.csv');
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
            %rel_path=['..\..\..\ThermalDatabase\NonMalignant\' nameFolds{folder_idx}];
            %rel_path=("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0088");
            cd("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129");
            %folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
            folder_name=("A_ROI_Front_P0129");
            cd(folder_name);
            load('A_ROI_Front.mat');
            AROI_mask_F_precancer_lt=A_ROI_L;
            AROI_mask_F_precancer_rt=A_ROI_R;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd("C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456");
            for sacle_idx=2:6

            AROI_gabor_F_precancer_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_precancer_lt),sacle_idx);
            AROI_gabor_F_precancer_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(AROI_mask_F_precancer_rt),sacle_idx);
            
            cd("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129");
            folder_name=['AROI_Gabor_Han&Ma_precancer_Front_P0129__',num2str(sacle_idx)];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129");
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AROI_Gabor_H&M_Precancer_Front','AROI_gabor_F_precancer_lt','AROI_gabor_F_precancer_rt');

            end
            %rel_path=['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129");
            folder_name=['AROI_Gabor_Han&Ma_precancer_Front_P0129__'];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd("C:\Users\ntnbs\Downloads\trial\ThermalDatabase\ThermalDatabase\Non malignant\P0129");
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AROI_Gabor_H&M_Precancer_Front','AROI_gabor_F_precancer_lt','AROI_gabor_F_precancer_rt');

            %cd '..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';

    
           
%end