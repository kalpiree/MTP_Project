
clc;
clear;

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
elseif s==2
   N=2675;
   N_Class=107;
   DirectoryLocation='../NBR_2675/Result_GaborA/';
elseif s==3
   N=4000;
   N_Class=25;
   DirectoryLocation='../UIUC_4000/Result_GaborA/';
elseif s==4
   N=6380;
   N_Class=319;
   DirectoryLocation='../Outex_6380/Result_GaborA/';
end

tic;
N_Sample_Per_Class=N/N_Class;
N_RELEVANT=N_Sample_Per_Class-1;

load([DirectoryLocation,'DistanceMatrixH_IGMGD.mat']);
load([DirectoryLocation,'DistanceMatrix_I.mat']);
load([DirectoryLocation,'DistanceMatrix_IH.mat']);
load([DirectoryLocation,'DistanceMatrix_IGMGD.mat']);
load([DirectoryLocation,'DistanceMatrix_IGMGDH.mat']);

[AR_H,AP_H]=PrecisionAndRecallValues(Dist_MatrixH_IGMGD,N_RELEVANT);
[AR_I,AP_I]=PrecisionAndRecallValues(Dist_Matrix_I,N_RELEVANT);
[AR_IH,AP_IH]=PrecisionAndRecallValues(Dist_Matrix_IH,N_RELEVANT);
[AR_IGMGD,AP_IGMGD]=PrecisionAndRecallValues(Dist_Matrix_IGMGD,N_RELEVANT); 
[AR_IGMGDH,AP_IGMGDH]=PrecisionAndRecallValues(Dist_Matrix_IGMGDH,N_RELEVANT);

figure;
plot(AR_H(1:1:end),AP_H(1:1:end),'--b',...
AR_I(1:1:end),AP_I(1:1:end),'-m', ...
AR_IH(1:1:end),AP_IH(1:1:end),'-k', ...
AR_IGMGD(1:1:end),AP_IGMGD(1:1:end),'-b', ...
AR_IGMGDH(1:1:end),AP_IGMGDH(1:1:end),'-r', 'MarkerSize', 6,'LineWidth',1.5);

grid on

legend('JD(I,GM,GD)','I','I+JD(I,GM,GD)','I+GM+GD','I+GM+GD+JD(I,GM,GD)');

xlabel(' Recall','fontsize',14,'fontweight','b');
ylabel(' Precision','fontsize',14,'fontweight','b');

savefig('PR_curve_IGMGDH.fig');
toc;