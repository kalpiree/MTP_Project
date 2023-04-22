%%%%%%--------------------PROFILE FACE ROI EXTRACTION: NON MALIGNANT SUBJECT--------------%%%%



clear;
clc;
close all;

%%
%--Directory-------------%
d = dir('..\ThermalDatabase\NonMalignant');
%------------------------------------------------------------------%
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
close all;

%-------------------------------------------------Reading the Left mask image found from Interactive seg Tool-------------------------------------------------------------------------------------------%
load(['..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\GT_FacialMask\',nameFolds{folder_idx},'_LTmask.mat']); %load the mask created from interactive segmentation tool

img_face_lt=lt_face;



%---------------------------------------------------Creating mask for nostril and lip for lt face-------------------------------------------------------------------------------------------%
%%%creates the free hand mask for the left image to remove the undesired portion of the left face

figure, set(gca,'color','none');imshow(img_face_lt,[]);title('Left image');
choice_lt='Yes';bw1_lt=ones(size(img_face_lt));
while(strcmp(choice_lt,'Yes'))
     h_lt=imfreehand(gca);
     bw2_lt=~createMask(h_lt);%%% creates a mask cut from imfreehand
     bw1_lt=and(bw1_lt,bw2_lt);  %%% AND operation with older mask
     choice_lt = questdlg('Need more masks?', ...
	'Choice','Yes','No','No');
end
%----------------------------------------------------Reading the Right mask image found from Interactive seg Tool-------------------------------------------------------------------------------------------%
load(['..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\GT_FacialMask\',nameFolds{folder_idx},'_RTmask.mat']); %load the mask created from interactive segmentation tool
img_face_rt=rt_face;

%---------------------------------------------------Creating mask for nostril and lip for rt face-------------------------------------------------------------------------------------------%
%%%creates the free hand mask for the Right image to remove the undesired portion of the Right face

figure, set(gca,'color','none');imshow(img_face_rt,[]);title('Right image');
choice_rt='Yes';bw1_rt=ones(size(img_face_rt));
while(strcmp(choice_rt,'Yes'))
     h_rt=imfreehand(gca);
     bw2_rt=~createMask(h_rt);%%% creates a mask cut from imfreehand
     bw1_rt=and(bw1_rt,bw2_rt);%%% AND operation with older mask
    choice_rt = questdlg('Need more masks?', ...%%% If you need more mask
	'Choice','Yes','No','No');
end


%-------------------------------------------------Reading the .xlxs for manually annotated keypt of  lt and rt face -------------------------------------------------------------------------------------------%
LRface_keypts = xlsread('Thermal_NonMalignant_keypts_LRface.xlsx'); %
%-------------------------------------------------Extracting the left face keypts from  the .xlxs  -------------------------------------------------------------------------------------------%
lower_lt_eyex=LRface_keypts(folder_idx,1);   %%%x and y cordinates of left eye above which is not our area of interest  
lower_lt_eyey=LRface_keypts(folder_idx,2);    
lower_lt_earx=LRface_keypts(folder_idx,3);   %%%x and y cordinates of right ear ,left side of which is not our area of interest
lower_lt_eary=LRface_keypts(folder_idx,4);
lt_neckx=LRface_keypts(folder_idx,5);          %%%x and y cordinates of neck below which is not our area of interest
lt_necky=LRface_keypts(folder_idx,6);
%-------------------------------------------------Extracting the right face keypts from  the .xlxs  -------------------------------------------------------------------------------------------%
lower_rt_eyex=LRface_keypts(folder_idx,7) ;    %%%x and y cordinates of left eye above which is not our area of interest
lower_rt_eyey=LRface_keypts(folder_idx,8);
lower_rt_earx=LRface_keypts(folder_idx,9);    %%%x and y cordinates of right ear ,left side of which is not our area of interest
lower_rt_eary=LRface_keypts(folder_idx,10);
rt_neckx=LRface_keypts(folder_idx,11);        %%%x and y cordinates of neck below which is not our area of interest
rt_necky=LRface_keypts(folder_idx,12);
%-------------------------------------------------Creating the folder for storing the results in resp. directory  -------------------------------------------------------------------------------------------%

%--------------Getting the left facial ROI -------------------------------------------------------------------------------------------%

img_face_lt(lt_necky:end,:)=0;%%%% putting zero value after neck points ie below
img_face_lt(:,lower_lt_earx:end)=0;%%%% putting zero value at the rightof the ear.
img_face_lt(1:lower_lt_eyey,:)=0;%%%% putting zero value at the area above the eye point
img_face_lt=img_face_lt.*uint8(bw1_lt); %left facial ROI

%---------------Getting the right facial ROI-------------------------------------------------------------------------------------------%

img_face_rt(rt_necky:end,:)=0;
img_face_rt(:,1:lower_rt_earx)=0;%%%%% same as left face 
img_face_rt(1:lower_rt_eyey,:)=0;
img_face_rt=img_face_rt.*uint8(bw1_rt); %right facial ROI



%----------------- Saving the mask START----------------------% %Commented
%to stop alteration of previously created mask

% folder_name=['Profile_ROI_' nameFolds{folder_idx}];
%     if ~exist(folder_name,'dir')
%          mkdir(folder_name);
%          cd(folder_name);
%      else
%           
%           rmdir(folder_name,'s');
%           mkdir(folder_name);
%           cd(folder_name);
%      end
% save('Face_Mask','img_face_lt','img_face_rt');%%%%%%% saving the lt and rt facial mask 
%----------------- Saving the mask END----------------------%
%cd '../../';
%wait for a mouse click or button press before going to next folder
uiwait(msgbox('This message will pause execution until you click OK'));
end