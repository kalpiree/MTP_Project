function [R1,P1,CR1,CP1,VR1,VP1,AR,AP]=Precision(D1,D2)
[m,n]=size(D1);
R=zeros(1,m);
P=zeros(1,m);
N=1456;
N_TOP=5;
N_RELEVANT=112;
NC=13;
I=ones(1,N);
R1=zeros(N,N);
R2=zeros(N,N);
% D=D1.*D2;

for i=1:N
    [~,I1]=sort(D1(i,:));
    [~,I2]=sort(D2(i,:));
    for k=1:N
        R1(i,I1(k))=k;
        R2(i,I2(k))=k;
    end
end

D=R1+R2;

 for i=1:N
     
     class_no= ceil(i/N_RELEVANT);
     
     
     [~,I]=sort(D(i,:));
         count=0;
         for j=1:N_TOP
             if (I(j)>=1+N_RELEVANT*(class_no-1) && I(j)<=N_RELEVANT*class_no) 
                 count=count+1;
             end    
         end
         R(i)=(100*count)/N_RELEVANT;
         P(i)=(100*count)/N_TOP;
 end   
AR=mean(R);
AP=mean(P);  

nC=N/NC;
CR=zeros(1,NC);
CP=zeros(1,NC);
VR=zeros(1,NC);
VP=zeros(1,NC);
   for i=1:NC
          u=i*nC;
          l=u-(nC-1);
          CR(i)=mean(R(l:u));
          CP(i)=mean(P(l:u));
          VR(i)=sqrt(var(R(l:u)));
          VP(i)=sqrt(var(P(l:u)));
   end
      R1=R';
      P1=P';
      CR1=CR';
      CP1=CP';
      VR1=VR';
      VP1=VP';
end
