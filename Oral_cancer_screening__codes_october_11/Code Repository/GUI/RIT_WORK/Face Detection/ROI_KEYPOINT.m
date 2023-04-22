clear all 
close all
clc
%%
%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
% d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
% d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%% 
for folder_idx=1:63
direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','A_ROI_L','.mat'];
% direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','A_ROI_R','.mat'];

% direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L','.mat'];
% direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R','.mat'];
% 
% direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','A_ROI_L','.mat'];
% direc=['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\','A_ROI_R','.mat'];
load(direc);

Detected_Left_Mask(1:480,1:640)=0;
Ground_Left_Mask(1:480,1:640)=0;

Detected_Right_Mask(1:480,1:640)=0;
Ground_Right_Mask(1:480,1:640)=0;

for row_index=1:size(Left_Img,1)
    for col_index=1:size(Left_Img,2);
        if(Left_Img(row_index,col_index)~=0)
            Detected_Left_Mask=1;
        end
    end
end

for row_index=1:size(Right_Img,1)
    for col_index=1:size(Right_Img,2);
        if(Right_Img(row_index,col_index)~=0)
            Detected_Right_Mask=1;
        end
    end
end

%% XOR METRIC
Product_mask_Left=(xor(Detected_Left_Mask(1:480,1:640),Ground_Left_Mask(1:480,1:640)));
Product_mask_Right=(xor(Detected_Right_Mask(1:480,1:640),Ground_Right_Mask(1:480,1:640)));
        
E1_Normal_Left(folder_idx)=nnz(Product_mask_Left);
E1_Normal_Left(folder_idx)=E1_Normal_Left(folder_idx)/(480*640);

E1_Normal_Right(folder_idx)=nnz(Product_mask_Right);
E1_Normal_Right(folder_idx)=E1_Normal_Right(folder_idx)/(480*640);

%% IOU Metric
Intersection_Left=not(and(Detected_Left_Mask(1:480,1:640),Ground_Left_Mask(1:480,1:640)));
Union_Left=not(or(Detected_Left_Mask(1:480,1:640),Ground_Left_Mask(1:480,1:640)));

IOU_Left=Intersection_Left/Union_Left;


Intersection_Right=not(and(Detected_Right_Mask(1:480,1:640),Ground_Right_Mask(1:480,1:640)));
Union_Right=not(or(Detected_Right_Mask(1:480,1:640),Ground_Right_Mask(1:480,1:640)));

IOU_Right=Intersection_Right/Union_Right;
end

