% Missing Height -  Regression
close all
clear all
clc
%% Load Xls file - Clinical Data
filename='E:\Suraj Kiran\Suraj_Intern\Edited\Main Code Repository\Clinical Data Encoding\Clinical Data Final\Patient_Record_v1.0.xlsx';
[num,txt,Clinical_Data]=xlsread(filename,1);
count=1;
for i=1:size(num,1)
    if((not(isnan(num(i,8))) & not(isnan(num(i,9))))==1)
        Train_Weight(count)=num(i,8);
        Train_Height(count)=num(i,9);
        count=count+1;
    end
end
Index=find((not(isnan(num(:,8))) & isnan(num(:,9)))==1);
for count=1:size(Index)
Clinical_Data{Index(count)+1,10}=0.008867.*Clinical_Data{Index(count)+1,9}+4.691;
end
xlswrite(filename,Clinical_Data,4);