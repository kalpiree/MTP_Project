% ============================ CityBlockDist.m file ============================= %
%
% Description :  To Calculate City Block Distance Between Two Matrix  
% Input parameter :    X,Y are two matrices of samr order
% Output parameter :   d=City Block Distance 
% Subroutine  called :    Nothing
% Called by :FetDatabaseDistMatrix.m
% Reference :    
% Author of the code :  Rahul Das Gupta  
% Date of creation  :    11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on  :    
% Modification details :    
% Modified By :    
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== % 
function d=CityBlockDist(X,Y)
% D=(X-Y).^2;
% d=sqrt(sum(D(:)));
d=0.0;
[m n]=size(X);
for i=1:m
    for j=1:n
        d=d+abs(X(i,j)-Y(i,j));
    end
end  

end

