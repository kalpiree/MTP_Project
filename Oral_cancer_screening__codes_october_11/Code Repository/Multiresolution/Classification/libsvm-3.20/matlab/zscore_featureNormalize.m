function [X_norm,mean_data,std_data] = zscore_featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   where data is between 0 and 1.
% You need to set these values correctly


% ====================== YOUR CODE HERE ======================
mean_data = mean(X);
std_data = std(X);
% X_norm= (X-min_data) / ( max_data- min_data );
X1 = gsubtract(X,mean_data);
X_norm = gdivide(X1,std_data);








% ============================================================

end
