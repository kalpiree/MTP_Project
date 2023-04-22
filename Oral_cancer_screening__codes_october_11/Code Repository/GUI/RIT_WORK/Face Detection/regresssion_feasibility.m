%%
clear;
clc;
close all;

%%
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
close all;
%----------------------------------------------------Read Front Thermal img-------------------------------------------------------------------------------------------%

I1 = xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);
[img_size_X,img_size_Y]=size(I1);
% maxval_lt=max(max(I1_lt));
% minval_lt=min(min(I1_lt));
% range_lt=255/(maxval_lt-minval_lt);
% I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of 0-255
figure, set(gca,'color','none');imshow(I1,[]);title('Org Front Thermal image');
face_keypt_X=[222;312;215;309;259];
face_keypt_Y=[318;326;366;372;398];
k = convhull(face_keypt_X,face_keypt_Y);
BW = poly2mask(face_keypt_X,face_keypt_Y,img_size_X,img_size_Y);
face_portion_masked = bwconvhull(BW);
face_portion_masked=~face_portion_masked;
face_portion_masked=double(face_portion_masked);
face_region = I1.*face_portion_masked;

figure;imshow(face_region);
hold on;
plot(face_keypt_X(k),face_keypt_Y(k),'r-',face_keypt_X,face_keypt_Y,'b*')
uiwait(msgbox('This message will pause execution until you click OK'));

end