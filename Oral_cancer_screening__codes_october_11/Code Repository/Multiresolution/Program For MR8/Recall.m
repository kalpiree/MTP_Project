% ============================ Recall.m file ============================= %
%
% Description  : 
% Determination of the following to evaluate retrieval performance: 
%                Percentage Recall for all images
%                Percentage Precision for all images
%                Class Wise Average Percentage Recall
%                Class Wise Average Percentage Precision
%                Variance of Percentage Recalls over entire database
%                Variance of Percentage Precisions over entire database
%                Average Percentage Recall 
%                Average Percentage Precision 
% (Recall values are estimated by considering no. of top images 
% equal to 125% of the no. of relevant images)
% Input parameter : 
%               D1 = Distance matrix 
%                  
% Output parameter : 
%                R1 = Percentage Recall for all images
%                P1 = Percentage Precision for all images
%                CR1 = Class Wise Average Percentage Recall
%                CP1 = Class Wise Average Percentage Precision
%                VR1 = Variance of Percentage Recalls over entire database
%                VP1 = Variance of Percentage Precisions over entire database
%                AR = Average Percentage Recall 
%                AP = Average Percentage Precision 
% Subroutine  called :    nothing
% Called by :    
%     ComputationOfRecall_for_Without_And_With_Alignment_RIGabor_HanAndMa.m
%     ComputationOfRecall_Different_PrincipalTextureDirection.m 
% Reference  :  

% Author of the code: Rahul Das Gupta   
% Date of creation :    11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on                            :    
% Modification details                 :    
% Modified By                            :    
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== % 
function [R1,P1,CR1,CP1,VR1,VP1,AR,AP]=Recall(D,N_Class,Percentage)
N=size(D,1);
R=zeros(1,N);
P=zeros(1,N);

N_PER_CLASS=N/N_Class;
N_RELEVANT=N_PER_CLASS-1;
N_TOP=round((Percentage/100)*N_RELEVANT);

I=ones(1,N);
Rank=zeros(N,N);

D1=D;
for i=1:N
    D1(i,i)=Inf;
end

for i=1:N
    [~,I1]=sort(D1(i,:));
    for k=1:N
        Rank(i,I1(k))=k;       
    end
end


 for i=1:N
     class_no= ceil(i/N_PER_CLASS);    
     [~,I]=sort(Rank(i,:));
     Class_Labels=ceil(I/N_PER_CLASS); 
     Count=sum(Class_Labels(1:N_TOP)==class_no);
     R(i)=(100*Count)/N_RELEVANT;
     P(i)=(100*Count)/N_TOP;
 end   
AR=mean(R);
AP=mean(P);  


CR=zeros(1,N_Class);
CP=zeros(1,N_Class);
VR=zeros(1,N_Class);
VP=zeros(1,N_Class);
   for i=1:N_Class
          u=i*N_PER_CLASS;
          l=u-(N_PER_CLASS-1);
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
