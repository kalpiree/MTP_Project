%"C:\Users\ntnbs\Downloads\Database\Normal"
%"C:\Users\ntnbs\Downloads\Database\Non malignant"
d= dir('C:\Users\ntnbs\Downloads\Database\Non malignant');
isub = [d(:).isdir];
nameFolds = {d(isub).name};
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%nameFolds(1)
Data1= zeros(1,1400);
V = array2table(Data1);
V= [V];
for folder_idx= 1:no_dir
    fprintf('Processing Patient ID '); disp(nameFolds(folder_idx));
    maxN = 10000;
    Data1 = zeros(1,maxN);
    q=1;
    %"C:\Users\ntnbs\Downloads\Database\Malignant\P0078\A_ROI_Front_P0078\A_ROI_frontalL_img.png"
    %I_F=xlsread(['C:\Users\ntnbs\Downloads\ThermalDatabase\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    I= imread(['C:\Users\ntnbs\Downloads\Database\Non malignant\',nameFolds{folder_idx},'\','A_ROI_Front_',nameFolds{folder_idx},'\','A_ROI_frontalL_img.png']);
    for bw = 1:1:5
        for theta = 0:30:180
            gb = gabor_self(I,bw,theta);
            Data1(1,q) = kurtosis(gb,1,'all');
            q=q+1;
            %yall = skewness(gb,1,'all');
            Data1(1,q) = skewness(gb,1,'all');
            q = q+1;
            %V = var(gb,1,"all");
            Data1(1,q) = var(gb,1,"all");
            q= q+1;
            %M= mean(gb,"all");
            Data1(1,q)= mean(gb,"all");
            q =q+1;
            glcm = graycomatrix(gb,'Offset',[-1 0;0 1;-1 1;-1 -1],'Symmetric',true);
            stats = graycoprops(glcm);
            %C = struct2cell(stats);
            %C(1)
            contrast = vertcat(stats.Contrast);
            Data1(1,q)= contrast(1);
            q=q+1;
            Data1(1,q)= contrast(2);
            q=q+1;
            Data1(1,q)= contrast(3);
            q=q+1;
            Data1(1,q)= contrast(4);
            q=q+1;
            correlation = vertcat(stats.Correlation);
            Data1(1,q)= correlation(1);
            q=q+1;
            Data1(1,q)= correlation(2);
            q=q+1;
            Data1(1,q)= correlation(3);
            q=q+1;
            Data1(1,q)= correlation(4);
            q=q+1;
            energy = vertcat(stats.Energy);
            Data1(1,q)= energy(1);
            q=q+1;
            Data1(1,q)= energy(2);
            q=q+1;
            Data1(1,q)= energy(3);
            q=q+1;
            Data1(1,q)= energy(4);
            q=q+1;
            homogeneity = vertcat(stats.Homogeneity);
            Data1(1,q)= homogeneity(1);
            q= q+1;
            Data1(1,q)= homogeneity(2);
            q= q+1;
            Data1(1,q)= homogeneity(3);
            q= q+1;
            Data1(1,q)= homogeneity(4);
            q= q+1;
        end
    end
    
    I= imread(['C:\Users\ntnbs\Downloads\Database\Non malignant\',nameFolds{folder_idx},'\','A_ROI_Front_',nameFolds{folder_idx},'\','A_ROI_frontalR_img.png']);
    for bw = 1:1:5
        for theta = 0:30:180
            gb = gabor_self(I,bw,theta);
            Data1(1,q) = kurtosis(gb,1,'all');
            q=q+1;
            %yall = skewness(gb,1,'all');
            Data1(1,q) = skewness(gb,1,'all');
            q = q+1;
            %V = var(gb,1,"all");
            Data1(1,q) = var(gb,1,"all");
            q= q+1;
            %M= mean(gb,"all");
            Data1(1,q)= mean(gb,"all");
            q =q+1;
            glcm = graycomatrix(gb,'Offset',[-1 0;0 1;-1 1;-1 -1],'Symmetric',true);
            stats = graycoprops(glcm);
            %C = struct2cell(stats);
            %C(1)
            contrast = vertcat(stats.Contrast);
            Data1(1,q)= contrast(1);
            q=q+1;
            Data1(1,q)= contrast(2);
            q=q+1;
            Data1(1,q)= contrast(3);
            q=q+1;
            Data1(1,q)= contrast(4);
            q=q+1;
            correlation = vertcat(stats.Correlation);
            Data1(1,q)= correlation(1);
            q=q+1;
            Data1(1,q)= correlation(2);
            q=q+1;
            Data1(1,q)= correlation(3);
            q=q+1;
            Data1(1,q)= correlation(4);
            q=q+1;
            energy = vertcat(stats.Energy);
            Data1(1,q)= energy(1);
            q=q+1;
            Data1(1,q)= energy(2);
            q=q+1;
            Data1(1,q)= energy(3);
            q=q+1;
            Data1(1,q)= energy(4);
            q=q+1;
            homogeneity = vertcat(stats.Homogeneity);
            Data1(1,q)= homogeneity(1);
            q= q+1;
            Data1(1,q)= homogeneity(2);
            q= q+1;
            Data1(1,q)= homogeneity(3);
            q= q+1;
            Data1(1,q)= homogeneity(4);
            q= q+1;
        end
    end
    
    
   
    
    Data1= Data1(1:q-1);
    S = array2table(Data1);
    V= [V;S];
    
    
end
 writetable(V,'non-malignant_frontal.csv');   
       
  
 
    
    