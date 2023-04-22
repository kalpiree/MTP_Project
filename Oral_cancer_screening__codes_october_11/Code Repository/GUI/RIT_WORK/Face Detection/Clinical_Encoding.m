close all
clear all
clc
%% Load Xls file - Clinical Data
[num,txt,Clinical_Data]=xlsread('C:\Users\chaithan\Desktop\Clinical Data\Clinical Data Final\Patient_Record_v1.0_Copy.xlsx');

 %% ENCODING TABLE: 
%  1 in the respective Columns if True, 0 if False
 
% Column Index        Feature Vector
%         3       High - Socio-Economic Status
%         4       Medium - Socio-Economic Status
%         5       Low - Socio-Economic Status
%         6       Educated
%         7       Non-Educated
%         8       
%         9       Male
%         10      Female
%         11      Diabetes - Medical History
%         12      High Pressure - Medical History
%         13      Low Pressure - Medical History
%         14      Others - Medical History
%         15      High - Frequency
%         16      Medium - Frequency
%         17      Low - Frequency
%         18      None - Frequency
%         19      Veg
%         20      Non-Veg
%         21      Spicy
%         22      Non-Spicy
%         23      HIgh - Exposure
%         24      Medium - Exposure
%         25      Low - Exposure
%         26      None - Exposure
%         27      Alcohol - Oral Habits 
%         28      Tobacco - Oral Habits
%         29      Paan - Oral Habits
%         30      Others - Oral Habits

for i=2:212
    
    %% Socio-Economic Status
    if(strcmp(Clinical_Data(i,5),'L'))
        New_Write_Data(i,5)=1;
        New_Write_Data(i,4)=0;
        New_Write_Data(i,3)=0;
    end
     if(strcmp(Clinical_Data(i,5),'M'))
        New_Write_Data(i,5)=0;
        New_Write_Data(i,4)=1;
        New_Write_Data(i,3)=0;
     end
     if(strcmp(Clinical_Data(i,5),'H'))
        New_Write_Data(i,5)=0;
        New_Write_Data(i,4)=0;
        New_Write_Data(i,3)=1;
     end
     %% Education Status
    if(strcmp(Clinical_Data(i,6),'E'))
        New_Write_Data(i,6)=1;
        New_Write_Data(i,7)=0;
    else
        New_Write_Data(i,6)=0;
        New_Write_Data(i,7)=1;  
    end
    %% Sex
    if(strcmp(Clinical_Data(i,8),'M'))
        New_Write_Data(i,9)=1;
        New_Write_Data(i,10)=0;
    else
        New_Write_Data(i,9)=0;
        New_Write_Data(i,10)=1;  
    end
    %% Medical History
    if(length(size(Clinical_Data{i,14}))>1)
        Med_Hist_Split=strsplit(Clinical_Data{i,14},',');
    else
        Med_Hist_Split=Clinical_Data{i,14};
    end
    for index=1:length(Med_Hist_Split)
        if(strcmp(Med_Hist_Split(index),'O'))
            New_Write_Data(i,14)=1;
        end
        if(strcmp(Med_Hist_Split(index),'LP'))
            New_Write_Data(i,13)=1;
        end
        if(strcmp(Med_Hist_Split(index),'HP'))
            New_Write_Data(i,12)=1;
        end
        if(strcmp(Med_Hist_Split(index),'D'))
            New_Write_Data(i,11)=1;
        end
    end
    
    %% Frequency
        if(strcmp(Clinical_Data(i,18),'H'))
            New_Write_Data(i,15)=1;
        elseif(strcmp(Clinical_Data(i,18),'M'))
            New_Write_Data(i,16)=1;
        elseif(strcmp(Clinical_Data(i,18),'L'))
            New_Write_Data(i,17)=1;
        else
            New_Write_Data(i,18)=1;
        end
    %% Dietary Habits
     if(strcmp(Clinical_Data(i,19),'Veg'))
        New_Write_Data(i,19)=1;
        New_Write_Data(i,20)=0;
    else
        New_Write_Data(i,19)=0;
        New_Write_Data(i,20)=1;  
     end
     if(strcmp(Clinical_Data(i,20),'S'))
        New_Write_Data(i,21)=1;
        New_Write_Data(i,22)=0;
    else
        New_Write_Data(i,21)=0;
        New_Write_Data(i,22)=1;  
     end
       %% Exposure
       if(strcmp(Clinical_Data(i,17),'H'))
            New_Write_Data(i,23)=1;
        elseif(strcmp(Clinical_Data(i,17),'M'))
            New_Write_Data(i,24)=1;
        elseif(strcmp(Clinical_Data(i,17),'L'))
            New_Write_Data(i,25)=1;
        else
            New_Write_Data(i,26)=1;
       end
        
    %% Oral Habits
    if(length(size(Clinical_Data{i,16}))>1)
        Oral_Habit_Split=strsplit(Clinical_Data{i,16},',');
    else
        Oral_Habit_Split=Clinical_Data{i,16};
    end
    for index_oral=1:length(Oral_Habit_Split)
        if(strcmp(Oral_Habit_Split(index_oral),'None'))
            New_Write_Data(i,30)=1;
        end
        if(strcmp(Oral_Habit_Split(index_oral),'Paan'))
            New_Write_Data(i,29)=1;
        end
        if(strcmp(Oral_Habit_Split(index_oral),'Tobacco'))
            New_Write_Data(i,28)=1;
        end
        if(strcmp(Oral_Habit_Split(index_oral),'Alcohol'))
            New_Write_Data(i,27)=1;
        end
    end
end

%     xlswrite('C:\Users\chaithan\Desktop\Clinical Data\Clinical_Data - Copy.xlsx',New_Write_Data,2);
    

    