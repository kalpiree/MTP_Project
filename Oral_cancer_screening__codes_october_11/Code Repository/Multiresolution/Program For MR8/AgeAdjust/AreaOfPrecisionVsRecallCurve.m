% ===================== AreaOfPrecisionVsRecallCurve.m ============================= %
% Description  :

% Determine area under Precision-Recall Curve (PR-Curve)

% ====================================================================================%
% Input parameter :  Nothing  
% Output parameter:  Nothing  
% Subroutine  called : PrecisionAndRecallAtAllNtopAndArea.m 
% Called by :  
%        #1: Evaluation_Of_Retrieval_Performance_IF.m
%        #2: Evaluation_Of_Retrieval_Performance_JD.m
%        #3: Evaluation_Of_Retrieval_Performance_WithoutIF.m
% Reference:    
% Author of the code:  Rahul Das Gupta  
% Date of creation :    11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    12-03-2016
% Modification details:    
% Modified By :   Rahul Das Gupta 
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function AH = AreaOfPrecisionVsRecallCurve(D1,D2,D3,D4,D5,D6,D7,N_Class)

[AR1,AP1,Area1]=PrecisionAndRecallAtAllNtopAndArea(D1,N_Class);


[AR2,AP2,Area2]=PrecisionAndRecallAtAllNtopAndArea(D2,N_Class);


[AR3,AP3,Area3]=PrecisionAndRecallAtAllNtopAndArea(D3,N_Class);


[AR4,AP4,Area4]=PrecisionAndRecallAtAllNtopAndArea(D4,N_Class);


[AR5,AP5,Area5]=PrecisionAndRecallAtAllNtopAndArea(D5,N_Class);


[AR6,AP6,Area6]=PrecisionAndRecallAtAllNtopAndArea(D6,N_Class);


[AR7,AP7,Area7]=PrecisionAndRecallAtAllNtopAndArea(D7,N_Class);


AH=[Area1,Area2,Area3,Area4,Area5,Area6,Area7]/10000;

toc;
