%% Main Code for Face Detection
dbstop if error
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
 d = dir('D:\Work\ThermalOOC_Manashi\Normal'); % Reading Dir of the Specified Folder
%   d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant'); % Reading Dir of the Specified Folder
%  d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
for folder_idx=1:no_dir

   disp(nameFolds(folder_idx)); 
%    check=[9,6,28,31,36,41,43,44,45,57,58,59,67,79,82,86,88,97,98,99,100,102,83,106];
%    if  ismember(folder_idx,check)
%        
%        continue;
%    end

%    check=[61,63,65];
%    if  ismember(folder_idx,check)
%        
%        continue;
%    end

%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
 
    close all;
%     I_F=xlsread(['G:\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
  I_F=xlsread(['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);

%  I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     I_F_cpy=I_F;
     op_img1=nameFolds(folder_idx);
     [BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,~,lower_boundary_row]=(face_detect( I_F,nameFolds,folder_idx,op_img1 ));
     lower_boundary_row=floor(lower_boundary_row);
     I_F=mat2gray(I_F);
     face_img=(I_F).*double(BW_mask_F);
    
%   %Below four lines is just for proper display of face_img 
%   face_img1=face_img(face_img>0);
%   min1 = min(face_img1);
%   max1 = max(face_img1);
%   figure, imshow(face_img,[min1 max1]);
%   
%  face_img=imfill(face_img,'holes');
%% Eye Detection

[ modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
%% Mouth Detection
 [ req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose] = mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row);
%% Nose Detection=
[r_lt,c_lt,r_rt,c_rt]=nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt);

%% Mouth Row
distance_1_2=col_lt_eye-col_rt_eye;
distance_1_3=r_rt-row_rt_eye;

distance_3_5_eqn1=0.83763*distance_1_2+4.9135;
distance_3_5_eqn2=0.86625*distance_1_3+2.3029;

row_3_5_eqn1=distance_3_5_eqn1+r_rt;
row_3_5_eqn2=distance_3_5_eqn2+r_rt;

lower_lip_row=ceil((row_3_5_eqn1+row_3_5_eqn2)/2);

Mouth_Region_Image=face_img(req_row:lower_lip_row,req_col_mouth_rt:req_col_mouth_lt);

figure();
imshow(Mouth_Region_Image,[]);

Mouth_Region_Image = adapthisteq(Mouth_Region_Image);

figure();
imshow(Mouth_Region_Image,[]);
var_mouth=[];
for mouth_row_index=1:size(Mouth_Region_Image,1)
    var_mouth(mouth_row_index)=var(Mouth_Region_Image(mouth_row_index,:));
end

close all;
rev_var_mouth=var_mouth(length(var_mouth):-1:1);
choice=1;
mouth_index=1;
figure();
stem(rev_var_mouth);

% while(choice==1)
%     if(rev_var_mouth(mouth_index)-rev_var_mouth(mouth_index+1)>0)
%         mouth_index=mouth_index+1;
%     else 
%         mouth_row_index_req=mouth_index;
%         choice=0;
%     end
% end
while(rev_var_mouth(mouth_index)<rev_var_mouth(mouth_index+1))
    mouth_index=mouth_index+1;
end
while(choice==1)
    if(rev_var_mouth(mouth_index)-rev_var_mouth(mouth_index+1)>0)
        mouth_index=mouth_index+1;
    else
        if(rev_var_mouth(mouth_index+1)>rev_var_mouth(mouth_index) && rev_var_mouth(mouth_index+2) > rev_var_mouth(mouth_index))
            choice=0;
            mouth_row_index_req=mouth_index;
            break;
        else
            mouth_index=mouth_index+1;
        end
    end 
end
 mouth_row_index_req=length(var_mouth)-mouth_row_index_req;
 mouth_row_index_req= mouth_row_index_req+req_row;
 figure();

 imshow(face_img); hold on;
 plot(req_col_mouth_rt,mouth_row_index_req,'g*');
 
 plot(req_col_mouth_lt,mouth_row_index_req,'g*');
    

%% Display Section
 close all;
[r,c]=find(face_img);
rmax=max(r);
figure;
imshow(face_img);title(nameFolds{folder_idx});
hold on;
plot(col_rt_eye,row_rt_eye,'c*');
plot(col_lt_eye,row_lt_eye,'c*');
% Plotting the bounding box around the eye
% rectangle('Position', [ col_rt_eye-70,row_rt_eye-20, 70, 40],...
%   'EdgeColor','r', 'LineWidth', 3);
% rectangle('Position', [ col_lt_eye,row_lt_eye-20, 70, 40],... 
%   'EdgeColor','r', 'LineWidth', 3);
row_mean_eye=row_lt_eye;
plot_variable=[req_row:rmax];
% plot(req_col_mouth_lt,plot_variable,'c*');
% plot(req_col_mouth_rt,plot_variable,'c*');
plot(c_rt,r_rt,'b*');
plot(c_lt,r_lt,'b*');
plot(req_col_mouth_rt,mouth_row_index_req,'g*');
plot(req_col_mouth_lt,mouth_row_index_req,'g*');


fullFileName = fullfile('C:\Users\chaithan\Desktop\Normal3', op_img1);
fullFileName=cell2mat(fullFileName);
saveas(gcf,fullFileName,'png')
% 
% Hull_X(1)=req_col_mouth_rt; Hull_Y(1)=mouth_row_index_req;
% Hull_X(2)=req_col_mouth_lt; Hull_Y(2)=mouth_row_index_req;
% Hull_X(3)=c_rt(1);Hull_Y(3)=r_rt;
% Hull_X(4)=c_lt(1);Hull_Y(4)=r_lt;
% 
% figure();
% imshow(face_img);hold on;
% k = convhull(Hull_X,Hull_Y);
% plot(Hull_X(k),Hull_Y(k),'r-')
% 
% New_face=face_img;
% 
% for move=min(Hull_Y)+1:max(Hull_Y)-1
%     find_index=find(move==Hull_Y);
%     index1=Hul                                                           l_X(find_index(1));
%     index2=Hull_X(find_index(2));
%     New_face(move, min(index1,index2):max(index1,index2))=0;
% end
%                                                                                           
% hold on;plot(col_right_nose,row_right_nose,'r*');
% plot(col_left_nose,row_left_nose,'r*');
%%
%face_img_temp=(I_F_cpy).*double(BW_mask_F);
max_face_img=max(face_img(:));
[face_img_max_X,face_img_max_Y]=find(face_img==max_face_img)
face_img_temp=face_img(1:lower_lip_row,:);
face_img_avg = mean( nonzeros(face_img_temp));
tolerance=(max_face_img-face_img_avg);
tolerance=ceil(10*tolerance)/10;
face_img_avg=ceil(10*face_img_avg)/10;
face_img_avg_mat=(face_img>0).*face_img_avg;
dist_face_img_and_faceimgavg=abs(face_img-face_img_avg_mat);
[x_dist_face_img_and_faceimgavg,y_dist_face_img_and_faceimgavg]=find(dist_face_img_and_faceimgavg==min(nonzeros(dist_face_img_and_faceimgavg(:))));


% BW_face_img = grayconnected(face_img,face_img_max_X(1),face_img_max_Y(1),tolerance);
% BW_face_img = grayconnected(face_img,x_dist_face_img_and_faceimgavg(1),y_dist_face_img_and_faceimgavg(1),tolerance);
BW_face_img = grayconnected(face_img,x_dist_face_img_and_faceimgavg(1),y_dist_face_img_and_faceimgavg(1),tolerance);

BW_face_img=imfill(BW_face_img,'holes');
face_img=face_img.*(BW_face_img);
figure, imshow (face_img,[]);

new_face_reigon=strcat(op_img1,'_face_segmented');

fullFileName = fullfile('C:\Users\chaithan\Desktop\Normal3', new_face_reigon);
fullFileName=cell2mat(fullFileName);
saveas(gcf,fullFileName,'png')
%% Hull Mask
mid_mouth=ceil((req_col_mouth_rt+req_col_mouth_lt)/2);
[img_size_X,img_size_Y]=size(face_img);
face_keypt_X=[c_rt(1)-20;c_lt(1)+20;req_col_mouth_lt+20;req_col_mouth_rt-20;mid_mouth];
face_keypt_Y=[r_rt-20;r_lt-20;mouth_row_index_req;mouth_row_index_req;lower_lip_row+10];
k = convhull(face_keypt_X,face_keypt_Y);
BW = poly2mask(face_keypt_X(k),face_keypt_Y(k),img_size_X,img_size_Y);
face_portion_masked = bwconvhull(BW);
face_portion_masked=~face_portion_masked;
face_portion_masked=double(face_portion_masked);
face_region = face_img.*face_portion_masked;
figure;imshow(face_region);
hold on;
plot(face_keypt_X(k),face_keypt_Y(k),'r-',face_keypt_X,face_keypt_Y,'b*');title('Convhull of poly2mask')

%% Lower Eye POint Detection
Eye_dist=col_lt_eye-col_rt_eye;
Lower_right_eye=0.09291*Eye_dist+6.1139+row_rt_eye;
Lower_left_eye=0.1189*Eye_dist+2.6775+row_lt_eye;
Lower_eye_row=ceil((Lower_right_eye+Lower_left_eye)/2);
plot_temp=[1:640];
plot(plot_temp,Lower_eye_row,'c*');
% Mid Identification
[row,column]=find(face_img>0);
cmax=max(column);
cmin=min(column);

% c1mid...c4mid is for finding middle of the face taking avg of lt and rt
% bondary of detected face, lt and rt canthus of eye, lt and rt detected
% nose tip, lt and rt lip corner. The final avg variable is cmid
c1mid=ceil((cmax+cmin)/2);
c2mid=ceil((col_lt_eye+col_rt_eye)/2);
c3mid=ceil((c_rt(1)+c_lt(1))/2);
c4mid=ceil((req_col_mouth_lt+req_col_mouth_rt)/2);
cmid=ceil((c1mid+c2mid+c3mid+c4mid)/4);
face_region1=face_region;
face_region1(1:Lower_eye_row-10,:)=0;
figure, imshow(face_region1,[]);
Left_Img=zeros(img_size_X,img_size_Y);
Right_Img=zeros(img_size_X,img_size_Y);




Left_Img(Lower_eye_row-10:end,cmid:cmax)=face_region(Lower_eye_row-10:end,cmid:cmax);
%To remove clothes and moustache we apply minimum error thresholding once
%again on right ROI
% A_row_ones_lt=ones((lower_lip_row-1),img_size_Y);
% A1_row_ones_lt=ones(img_size_X-(lower_boundary_row),img_size_Y);
% 
% Left_Img_rmv_cloth=Left_Img(lower_lip_row:lower_boundary_row,cmid:cmax);
% avg_LtImg_rmvcloth= mean(Left_Img_rmv_cloth(:));
% sum_avg_LtImg_rmvcloth=sum(Left_Img_rmv_cloth(:) >= avg_LtImg_rmvcloth)
% z=size(Left_Img_rmv_cloth,1);
% A_col_ones_lt=ones(z,(cmid-1));
% A1_col_ones_lt=ones(size(Left_Img_rmv_cloth,1),img_size_Y-(cmax));
% % [Lt_max_X,Lt_max_Y]=find(Left_Img_rmv_cloth==max(Left_Img_rmv_cloth(:)))
% % BW_Left_Img_rmv_cloth = grayconnected(Left_Img_rmv_cloth,Lt_max_X(1),Lt_max_Y(1),0.3);
% BW_Left_Img_rmv_cloth=[A_col_ones_lt,BW_Left_Img_rmv_cloth,A1_col_ones_lt];
% BW_lt=[A_row_ones_lt;BW_Left_Img_rmv_cloth;A1_row_ones_lt];
% %BW_lt=imfill(BW_lt,'holes');
% Left_Img_1=Left_Img.*(BW_lt);
Left_Img_1=Left_Img;
Left_Img_1=(Left_Img_1>0);

%%%%%% Connected Component Labelling %%%%%%%%%%%

Labels_L= bwlabel(Left_Img_1);
stats_L = regionprops(logical(Labels_L), 'Area');
Ar_L=struct2cell(stats_L);
Ar_L=cell2mat(Ar_L);
LabelmaxArea_L=find(Ar_L==max(Ar_L));
Logical_Left_ROI=[Labels_L==LabelmaxArea_L];
%%%%%%%%%%%%%%%%%%%


A_ROI_L=I_F_cpy.*double(Logical_Left_ROI);
A_ROI_L=imfill(A_ROI_L,'holes');

Right_Img(Lower_eye_row-10:end,cmin:cmid)=face_region(Lower_eye_row-10:end,cmin:cmid);
%To remove clothes and moustache we apply minimum error thresholding once
%again on right ROI and then apply connected component labelling 
% A_row_ones_rt=ones((lower_lip_row-1),img_size_Y);
% A1_row_ones_rt=ones(img_size_X-(lower_boundary_row),img_size_Y);
% 
% Right_Img_rmv_cloth=Right_Img (lower_lip_row:lower_boundary_row,cmin:cmid);
% avg_RtImg_rmvcloth= mean(Right_Img_rmv_cloth(:));
% A_col_ones_rt=ones(size(Right_Img_rmv_cloth,1),(cmin-1));
% A1_col_ones_rt=ones(size(Right_Img_rmv_cloth,1),img_size_Y-(cmid));
% 
% 
% [Rt_max_X,Rt_max_Y]=find(Right_Img_rmv_cloth==max(Right_Img_rmv_cloth(:)));
% 
% % BW_Right_Img_rmv_cloth = grayconnected(Right_Img_rmv_cloth,Rt_max_X(1),Rt_max_Y(1),0.3);
% % BW_Right_Img_rmv_cloth=[A_col_ones_rt,BW_Right_Img_rmv_cloth,A1_col_ones_rt];
% 
% BW_rt=[A_row_ones_rt;BW_Right_Img_rmv_cloth;A1_row_ones_rt];
% 
% 
% %BW_rt=imfill(BW_rt,'holes');
% Right_Img_1=Right_Img.*(BW_rt);
Right_Img_1=Right_Img;
Right_Img_1=(Right_Img_1>0);


%%%%%% Connected Component Labelling %%%%%%%%%%%

Labels_R= bwlabel(Right_Img_1);
stats_R = regionprops(logical(Labels_R), 'Area');
Ar_R=struct2cell(stats_R);
Ar_R=cell2mat(Ar_R);
LabelmaxArea_R=find(Ar_R==max(Ar_R));
Logical_Right_ROI=[Labels_R==LabelmaxArea_R];
%%%%%%%%%%%%%%%%%%%
A_ROI_R=I_F_cpy.*double(Logical_Right_ROI);
A_ROI_R=imfill(A_ROI_R,'holes');
%% Saving ROI
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');
% 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_ROI');
% % 
%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_ROI');

%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','A_ROI_R.mat'];
%  save(save_direc,'Right_Img');

%  save_direc=['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','A_ROI_L.mat'];
%  save(save_direc,'Left_Img');

rel_path=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('A_ROI_Front','A_ROI_L','A_ROI_R');

%  cd '..\..\..\Main Code Repository\Face Detection';
cd 'E:\Suraj Kiran\Suraj_Intern\Edited\Main Code Repository\Face Detection';

%%
%Below four lines is just for proper display of Right_Img_1 
  Right_ROI_1=A_ROI_R(A_ROI_R>0);
  min2 = min(Right_ROI_1);
  max2 = max(Right_ROI_1);
  figure, imshow(A_ROI_R,[min2 max2]); title('Right ROI');
  
    
% A_ROI_R_save=strcat(op_img1,'_A_R_ROI');
% 
% fullFileName = fullfile('C:\Users\chaithan\Desktop\Normal1', A_ROI_R_save);
% fullFileName=cell2mat(fullFileName);
% saveas(gcf,fullFileName,'png')
% figure, imshow(logical(A_ROI_R)); title('Logical Right ROI');
% A_ROI_R_save_1=strcat(op_img1,'_A_R_ROI_logical');
% fullFileName = fullfile('C:\Users\chaithan\Desktop\Normal1', A_ROI_R_save_1);
% fullFileName=cell2mat(fullFileName);
% saveas(gcf,fullFileName,'png')
%Below four lines is just for proper display of Left_Img_1 
  Left_ROI_1=A_ROI_L(A_ROI_L>0);
  min3 = min(Left_ROI_1);
  max3 = max(Left_ROI_1);
  figure, imshow(A_ROI_L,[min3 max3]); title('Left ROI');
  
% A_L_ROI_save=strcat(op_img1,'_A_ROI_L');
% fullFileName = fullfile('C:\Users\chaithan\Desktop\Normal1', A_L_ROI_save);
% fullFileName=cell2mat(fullFileName);
% saveas(gcf,fullFileName,'png')
  
figure, imshow(logical(A_ROI_L)); title('Logical Left ROI');
% A_L_ROI_save_1=strcat(op_img1,'_A_ROI_L_logical');
% fullFileName = fullfile('C:\Users\chaithan\Desktop\Normal1', A_L_ROI_save_1);
% fullFileName=cell2mat(fullFileName);
% saveas(gcf,fullFileName,'png')
end  