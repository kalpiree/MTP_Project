close all
clear all
clc
%%
load('Terravic_data.mat');
for i=1:length(Terravic_data)
I_F=imread(Terravic_data(i).imageFilename);
original_row_size=50;
original_col_size=50;
final_row_size=100;
final_col_size=100;
I_F=imresize(I_F,[100 100]);
dest_path=Terravic_data(i).imageFilename;
imwrite(I_F,dest_path);
Terravic_data(i).objectBoundingBoxes(1)=Terravic_data(i).objectBoundingBoxes(1)*(final_col_size/original_col_size);
Terravic_data(i).objectBoundingBoxes(2)=Terravic_data(i).objectBoundingBoxes(2)*(final_row_size/original_row_size);
Terravic_data(i).objectBoundingBoxes(3)=Terravic_data(i).objectBoundingBoxes(3)*(final_col_size/original_col_size);
Terravic_data(i).objectBoundingBoxes(4)=Terravic_data(i).objectBoundingBoxes(4)*(final_row_size/original_row_size);
end
save('Terravic_data');