%# read some training data
load('F:\MS\matlab_code\WORK\Texture\HaralickFeatures\Significant_Normalized_Haralick_MalignantNormal_Frontal.mat')
 xdata =[Normalized_SignificantMalignant_Frontal_LTandRT_append;Normalized_SignificantNormal_Frontal_LTandRT_append];
group = [ones(30,1);zeros(31,1)];
%# grid of parameters
folds = 5;
[C,gamma] = meshgrid(-10:2:15, -20:2:3);
% 
% %# grid search, and cross-validation
cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain(group, xdata, ...
                    sprintf('-c %f -g %f -v %d -t ', 2^C(i), 2^gamma(i), folds,2));
end
% C=-10:2:15;
% for i=1:numel(C)
%     cv_acc(i) = svmtrain(group, xdata, ...
%                     sprintf('-c %f  -v %d -t ', 2^C(i), folds,0));
% end
% %# pair (C,gamma) with best accuracy
% [~,idx] = max(cv_acc);

%# contour plot of paramter selection
% contour(C, gamma, reshape(cv_acc,size(C))), colorbar
% hold on
% plot(C(idx), gamma(idx), 'rx')
% text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
%     'HorizontalAlign','left', 'VerticalAlign','top')
% hold off
% xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')

%# now you can train you model using best_C and best_gamma
best_C = 2^C(idx);
best_gamma = 2^gamma(idx);
%# ...
