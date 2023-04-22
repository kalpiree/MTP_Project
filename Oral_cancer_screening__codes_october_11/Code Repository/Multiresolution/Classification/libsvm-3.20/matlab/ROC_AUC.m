function [Operating_point] = ROC_AUC(Predict,probability_data,Total_true_label)
TPR=0:0.1:1;
FPR=0:0.1:1;
d=0:0.1:1;
predict_label=probability_data;
j=1;
Total_true_label=transpose(Total_true_label);

for P = 0:0.1:1
  for i=1:1:size(probability_data,2)
      if(probability_data(i)> P)          % changed to 1-prob
          predict_label(i)=1;
      else
          predict_label(i)=0;
      end  
  end
    FN=sum(predict_label==0 & Total_true_label==1);
    FP=sum(predict_label==1 & Total_true_label==0);
    TN=sum(predict_label==0 & Total_true_label==0);
    TP=sum(predict_label==1 & Total_true_label==1);
    
    TPR(j) = sum(TP)/(sum(TP)+sum(FN));
    FPR(j)= sum(FP)/(sum(FP)+sum(TN));
    d(j)= sqrt((1-TPR(j))^2 + FPR(j)^2);
    j=j+1;
end
[min_d,index]= min(d);
plot(FPR,TPR);
Operating_point = [TPR(index),FPR(index),d(index)];
end