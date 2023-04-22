%%
clear;
clc;
%close all;

%% Load the contents of the folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal\');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%% Face Extraction
for folder_idx=1:no_dir
disp(nameFolds(folder_idx)); 
%close all;
    % Frontal Face
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
    I_F_u=(255/(max(max(I_F))-min(min(I_F))))*[I_F-min(min(I_F))]; % Map the temperature variations bet 0 and 255
   % I_F_u=uint8(I_F);
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_u);
    BW = im2bw(I_F_u/255,level/255); 
    mask_F=I_F_u.*double(BW); % Extracting the face
    figure();
    imshow(mask_F/255);
    [x,y]=find(mask_F>0);
    ellipse=fit_ellipse(x,y);
    if(ellipse.a>ellipse.b)
    a_ellipse=ellipse.X0_in+ellipse.b;
    a_ellipse_minus=ellipse.X0_in-ellipse.b;
    b_ellipse_minus=ellipse.Y0_in-ellipse.a;
    b_ellipse=ellipse.Y0_in+ellipse.a;
    else
    a_ellipse=ellipse.X0_in+ellipse.a;
    a_ellipse_minus=ellipse.X0_in-ellipse.a;
    b_ellipse_minus=ellipse.Y0_in-ellipse.b;
    b_ellipse=ellipse.Y0_in+ellipse.b;
    end
%     c=[];
%     c1=[];
%     for r=a_ellipse_minus:a_ellipse
%         c=[c b_ellipse*(sqrt(1-(r^2/a_ellipse^2)))];
%     end
%     r=[a_ellipse_minus:a_ellipse];
%     hold on;
%     plot(r,c,'r','Linewidth',3);
%     r=[];
%     for c=ellipse.Y0:-1:b_ellipse_minus
%         r=[r a_ellipse*(sqrt(1-(c^2/b_ellipse^2)))];
%     end
%     c=[ellipse.Y0:-1:b_ellipse_minus];
%     hold on;
%     plot(r,c,'r','Linewidth',3);
%     hold on;
%     plot(ellipse.X0,ellipse.Y0,'*');
%     
x1=a_ellipse;
x2=a_ellipse_minus;
y1=ellipse.Y0;
y2=ellipse.Y0;
x3=ellipse.X0;
x4=ellipse.X0;
y3=b_ellipse;
y4=b_ellipse_minus;
a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
b = 1/2*sqrt((x3-x4)^2+(y3-y4)^2);
t=linspace(0,2*pi);
X=a*cos(t);
Y=b*sin(t);
w = atan2(y2-y1,x2-x1);
x = (x1+x2)/2 + X*cos(w) - Y*sin(w);
y = (y1+y2)/2 + X*sin(w) + Y*cos(w);
hold on;
 plot(x,y,'r-')
 axis equal
hold on;
plot(ellipse.X0,ellipse.Y0,'*');
    
    
    
    
    
    
    
    
    
%     a = mask_F*255;
%           bw = a > 200;
% ch=bwconvhull(bw);
% imshow(bw);title('BW image');
% figure();
% imshow(mask_F);title('mask_F');
% mask_new=mask_F.*double(ch);
% figure();imshow(mask_new);title('New Mask');
% figure();
% imshow(ch);title('Convex Hull');
%     % Right Profile
%     I_R=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_rt.csv']);
%     int_R=(255/(max(max(I_R))-min(min(I_R))))*[I_R-min(min(I_R))];
%     int_R=int_R/255;
%     level = graythresh(int_R);
%     BW = im2bw(int_R,level); 
%     mask_R=int_R.*double(BW);
%     figure();
%     imshow(mask_R);
%     % Left Profile
%     I_L=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_lt.csv']);
%     int_L=(255/(max(max(I_L))-min(min(I_L))))*[I_L-min(min(I_L))];
%     int_L=int_L/255;
%     level = graythresh(int_L);
%     BW = im2bw(int_L,level); 
%     mask_L=int_L.*double(BW);
%     figure();
%     imshow(mask_L);
    

end