%image_no=238;%Brick
%image_no=830; %Sand

while 1
  s=input(['Press \n 1 for Rotated Brodatz Texture Database',... 
              '\n 2 for Non rotated Brodatz Texture Database',...
              '\n 3 for UIUC Texture Database',...
              '\n 4 for Outex Texture Database',...
              '\n Enter your choice (1-4):']); 
  if s==1 || s==2 || s==3 || s==4
       break;
  else
      clc
      disp('Wrong choice. Input your choice correctly again !!')
  end       
end

if s==1         
   N=1456;
   N_Class=13;
   DirectoryLocation='../RBR_1456/Result_GaborA/';
   ImageAndMaskDirectoryLocation='../RBR_1456/';
elseif s==2
   N=2675;
   N_Class=107;
   DirectoryLocation='../NBR_2675/Result_GaborA/';
   ImageAndMaskDirectoryLocation='../NBR_2675/';
elseif s==3
   N=4000;
   N_Class=25;
   DirectoryLocation='../UIUC_4000/Result_GaborA/';
   ImageAndMaskDirectoryLocation='../UIUC_4000/';
elseif s==4
   N=6380;
   N_Class=319;
   
   DirectoryLocation='../Outex_6380/Result_GaborA/';
   ImageAndMaskDirectoryLocation='../Outex_6380/';
end

N_Sample_per_Class=N/N_Class;

image_no=input(['Enter the image no.','(1 to',num2str(N),'):']);

Mask_No= mod(image_no-1,N_Sample_per_Class)+1;

Im_Mask=strcat(ImageAndMaskDirectoryLocation,'Masks/Mask (',num2str(Mask_No),').tif');
Mask=imread(Im_Mask);
M=Mask(:,:,1);
MAX=max(M(:));
M=double(M./MAX);

input_class_no=ceil(image_no/N_Sample_per_Class);
if s==2
    Input=strcat(ImageAndMaskDirectoryLocation,'Images/X_Tex (',num2str(image_no),').tiff');
else
    Input=strcat(ImageAndMaskDirectoryLocation,'Images/Tex (',num2str(image_no),').tiff');
end
InputImage=double(imread(Input));
% subplot(3,10,[1:10]); imshow(InputImage,[]);
subplot_tight(3,1,1); imshow(InputImage.*M,[]);
dbstop if error
load([DirectoryLocation,'DistanceMatrix_IGMGDH.mat']);
D=Dist_Matrix_IGMGDH;
N=1456;
[~,I1]=sort(D(image_no,:));
I=I1(1:21);


[row, col] = size(InputImage);
Image2 = 255*ones(row,col,3, 'uint8');
Image_joint = [];
for i=2:21
    class_no=ceil(I(i)/N_Sample_per_Class);
    
    Mask_No= mod(I(i)-1,N_Sample_per_Class)+1;
                  
    Im_Mask=strcat(ImageAndMaskDirectoryLocation,'Masks/Mask (',num2str(Mask_No),').tif');
    Mask=imread(Im_Mask);
    M=Mask(:,:,1);
    MAX=max(M(:));
    M=double(M./MAX);
    
    if s==2
         ImagePath=strcat(ImageAndMaskDirectoryLocation,'Images/X_Tex (',num2str(I(i)),').tiff');
    else
         ImagePath=strcat(ImageAndMaskDirectoryLocation,'Images/Tex (',num2str(I(i)),').tiff');
    end
    Image=double(imread(ImagePath));
    Image=Image.*M;
  
%     Im(:,:,i)=Image;
    
    if class_no ~= input_class_no
        Image2(:,:,1) = 255*ones(size(Image),'uint8');
        Image2(:,:,2) = zeros(size(Image),'uint8');
        Image2(:,:,3) = zeros(size(Image),'uint8');
        Image2(6:end-5, 6:end-5, 1) = Image(6:end-5, 6:end-5);
        Image2(6:end-5, 6:end-5, 2) = Image(6:end-5, 6:end-5);
        Image2(6:end-5, 6:end-5, 3) = Image(6:end-5, 6:end-5);
        Image = Image2;
    else
        Image2 = Image;
        Image(:,:,1) = Image2;
        Image(:,:,2) = Image2;
        Image(:,:,3) = Image2;
    end
    
    
    n_pix = 5;
    Image_extended(:,:,1) = 255*ones(row+2*n_pix, col+2*n_pix, 'uint8');
    Image_extended(:,:,2) = 255*ones(row+2*n_pix, col+2*n_pix, 'uint8');
    Image_extended(:,:,3) = 255*ones(row+2*n_pix, col+2*n_pix, 'uint8');
    
    Image_extended(n_pix+1:end-n_pix, n_pix+1:end-n_pix, 1) = Image(:,:,1);
    Image_extended(n_pix+1:end-n_pix, n_pix+1:end-n_pix, 2) = Image(:,:,2);
    Image_extended(n_pix+1:end-n_pix, n_pix+1:end-n_pix, 3) = Image(:,:,3);
    
    Image = Image_extended;
    
    
    Image_joint = [Image_joint Image_extended];
%     if i==2
%         subplot(2,1,1);
%     elseif i==12
%         subplot(2,1,2);
%     end
%     if i<12
%         subplot(3,10,i+9); imshow(Im(:,:,i),[]);
if i==11
        subplot_tight(3,1,2); imshow(Image_joint,[]);
        Image_joint = [];
elseif i==21
    subplot_tight(3,1,3); imshow(Image_joint,[]);
end
    
%     else
%         subplot(3,10,i-11); imshow(Im(:,:,i),[]);
%     end
end
axis tight
