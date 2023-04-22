%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('..\..\ThermalDatabase\Normal'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:no_dir
%% Normal  
     direc_PN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
     direc_PRN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
     direc_AN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
     direc_VN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
     Ground_direc=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];    
    
    [IOU_PN(folder_idx),Dice_PN(folder_idx),E1_PN(folder_idx),E2_PN(folder_idx)] = Metrics_Evaluator(direc_PN,Ground_direc);
    [IOU_PRN(folder_idx),Dice_PRN(folder_idx),E1_PRN(folder_idx),E2_PRN(folder_idx)] = Metrics_Evaluator(direc_PRN,Ground_direc);
    [IOU_AN(folder_idx),Dice_AN(folder_idx),E1_AN(folder_idx),E2_AN(folder_idx)] = Metrics_Evaluator(direc_AN,Ground_direc);
    [IOU_VN(folder_idx),Dice_VN(folder_idx),E1_VN(folder_idx),E2_VN(folder_idx)] = Metrics_Evaluator(direc_VN,Ground_direc);

end
%% Malignant
d = dir('..\..\ThermalDatabase\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
%% Malignant  
     direc_PM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
     direc_PRM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
     direc_AM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
     direc_VM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
     Ground_direc=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];    
    
    [IOU_PM(folder_idx),Dice_PM(folder_idx),E1_PM(folder_idx),E2_PM(folder_idx)] = Metrics_Evaluator(direc_PM,Ground_direc);
    [IOU_PRM(folder_idx),Dice_PRM(folder_idx),E1_PRM(folder_idx),E2_PRM(folder_idx)] = Metrics_Evaluator(direc_PRM,Ground_direc);
    [IOU_AM(folder_idx),Dice_AM(folder_idx),E1_AM(folder_idx),E2_AM(folder_idx)] = Metrics_Evaluator(direc_AM,Ground_direc);
    [IOU_VM(folder_idx),Dice_VM(folder_idx),E1_VM(folder_idx),E2_VM(folder_idx)] = Metrics_Evaluator(direc_VM,Ground_direc);

end
%% Non-Malignant
d = dir('..\..\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:no_dir
%%N Malignant  
     direc_PNM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
     direc_PRNM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
     direc_ANM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
     direc_VNM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
     Ground_direc=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];    
    
    [IOU_PNM(folder_idx),Dice_PNM(folder_idx),E1_PNM(folder_idx),E2_PNM(folder_idx)] = Metrics_Evaluator(direc_PNM,Ground_direc);
    [IOU_PRNM(folder_idx),Dice_PRNM(folder_idx),E1_PRNM(folder_idx),E2_PRNM(folder_idx)] = Metrics_Evaluator(direc_PRNM,Ground_direc);
    [IOU_ANM(folder_idx),Dice_ANM(folder_idx),E1_ANM(folder_idx),E2_ANM(folder_idx)] = Metrics_Evaluator(direc_ANM,Ground_direc);
    [IOU_VNM(folder_idx),Dice_VNM(folder_idx),E1_VNM(folder_idx),E2_VNM(folder_idx)] = Metrics_Evaluator(direc_VNM,Ground_direc);

end
IOU_P=[IOU_PN, IOU_PM, IOU_PNM];
IOU_PR=[IOU_PRN, IOU_PRM, IOU_PRNM];
IOU_A=[IOU_AN, IOU_AM, IOU_ANM];
IOU_V=[IOU_VN, IOU_VM, IOU_VNM];

E1_P=[E1_PN, E1_PM, E1_PNM];
E1_PR=[E1_PRN, E1_PRM, E1_PRNM];
E1_A=[E1_AN, E1_AM, E1_ANM];
E1_V=[E1_VN, E1_VM, E1_VNM];

E2_P=[E2_PN, E2_PM, E2_PNM];
E2_PR=[E2_PRN, E2_PRM, E2_PRNM];
E2_A=[E2_AN, E2_AM, E2_ANM];
E2_V=[E2_VN, E2_VM, E2_VNM];

Dice_P=[Dice_PN, Dice_PM, Dice_PNM];
Dice_PR=[Dice_PRN, Dice_PRM, Dice_PRNM];
Dice_A=[Dice_AN, Dice_AM, Dice_ANM];
Dice_V=[Dice_VN, Dice_VM, Dice_VNM];

IOU_Proposed_M=mean(IOU_P);
IOU_Proposed_S=std(IOU_P);
IOU_PR_M=mean(IOU_PR);
IOU_PR_S=std(IOU_PR);
IOU_ACCEE_M=mean(IOU_A);
IOU_ACCEE_S=std(IOU_A);
IOU_Viola_M=mean(IOU_V);
IOU_Viola_S=std(IOU_V);

E1_Proposed_M=mean(E1_P);
E1_Proposed_S=std(E1_P);
E1_PR_M=mean(E1_PR);
E1_PR_S=std(E1_PR);
E1_ACCEE_M=mean(E1_A);
E1_ACCEE_S=std(E1_A);
E1_Viola_M=mean(E1_V);
E1_Viola_S=std(E1_V);

E2_Proposed_M=mean(E2_P);
E2_Proposed_S=std(E2_P);
E2_PR_M=mean(E2_PR);
E2_PR_S=std(E2_PR);
E2_ACCEE_M=mean(E2_A);
E2_ACCEE_S=std(E2_A);
E2_Viola_M=mean(E2_V);
E2_Viola_S=std(E2_V);

Dice_Proposed_M=mean(Dice_P);
Dice_Proposed_S=std(Dice_P);
Dice_PR_M=mean(Dice_PR);
Dice_PR_S=std(Dice_PR);
Dice_ACCEE_M=mean(Dice_A);
Dice_ACCEE_S=std(Dice_A);
Dice_Viola_M=mean(Dice_V);
Dice_Viola_S=std(Dice_V);