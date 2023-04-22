%%
clear;
clc;
close all;

%%
choice=choosedialog
switch(choice)
   case 'Normal Subjects' 
            d = dir('F:\MS\matlab_code\WORK\ThermalDatabase_OOC\Normal');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:63
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);
%             I1 = adapthisteq(I1);
%             [row col]=size(I1);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval);
%             figure, imshow(I1,[]);

            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);
            
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=1/(maxval-minval);
%             I1=range.*(I1-minval);
            
            %-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\ThermalDatabase_OOC\Normal\', nameFolds{folder_idx}, '\GT_ROI_Front_' nameFolds{folder_idx}];

            cd(folder_name);
            load('GT_ROI_Front.mat');
              
             mask_F_normal_lt(1:row,1:col)=0;
            col_mask=size(mask_F_normal_lt,2)-size(GT_ROI_L,2);
            mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=GT_ROI_L;


            mask_F_normal_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_normal_rt(:,1:size(GT_ROI_R,2))=GT_ROI_R;

            %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
%             
%             folder_name=['..\..\..\ThermalDatabase_OOC\Normal\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];
% 
%             cd(folder_name);
%             load('A_ROI_Front.mat');
%             
%             mask_F_normal_lt(1:row,1:col)=0;
%             col_mask=size(mask_F_normal_lt,2)-size(A_ROI_L,2);
%             mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=A_ROI_L;
% 
%             mask_F_normal_rt(1:row,1:col)=0;
%             % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
%             mask_F_normal_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
%             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



            cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';

            MR8_F_normal_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_normal_lt));
            MR8_F_normal_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_normal_rt));
%              R1=1; P1=8; R2=3; P2=8;
%              mapping=getmapnew(P1,'u2');
%               MR8_F_normal_lt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_lt),I1,R1,P1, R2, P2, mapping );
%              MR8_F_normal_rt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_rt),I1, R1,P1, R2, P2, mapping);




            rel_path=['..\..\..\ThermalDatabase_OOC\Normal\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['GT_MR8_Normal_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
%                 if ~exist(folder_name)
%                     mkdir(folder_name);
%                     cd(folder_name);
%                 else
%                     cd(folder_name);
%                 end
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('GT_MR8_Normal_Front','GT_MR8_F_normal_lt','GT_MR8_F_normal_rt');
            
            cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';

            end
    case  'Malignant Subjects'  

            d = dir('..\..\..\ThermalDatabase_OOC\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase_OOC\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%             I1 = adapthisteq(I1);

%             [row,col]=size(I1);
% 
%             [row col]=size(I1);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval);
% %             figure, imshow(I1,[]);

            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=1/(maxval-minval);
%             I1=range.*(I1-minval);
            %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\ThermalDatabase_OOC\Malignant\', nameFolds{folder_idx}, '\GT_ROI_Front_' nameFolds{folder_idx}];

            cd(folder_name);
            load('GT_ROI_Front.mat');
            mask_F_malignant_lt(1:row,1:col)=0;
            col_mask=size(mask_F_malignant_lt,2)-size(GT_ROI_L,2);
            mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=GT_ROI_L;


            mask_F_malignant_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_malignant_rt(:,1:size(GT_ROI_R,2))=GT_ROI_R;
            %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
            
%             folder_name=['..\..\..\ThermalDatabase_OOC\Malignant\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];
% 
%             cd(folder_name);
%             load('A_ROI_Front.mat');
%             
%             mask_F_malignant_lt(1:row,1:col)=0;
%             col_mask=size(mask_F_malignant_lt,2)-size(A_ROI_L,2);
%             mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=A_ROI_L;
% 
%             mask_F_malignant_rt(1:row,1:col)=0;
%             % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
%             mask_F_malignant_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
%             
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            


            cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';

            MR8_F_malignant_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_malignant_lt));
            MR8_F_malignant_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_malignant_rt));

%             R1=1; P1=8; R2=3; P2=8;
%              mapping=getmapnew(P1,'u2');
%               MR8_F_normal_lt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_lt),I1,R1,P1, R2, P2, mapping );
%              MR8_F_normal_rt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_rt),I1, R1,P1, R2, P2, mapping);


            rel_path=['..\..\..\ThermalDatabase_OOC\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['GT_MR8_Malignant_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('GT_MR8_Malignant_Front','GT_MR8_F_malignant_lt','GT_MR8_F_malignant_rt');

            cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';

            end     
        case  'Precancerous Subjects'  

             d = dir('..\..\..\ThermalDatabase_OOC\NonMalignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%             I1 = adapthisteq(I1);

%             [row,col]=size(I1);
% 
%             [row col]=size(I1);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval);
%             figure, imshow(I1,[]);
% 
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);
            
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=1/(maxval-minval);
%             I1=range.*(I1-minval);
%             %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['..\..\..\ThermalDatabase_OOC\NonMalignant\', nameFolds{folder_idx}, '\GT_ROI_Front_' nameFolds{folder_idx}];

            cd(folder_name);
            load('GT_ROI_Front.mat');
            mask_F_precancer_lt(1:row,1:col)=0;
            col_mask=size(mask_F_precancer_lt,2)-size(GT_ROI_L,2);
            mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=GT_ROI_L;


            mask_F_precancer_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_precancer_rt(:,1:size(GT_ROI_R,2))=GT_ROI_R;


             %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
%             
%             folder_name=['..\..\..\ThermalDatabase_OOC\NonMalignant\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];
% 
%             cd(folder_name);
%             load('A_ROI_Front.mat');
%             
%             mask_F_precancer_lt(1:row,1:col)=0;
%             col_mask=size(mask_F_precancer_lt,2)-size(A_ROI_L,2);
%             mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=A_ROI_L;
% 
%             mask_F_precancer_rt(1:row,1:col)=0;
%             % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
%             mask_F_precancer_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
%             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';

            MR8_F_precancer_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_precancer_lt));
            MR8_F_precancer_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_precancer_rt));
            
%             R1=1; P1=8; R2=3; P2=8;
%              mapping=getmapnew(P1,'u2');
%              MR8_F_normal_lt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_lt),I1,R1,P1, R2, P2, mapping );
%              MR8_F_normal_rt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_rt),I1, R1,P1, R2, P2, mapping);

            rel_path=['..\..\..\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['GT_MR8_precancer_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('GT_MR8_Precancer_Front','GT_MR8_F_precancer_lt','GT_MR8_F_precancer_rt');

            cd '..\..\..\..\SPIE_2017\Rahul_da_Texture_Features\Program For MR8';

            end     
 otherwise
      fprintf('Invalid operation\n' );
end