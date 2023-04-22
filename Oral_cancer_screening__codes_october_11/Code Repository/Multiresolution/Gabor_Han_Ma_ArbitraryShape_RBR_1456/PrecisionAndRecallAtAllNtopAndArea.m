function [AR,AP,Area] = PrecisionAndRecallAtAllNtopAndArea(D,N_RELEVANT)


N=size(D,1);
R=zeros(1,N);
P=zeros(1,N);
AR=zeros(1,N);
AP=zeros(1,N);  

Stop=0;
n_top=0;
[~,I]=sort(D,2);
while Stop==0
    n_top=n_top+1;

    for i=1:N
       class_no= ceil(i/N_RELEVANT);
          

count = sum(I(i,1:n_top)>=(1+N_RELEVANT*(class_no-1)) & I(i,1:n_top)<=(N_RELEVANT*class_no));
       R(i)=(100*count)/N_RELEVANT;
       P(i)=(100*count)/n_top;
    end   
 AR(n_top)=mean(R);
 AP(n_top)=mean(P);  
 if AR(n_top)==100
     L=n_top;
     Stop=1;
 end

end


AR=AR(1:L);
AP=AP(1:L);

% plot(AR,AP);
% 
% xlabel('Percentage Recall')
% ylabel('Percentage Precision')



Area = sum((AR(2:L)-AR(1:L-1)).*((AP(1:L-1)+AP(2:L))/2));


end

