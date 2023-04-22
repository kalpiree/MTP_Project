



function [all_kernels_real,all_kernels_img,KRe,KIm]= RIGaborKernel(Ul,Uh,S,K,m)
%--------------------------------
%Inputs:
% Ul=Lowwer Central Half Frequency
% Uh=Upper Central Half Frequency
% K=No. of Directions
% S=No. of Scales
% m=Scale Index
% n=Directional Index
%----------------------------------
%Outputs:
%KR= Real Part of the Kernel
%KI= Imaginary Part of the Kernel
%--------------------------------
a=(Uh/Ul)^(1/(S-1));
W=Uh;
Su=((a-1)/(a+1))*(Uh/sqrt(2*log(2)));
Sv=sqrt(0.5*(Uh*Uh/log(2))-Su*Su)*tan(pi/(2*K));
Sx=(1/(2*pi*Su));
Sy=(1/(2*pi*Sv));
m1=2*round(2*Sx)+1;            %%% m1 is the size of the kernel???????
n1=2*round(2*Sy)+1;            %%% n1 is the size of kernel????????

KR=zeros(m1,n1);
KI=zeros(m1,n1);

KRe=zeros(m1,n1);
KIm=zeros(m1,n1);
%-------rough work
all_kernels_real=cell(1,6);

all_kernels_img=cell(1,6);

%-------

for n=0:1:K-1                  %%%for n=0:1:K-1     %%% initialisation for K directions
    theta=n*pi/K;
    for x=-round(2*Sx):round(2*Sx)
        for y=-round(2*Sy):round(2*Sy)
           x1=a^(-m)*(x*cos(theta)+y*sin(theta));
           y1=a^(-m)*(-x*sin(theta)+y*cos(theta));
           M=(a^(-2*m)/(2*pi*Sx*Sy))*exp(-0.5*((x1/Sx)^2+(y1/Sy)^2));
           Angle=2*pi*W*x1;
           xa=x+round(2*Sx)+1;
           ya=y+round(2*Sy)+1;
           KR(xa,ya)=M*cos(Angle);
           KI(xa,ya)=M*sin(Angle);
        end
    end
    all_kernels_real{1,n+1}=KR;%-----
    all_kernels_img{1,n+1}=KI;%-----
    KRe=KRe+KR;
    KIm=KIm+KI;
end

%******************* Zero Mean and L1 Normalisation **********************

% KRe=KRe-mean(KRe(:))*ones(m1,n1);
% KIm=KIm-mean(KIm(:))*ones(m1,n1);
% KRe=KRe./sum(KRe(:));
% KIm=KIm./sum(KIm(:));

end







%%this is the backup part 

% % % function [KRe,KIm]= RIGaborKernel(Ul,Uh,S,K,m)
% % % %--------------------------------
% % % %Inputs:
% % % % Ul=Lowwer Central Half Frequency
% % % % Uh=Upper Central Half Frequency
% % % % K=No. of Directions
% % % % S=No. of Scales
% % % % m=Scale Index
% % % % n=Directional Index
% % % %----------------------------------
% % % %Outputs:
% % % %KR= Real Part of the Kernel
% % % %KI= Imaginary Part of the Kernel
% % % %--------------------------------
% % % a=(Uh/Ul)^(1/(S-1));
% % % W=Uh;
% % % Su=((a-1)/(a+1))*(Uh/sqrt(2*log(2)));
% % % Sv=sqrt(0.5*(Uh*Uh/log(2))-Su*Su)*tan(pi/(2*K));
% % % Sx=(1/(2*pi*Su));
% % % Sy=(1/(2*pi*Sv));
% % % m1=2*round(2*Sx)+1;            %%% m1 is the size of the kernel???????
% % % n1=2*round(2*Sy)+1;            %%% n1 is the size of kernel????????
% % % 
% % % KR=zeros(m1,n1);
% % % KI=zeros(m1,n1);
% % % 
% % % KRe=zeros(m1,n1);
% % % KIm=zeros(m1,n1);
% % % 
% % % for n=0:1:K-1                  %%%for n=0:1:K-1     %%% initialisation for K directions
% % %     theta=n*pi/K;
% % %     for x=-round(2*Sx):round(2*Sx)
% % %         for y=-round(2*Sy):round(2*Sy)
% % %            x1=a^(-m)*(x*cos(theta)+y*sin(theta));
% % %            y1=a^(-m)*(-x*sin(theta)+y*cos(theta));
% % %            M=(a^(-2*m)/(2*pi*Sx*Sy))*exp(-0.5*((x1/Sx)^2+(y1/Sy)^2));
% % %            Angle=2*pi*W*x1;
% % %            xa=x+round(2*Sx)+1;
% % %            ya=y+round(2*Sy)+1;
% % %            KR(xa,ya)=M*cos(Angle);
% % %            KI(xa,ya)=M*sin(Angle);
% % %         end
% % %     end
% % %     KRe=KRe+KR;
% % %     KIm=KIm+KI;
% % % end
% % % 
% % % %******************* Zero Mean and L1 Normalisation **********************
% % % 
% % % % KRe=KRe-mean(KRe(:))*ones(m1,n1);
% % % % KIm=KIm-mean(KIm(:))*ones(m1,n1);
% % % % KRe=KRe./sum(KRe(:));
% % % % KIm=KIm./sum(KIm(:));
% % % 
% % % end

