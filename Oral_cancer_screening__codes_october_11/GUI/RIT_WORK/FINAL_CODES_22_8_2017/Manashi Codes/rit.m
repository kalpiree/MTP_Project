function[GT_gabor_F_normal_lt, GT_gabor_F_normal_rt]= rit(I1, A_ROI_R, A_ROI_L)
%%% I1 is  the input image
%%% Masks consist of left and right half of mask

%%% feature extraction and classification
    sacle_idx=  2 ;                      %[2,3,4,5,6];
%%feature extraction
 %%%%%%%bringing the image to a scale of floating point 0.0-1.0
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            [row,col]=size(I1); %%%% Get rows and cols value
           
            %%%%%%%%%%%% histogram equalization 
            % I1 = adapthisteq(uint8(I1));
            I1 = adapthisteq((I1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            GT_gabor_F_normal_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(A_ROI_L),sacle_idx); %%%%%% Input : Image , Mask , Scale Idx
            GT_gabor_F_normal_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(A_ROI_R),sacle_idx); %%%%%% Input : Image , Mask , Scale Idx
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%save command
X= 'A_ROI_Front_';
Y= 'filename';
d= strcat(X,Y);
mkdir(d);
cd (d);
save('GT_Gabor','GT_gabor_F_normal_lt','GT_gabor_F_normal_rt');
