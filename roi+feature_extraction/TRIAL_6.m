lt= xlsread("C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\dataset new\Malignant\P0099\P0099_lt.csv");
        %rt=xlsread([dir,'\',nameFolds,'_rt.csv']);
rt=xlsread("C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\dataset new\Malignant\P0099\P0099_rt.csv");
[ROI_o,ROI_O] = side_face(lt,rt);
%figure,imshow(ROI_O)
%figure,imshow(ROI_o)
I_F=xlsread("C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\dataset new\Malignant\P0099\P0099.csv");
[A_ROI_R_img, A_ROI_L_img] = frontface(I_F);
%figure,imshow(A_ROI_R_img);
%figure,imshow(A_ROI_L_img);
rel_path=['C:\Users\ntnbs\Downloads\trial\Malignant'];%,nameFolds{folder_idx}];
folder_name=['A_ROI_Front_'];
    cd(rel_path);
    if  ~exist(folder_name)
        mkdir(folder_name);
        cd(folder_name);
    else
        
        rmdir(folder_name,'s');
        mkdir(folder_name);
        cd(folder_name);
    end
    save('A_ROI_R_img');
    imwrite(A_ROI_R_img, 'my image.png');
    imwrite(A_ROI_R_img, 'my image_1.png');
    imwrite(ROI_O, 'my image_2.png');
    imwrite(ROI_o, 'my image_3.png');
    
    save ('A_ROI_L_img');
    
    