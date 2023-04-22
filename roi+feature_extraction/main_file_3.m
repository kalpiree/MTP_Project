d= dir('C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\Non malignant');
%"C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\Non malignant"
isub = [d(:).isdir];
nameFolds = {d(isub).name};
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%nameFolds(1)
for folder_idx= 1:no_dir
    fprintf('Processing Patient ID '); disp(nameFolds(folder_idx));
    I_F=xlsread(['C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\Non malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    [A_ROI_R_img, A_ROI_L_img] = frontface(I_F);
    rel_path=['C:\Users\ntnbs\Downloads\Database\Non malignant\',nameFolds{folder_idx}];
    folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
    cd(rel_path);
    if  ~exist(folder_name)
        mkdir(folder_name);
        cd(folder_name);
    else
        
        rmdir(folder_name,'s');
        mkdir(folder_name);
        cd(folder_name);
    end
    imwrite(A_ROI_R_img, 'A_ROI_frontalR_img.png');
    imwrite(A_ROI_L_img, 'A_ROI_frontalL_img.png');
    %rel_path=['C:\Users\ntnbs\Downloads\Database\Malignant\',nameFolds{folder_idx}];
    %folder_name=['A_ROI_Profile_' nameFolds{folder_idx}];
    %cd(rel_path);
    
    I_F_1=xlsread(['C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\Non malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
    I_F_2=xlsread(['C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\Non malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
    [ROI_o,ROI_O] = side_face(I_F_1,I_F_2);
    folder_name=['A_ROI_Profile_' nameFolds{folder_idx}];
    %rel_path=['C:\Users\ntnbs\Downloads\Database\Malignant\',nameFolds{folder_idx}];
    cd(rel_path);
    if  ~exist(folder_name)
        mkdir(folder_name);
        cd(folder_name);
    else
        
        rmdir(folder_name,'s');
        mkdir(folder_name);
        cd(folder_name);
    end
    imwrite(ROI_o, 'A_ROI_profileL_img.png');
    imwrite(ROI_O, 'A_ROI_profileR_img.png');
end