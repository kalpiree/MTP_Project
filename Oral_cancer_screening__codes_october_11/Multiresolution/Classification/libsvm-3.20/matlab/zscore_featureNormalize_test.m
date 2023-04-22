function [X_norm] = zscore_featureNormalize_test(X,mean_data,std_data)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   where data is between 0 and 1.
% You need to set these values correctly



% =============== Z score normalization ==================
X1 = gsubtract(X,mean_data);
X_norm = gdivide(X1,std_data);

% X_norm = cell2mat(X_norm);

% ============================================================

end
