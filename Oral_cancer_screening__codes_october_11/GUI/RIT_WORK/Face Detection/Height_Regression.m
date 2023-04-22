% Missing Height -  Regression
close all
clear all
clc
%% Load Xls file - Clinical Data
filename='E:\Suraj Kiran\Suraj_Intern\Edited\Main Code Repository\Clinical Data Encoding\Clinical Data Final\Normal_Record_v1.0.xlsx';
[num,txt,Clinical_Data]=xlsread(filename);
count=1;
for i=1:size(num,1)
    if((not(isnan(num(i,3))) & not(isnan(num(i,4))))==1)
        Train_Weight(count)=num(i,3);
        Train_Height(count)=num(i,4);
        count=count+1;
    end
end
Index=find((not(isnan(num(:,3))) & isnan(num(:,4)))==1);
for count=1:size(Index)
Clinical_Data{Index(count)+1,10}=0.01487.*Clinical_Data{Index(count)+1,9}+4.453;
end
filename='E:\Suraj Kiran\Suraj_Intern\Edited\Main Code Repository\Clinical Data Encoding\Clinical Data Final\Normal_Record_v1.0.xlsx';
xlswrite(filename,Clinical_Data,2);