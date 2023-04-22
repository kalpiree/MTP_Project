clear all
close all;
%sacle_idx=2;
%%'Normal Subjects' 
            d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Normal');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            
            I1_lt = xlsread(['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
            I1_rt = xlsread(['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
            
            maxval_lt=max(max(I1_lt));
            minval_lt=min(min(I1_lt));
            range_lt=1/(maxval_lt-minval_lt);
            I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of 0.0-1.0
            
             
           
% 
            maxval_rt=max(max(I1_rt));
            minval_rt=min(min(I1_rt));
            range_rt=1/(maxval_rt-minval_rt);
            I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of 0.0-1.0
            
            [row_lt,col_lt]=size(I1_lt);
            
             I1_lt = adapthisteq((I1_lt));
             I1_rt = adapthisteq((I1_rt));
      %-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

                folder_name=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Normal\', nameFolds{folder_idx}, '\Automatic_Profile_ROI_' nameFolds{folder_idx}];
                %folder_name= ["C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Normal\T002\Profile_ROI_T002"

                cd(folder_name);
                load('A_face_mask.mat');
              
               mask_P_normal_lt(1:row_lt,1:col_lt)=0;
               col_mask=size(mask_P_normal_lt,2)-size(img_face_lt,2);
               mask_P_normal_lt(:,col_mask+1:size(mask_P_normal_lt,2))=img_face_lt;


               mask_P_normal_rt(1:row_lt,1:col_lt)=0;
               mask_P_normal_rt(:,1:size(img_face_rt,2))= img_face_rt;  
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
            for sacle_idx=2:6
            AROI_gabor_P_normal_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1_lt,logical(mask_P_normal_lt),sacle_idx);
            AROI_gabor_P_normal_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1_rt,logical(mask_P_normal_rt),sacle_idx);


            rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Normal\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AROI_Gabor_Han&Ma_Normal_Profile__' nameFolds{folder_idx} num2str(sacle_idx)];
            % rmdir(folder_name);
                if ~exist(folder_name,'dir')
                    mkdir(folder_name);
                    cd(folder_name);
                else

                    cd(folder_name);
                end
                save('AROI_Gabor_H&M_Normal_Profile','AROI_gabor_P_normal_lt','AROI_gabor_P_normal_rt');
            end
            
            cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';

            end
%
%%MALIGNANT%%%%%%%%%%%%%%%%%%%%%%%%%
            d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=100:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1_lt = xlsread(['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
            I1_rt = xlsread(['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);

           maxval_lt=max(max(I1_lt));
            minval_lt=min(min(I1_lt));
            range_lt=1/(maxval_lt-minval_lt);
            I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of 0.0-1.0


            [row_lt,col_lt]=size(I1_lt);

            maxval_rt=max(max(I1_rt));
            minval_rt=min(min(I1_rt));
            range_rt=1/(maxval_rt-minval_rt);
            I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of 0.0-1.0

              I1_lt = adapthisteq((I1_lt));
             I1_rt = adapthisteq((I1_rt));
           %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Malignant\', nameFolds{folder_idx}, '\Automatic_Profile_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('A_face_mask.mat');
            mask_P_malignant_lt(1:row_lt,1:col_lt)=0;
            col_mask=size(mask_P_malignant_lt,2)-size(img_face_lt,2);
            mask_P_malignant_lt(:,col_mask+1:size(mask_P_malignant_lt,2))=img_face_lt;


            mask_P_malignant_rt(1:row_lt,1:col_lt)=0;
            mask_P_malignant_rt(:,1:size(img_face_rt,2))=img_face_rt;
            

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
            
            for sacle_idx=2:6
            AROI_gabor_P_malignant_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1_lt,logical(mask_P_malignant_lt),sacle_idx);
            AROI_gabor_P_malignant_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1_rt,logical(mask_P_malignant_rt),sacle_idx);


            rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AROI_Gabor_Han&Ma_Malignant_Profile__' nameFolds{folder_idx} num2str(sacle_idx)];
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(folder_name);
                end
               save('AROI_Gabor_H&M_Malignant_Profile','AROI_gabor_P_malignant_lt','AROI_gabor_P_malignant_rt');
             
            end

            cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';

            end     
%
%%%%%%%%%%NONMALIGNANT%

            d = dir('C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\NonMalignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=100:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1_lt = xlsread(['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
            I1_rt = xlsread(['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);


         maxval_lt=max(max(I1_lt));
            minval_lt=min(min(I1_lt));
            range_lt=1/(maxval_lt-minval_lt);
            I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of 0.0-1.0


            [row_lt,col_lt]=size(I1_lt);
%             I1_rt=mat2gray(I1_rt);

            maxval_rt=max(max(I1_rt));
            minval_rt=min(min(I1_rt));
            range_rt=1/(maxval_rt-minval_rt);
            I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of 0.0-1.0
            
             I1_lt = adapthisteq((I1_lt));
             I1_rt = adapthisteq((I1_rt));


                   %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\NonMalignant\', nameFolds{folder_idx}, '\Profile_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('face_mask.mat');
            mask_P_precancer_lt(1:row_lt,1:col_lt)=0;
            col_mask=size(mask_P_precancer_lt,2)-size(img_face_lt,2);
            mask_P_precancer_lt(:,col_mask+1:size(mask_P_precancer_lt,2))=img_face_lt;


            mask_P_precancer_rt(1:row_lt,1:col_lt)=0;
            mask_P_precancer_rt(:,1:size(img_face_rt,2))=img_face_rt; 


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';
            
            for sacle_idx=2:6
            AROI_gabor_P_precancer_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1_lt,logical(mask_P_precancer_lt),sacle_idx);
            AROI_gabor_P_precancer_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1_rt,logical(mask_P_precancer_rt),sacle_idx);


            rel_path=['C:\Users\ntnbs\Downloads\trial\ThermalDatabase_old\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AROI_Gabor_Han&Ma_precancer_Profile_' nameFolds{folder_idx} num2str(sacle_idx)];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(folder_name);
                end
               save('AROI_Gabor_H&M_Precancer_Profile','AROI_gabor_P_precancer_lt','AROI_gabor_P_precancer_rt');
            end

            cd 'C:\Users\ntnbs\Downloads\trial\Oral_cancer_screening_previous_codes\Code Repository\Multiresolution\Gabor_Han_Ma_ArbitraryShape_RBR_1456';

            end    