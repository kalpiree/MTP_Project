%%
close all
clear all

%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%

for folder_idx=1:no_dir
    close all;
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))))*255;
    level = graythresh(I_F_n/255);
    BW = im2bw(I_F_n/255,level);
%    figure();
    mask_F=I_F_n.*double(BW);
%    imshow(mask_F/255);
    Ph=[];
    Pv=[];
     for i=1:floor((1/3)*size(mask_F,1))
        Ph(i)=sum(mask_F(i,:));
     end
     figure();
imshow(mask_F);
figure();
     mask_F(380:end,:)=0;
    Fx=gradient(Ph);
    r=find(Fx==max(Fx));
    temp=[1:size(mask_F,2)];
    imshow(mask_F/255);title(nameFolds{folder_idx});
    hold on;
    plot(temp,r,'c*');


%     for i=(floor((1/3.05)*size(mask_F,2))):floor((1/1.2)*size(mask_F,2))
%         Pv(i)=sum(mask_F(:,i));
%     end
    for i=1:size(mask_F,2)
        Pv(i)=sum(mask_F(:,i));
    end
    Fy=gradient(Pv);
    c1=find(Fy==max(Fy));
    temp=[1:size(mask_F,1)];
     hold on;
     plot(c1,temp,'c*');
    c2=find(Fy==min(Fy));
    temp=[1:size(mask_F,1)];
     plot(c2,temp,'c*');
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
         if(j>(c1-10) && j<(c2+10))   %FRONTAL
         %   if(j<c2)       %lEFT
%             if(j>c1)       %right
                I_new(i,j)=mask_F(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
     figure();
    imshow(I_new/255);
end
    