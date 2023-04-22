        clear;
        clc;
        close all;
        % path from where database is taken and saved
        %saving_path='C:\Users\A N K I T 16EC\Desktop\profile face infra';
        %database_path= 'E:\MTech work\ThermalDatabase\NonMalignant';
        saving_path='F:\PostGraduation\oralcancer\profile face infra_ankit';
        database_path='F:\PostGraduation\Project\Manashi\ThermalDatabase\NonMalignant';
        
        % % % % % % % % % % % % % % % % % % % % 

        
        cd(saving_path);
        d = dir(database_path);

        % read the database from each paitent folder
        isub = [d(:).isdir]; %# returns logical vector
        nameFolds = {d(isub).name};
        nameFolds=nameFolds(3:end);
        no_dir=numel(nameFolds);
        % % % % % % % % % % % % % % % % % % % % % 

        for folder_idx=1:no_dir

        close all;

        %%
        % Read the image in matrix format of double type in I1
        % Change the directory to address from where you want to read
        % I1 = xlsread(['E:\MTech work\ThermalDatabase\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'_lt.csv']);

        %I1 = xlsread(['F:\kgp_study\Project\Manashi Codes\ThermalDatabase\NonMalignant',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
        
        

        I1 = xlsread(['F:\PostGraduation\Project\Manashi\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
        csv= I1;
        % % % % % % % % % % % % % % % % % % % % % % % % % 
        
        %%
        
        % Scale the Image from 0-255
        maxval=max(max(I1));
        minval=min(min(I1));
        range=255/(maxval-minval);
        I1=range.*(I1-minval); 
        I1 = uint8(I1); 
        originalimg=I1;
%         figure,imshow(originalimg)
%         mkdir(['F:\PostGraduation\Project\Manashi\thermal db\Malignant\',nameFolds{folder_idx},'\','stage']);
        %imshow(originalimg);
         imwrite(originalimg,['F:\PostGraduation\Project\Manashi\stages\jpeg\NonMalignant\',nameFolds{folder_idx},'_lt.jpg'],'jpg');
        %%

        % % % % % gamma correction for mask generation
        gamma = 1.2;
        I1=uint8(1.*((double(I1)).^gamma));
        % % % % % % % % % % % % % % % % % % % % % % % % % 
        imwrite(I1,['F:\PostGraduation\Project\Manashi\stages\gamma_corrected\NonMalignant\',nameFolds{folder_idx},'_gamma_lt.jpg'],'jpg');
        %figure,imshow(I1);
        %% 2.Thresholding to segment out facial region
        %KITTLERMINIMIMERRORTHRESHOLDING Compute an optimal image threshold.
        %   Computes the Minimum Error Threshold as described in
        %   
        %   'J. Kittler and J. Illingworth, "Minimum Error Thresholding," Pattern
        %   Recognition 19, 41-47 (1986)'.
        %temp = (max(I1))
        [ T, J ] = kittlerMinimimErrorThresholding( I1 );
        T = round(T);
        mask = imbinarize(I1, 254/255);
        
        % Get the biggest CLuster
        mask = bwareafilt(logical(mask),1);
        %figure,imshow(mask);
        % closing operation to remuve small objects
        SE = strel('square',2);
        mask = imclose(mask,SE);
        figure,imshow(mask);
        
        [slope, constant, neck_col, neck_row]=find_neck(mask);

        %%%% remove the parrt below neck
%         mask(neck_row:480, :) = 0; 
        figure,imshow(mask);
%         figure,imshow(originalimg)
        imwrite(mask,['F:\PostGraduation\Project\Manashi\Stages\after_neck_detection\NonMalignant\',nameFolds{folder_idx},'_Face_detection_lt.jpg'],'jpg');
        %%%% Get the tip row and column
       [tip_row,tip_col]= nose_tip(mask);
       
%        for i=1:20:480
            hor_pro = sum(mask,2);
            u_b_ar = find(hor_pro>0);
            u_b = u_b_ar(1);
%             if hor_pro>0
%                 l_b=i;
%             end 
%        end
       l_up=tip_row-0.8*u_b;
       l_lo=tip_row+l_up;
       
       if l_lo<480
       mask=mask(u_b:l_lo,:);
       end
       
       figure,imshow(mask);
       imwrite(mask,['F:\PostGraduation\Project\Manashi\Stages\Modified boundary\NonMalignant\',nameFolds{folder_idx},'_modified_boundary_lt.jpg'],'jpg');
        end 
            



