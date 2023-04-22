
function AUC=AUC_Features(malignant_feature,normal_feature)

tot_op=[malignant_feature;normal_feature];

targets = [ones(size(malignant_feature,1),1);2*ones(size(normal_feature,1),1)];





th_vals= sort(tot_op); 



for i = 1:length(th_vals)
  b_pred = (tot_op>=th_vals(i,1));
  TP = sum(b_pred == 1 & targets == 2);
  FP = sum(b_pred == 1 & targets == 1);
  TN = sum(b_pred == 0 & targets == 1);
  FN = sum(b_pred == 0 & targets == 2);
  sens(i) = TP/(TP+FN);
  spec(i) = TN/(TN+FP);
end


% figure(2);
cspec = 1-spec;
cspec = cspec(end:-1:1);
sens = sens(end:-1:1);
% plot(cspec,sens,'k');

AUC = sum(0.5*(sens(2:end)+sens(1:end-1)).*(cspec(2:end) - cspec(1:end-1)));
AUC=AUC.*(AUC>=0.5)+ (1-AUC).*(AUC<0.5);
% fprintf('\nAUC: %g \n',AUC);