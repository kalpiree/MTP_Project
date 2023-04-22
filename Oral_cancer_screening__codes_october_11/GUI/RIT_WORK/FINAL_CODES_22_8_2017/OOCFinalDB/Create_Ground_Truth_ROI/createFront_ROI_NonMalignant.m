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

%-------------------------------------------------Reading the Front mask image found from Interactive seg Tool-------------------------------------------------------------------------------------------%
load(['..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\GT_FacialMask\',nameFolds{folder_idx},'_FTmask.mat']); %load the mask created from interactive segmentation tool
face_mask_img=ft_face;

%---------------------------------------------------Creating mask for nostril and lip for Front face-------------------------------------------------------------------------------------------%
figure, imshow(face_mask_img,[]);
choice='Yes';bw1=ones(size(face_mask_img));
while(strcmp(choice,'Yes'))
     h_lt=imfreehand(gca);
     bw2_lt=~createMask(h_lt);
     bw1=and(bw1,bw2_lt);
     choice = questdlg('Need more masks?', ...
	'Choice','Yes','No','No');
end



%-------------------------------------------------Reading the .xlxs for keypt of Front face -------------------------------------------------------------------------------------------%

Frontface_keypts = xlsread('Thermal_NonMalignant_keypts_FRONTface.xlsx');


%-------------------------------------------------Reading the .xlxs for manually annotated keypt of  front face face -------------------------------------------------------------------------------------------%
lower_lt_eyex=Frontface_keypts(folder_idx,1);
lower_lt_eyey=Frontface_keypts(folder_idx,2);
lower_rt_eyex=Frontface_keypts(folder_idx,3);
lower_rt_eyey=Frontface_keypts(folder_idx,4);
nose_tipx=Frontface_keypts(folder_idx,5);
nose_tipy=Frontface_keypts(folder_idx,6);
neckx=Frontface_keypts(folder_idx,7);
necky=Frontface_keypts(folder_idx,8);
lt_eye_centrx=Frontface_keypts(folder_idx,9);
lt_eye_centry=Frontface_keypts(folder_idx,10);
rt_eye_centrx=Frontface_keypts(folder_idx,11);
rt_eye_centry=Frontface_keypts(folder_idx,12);
%---------------Getting the left and right facial ROI START  -------------------------------------------------------------------------------------------%
lower_eyey=(lower_lt_eyey+lower_rt_eyey)/2;

face_mask_img(necky:end,:)=0;

face_mask_img(1:lower_eyey,:)=0;
face_mask_img=face_mask_img.*uint8(bw1);


img_face_rt = face_mask_img(:,1:nose_tipx);
img_face_lt = face_mask_img(:,(nose_tipx+1):end);

%---------------Getting the left and right facial ROI STOP -------------------------------------------------------------------------------------------%


% changing the directory back to the path to fetch the next folder

%cd '../';




%----------------- Saving the mask START----------------------% %Commented
%to stop alteration of previously created mask

% folder_name=['Front_ROI_' nameFolds{folder_idx}];
%     if ~exist(folder_name,'dir')
%          mkdir(folder_name);
%          cd(folder_name);
%      else
%           
%           rmdir(folder_name,'s');
%           mkdir(folder_name);
%           cd(folder_name);
%      end


% save('Face_Mask','img_face_lt','img_face_rt');
% cd '../../';
%----------------- Saving the mask END----------------------%



%wait for a mouse click or button press before going to next folder
uiwait(msgbox('This message will pause execution until you click OK'));
end