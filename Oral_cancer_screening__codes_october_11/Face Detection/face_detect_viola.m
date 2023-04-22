function [I_F,I,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row] = face_detect_viola( I_F,nameFolds,folder_idx )
%Viola Jones Face Boundary Detector
I_F=mat2gray(I_F);
faceDetector = vision.CascadeObjectDetector;
I = mat2gray(I_F);
bboxes = step(faceDetector, I);
IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
% figure, imshow(mat2gray(IFaces)), title(nameFolds{folder_idx});
close all;

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
    
end   

