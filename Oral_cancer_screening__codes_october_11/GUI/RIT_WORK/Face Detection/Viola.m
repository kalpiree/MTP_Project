    %% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%  d = dir('D:\Work\ThermalOOC_Manashi\Normal'); % Reading Dir of the Specified Folder
%  d = dir('D:\Work\ThermalOOC_Manashi\Malignant'); % Reading Dir of the Specified Folder
 d = dir('D:\Work\ThermalOOC_Manashi\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
disp(nameFolds(folder_idx))
close all;
%       I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);
%  I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
   I_F=xlsread(['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    I_F=mat2gray(I_F);
faceDetector = vision.CascadeObjectDetector;
I = mat2gray(I_F);
bboxes = step(faceDetector, I);
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
figure, imshow(mat2gray(IFaces)), title(nameFolds{folder_idx});
% 
if isempty(bboxes)==isempty([])
lt_boundary_col=0;
rt_boundary_col=0;
upper_boundary_row=0;
lower_boundary_row=0;
else

lt_boundary_col=(bboxes(1)+bboxes(3));
rt_boundary_col=(bboxes(1));
upper_boundary_row=(bboxes(2));
lower_boundary_row=(bboxes(2)+bboxes(4));
        
end
%       direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
%   direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
  direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
 
save(direc,'lt_boundary_col','rt_boundary_col','upper_boundary_row','lower_boundary_row');

end   
