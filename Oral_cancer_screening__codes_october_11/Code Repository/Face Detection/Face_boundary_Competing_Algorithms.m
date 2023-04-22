close all
clear all
clc
%% Generate face Boundaries for Normal Images - Competing Algorithms
d = dir('..\..\ThermalDatabase\Normal'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
% 
for folder_idx=1:no_dir,

    I_F=xlsread(['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    
    % Proposed Algorithm
    [I_new,mask_F,r_c_PN,l_c_PN,l_r_PN,u_r_PN] = face_detect( I_F,nameFolds,folder_idx );
    direc_PN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_PN;
    lt_boundary_col=l_c_PN;
    upper_boundary_row=l_r_PN;
    lower_boundary_row=u_r_PN;
    save(direc_PN,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');  
    
    % PR-Paper
    [I_new,mask_F,r_c_PRN,l_c_PRN,l_r_PRN,u_r_PRN] = face_detect_PR_original( I_F,nameFolds,folder_idx );
    direc_PRN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_PRN;
    lt_boundary_col=l_c_PRN;
    upper_boundary_row=l_r_PRN;
    lower_boundary_row=u_r_PRN;
    save(direc_PRN,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
 
    % ACCEE-Paper
    [I_new,mask_F,r_c_AN,l_c_AN,l_r_AN,u_r_AN] = face_detect_ACCEE( I_F,nameFolds,folder_idx );
    direc_AN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_AN;
    lt_boundary_col=l_c_AN;
    upper_boundary_row=l_r_AN;
    lower_boundary_row=u_r_AN;
    save(direc_AN,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
    
    % Viola
    [I_new,mask_F,r_c_VN,l_c_VN,l_r_VN,u_r_VN] = face_detect_viola( I_F,nameFolds,folder_idx );
    direc_VN=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_VN;
    lt_boundary_col=l_c_VN;
    upper_boundary_row=l_r_VN;
    lower_boundary_row=u_r_VN;
    save(direc_VN,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
       
end

%% Generate face Boundaries for Malignant Images - Competing Algorithms
d = dir('..\..\ThermalDatabase\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:no_dir,

    I_F=xlsread(['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    
    % Proposed Algorithm
    [I_new,mask_F,r_c_PM,l_c_PM,l_r_PM,u_r_PM] = face_detect( I_F,nameFolds,folder_idx );
    direc_PM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_PM;
    lt_boundary_col=l_c_PM;
    upper_boundary_row=l_r_PM;
    lower_boundary_row=u_r_PM;
    save(direc_PM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');  
    
    % PR-Paper
    [I_new,mask_F,r_c_PRM,l_c_PRM,l_r_PRM,u_r_PRM] = face_detect_PR_original( I_F,nameFolds,folder_idx );
    direc_PRM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_PRM;
    lt_boundary_col=l_c_PRM;
    upper_boundary_row=l_r_PRM;
    lower_boundary_row=u_r_PRM;
    save(direc_PRM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
 
    % ACCEE-Paper
    [I_new,mask_F,r_c_AM,l_c_AM,l_r_AM,u_r_AM] = face_detect_ACCEE( I_F,nameFolds,folder_idx );
    direc_AM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_AM;
    lt_boundary_col=l_c_AM;
    upper_boundary_row=l_r_AM;
    lower_boundary_row=u_r_AM;
    save(direc_AM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
    
    % Viola
    [I_new,mask_F,r_c_VM,l_c_VM,l_r_VM,u_r_VM] = face_detect_viola( I_F,nameFolds,folder_idx );
    direc_VM=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_VM;
    lt_boundary_col=l_c_VM;
    upper_boundary_row=l_r_VM;
    lower_boundary_row=u_r_VM;
    save(direc_VM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
       
end


%% Generate face Boundaries for NonMalignant Images - Competing Algorithms
d = dir('..\..\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:no_dir,

    I_F=xlsread(['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    
    % Proposed Algorithm
    [I_new,mask_F,r_c_PNM,l_c_PNM,l_r_PNM,u_r_PNM] = face_detect( I_F,nameFolds,folder_idx );
    direc_PNM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_PNM;
    lt_boundary_col=l_c_PNM;
    upper_boundary_row=l_r_PNM;
    lower_boundary_row=u_r_PNM;
    save(direc_PNM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');  
    
    % PR-Paper
    [I_new,mask_F,r_c_PRNM,l_c_PRNM,l_r_PRNM,u_r_PRNM] = face_detect_PR_original( I_F,nameFolds,folder_idx );
    direc_PRNM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_PRNM;
    lt_boundary_col=l_c_PRNM;
    upper_boundary_row=l_r_PRNM;
    lower_boundary_row=u_r_PRNM;
    save(direc_PRNM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
 
    % ACCEE-Paper
    [I_new,mask_F,r_c_ANM,l_c_ANM,l_r_ANM,u_r_ANM] = face_detect_ACCEE( I_F,nameFolds,folder_idx );
    direc_ANM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_ANM;
    lt_boundary_col=l_c_ANM;
    upper_boundary_row=l_r_ANM;
    lower_boundary_row=u_r_ANM;
    save(direc_ANM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
    
    % Viola
    [I_new,mask_F,r_c_VNM,l_c_VNM,l_r_VNM,u_r_VNM] = face_detect_viola( I_F,nameFolds,folder_idx );
    direc_VNM=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
    rt_boundary_col=r_c_VNM;
    lt_boundary_col=l_c_VNM;
    upper_boundary_row=l_r_VNM;
    lower_boundary_row=u_r_VNM;
    save(direc_VNM,'rt_boundary_col','lt_boundary_col','upper_boundary_row','lower_boundary_row');
       
end
