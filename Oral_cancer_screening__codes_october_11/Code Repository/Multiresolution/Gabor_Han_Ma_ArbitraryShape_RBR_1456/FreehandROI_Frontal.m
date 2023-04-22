cd('..\..\..\ThermalDatabase');
disp('Enter your choice');
disp('1: Malignant');
disp('2: NonMalignant');
disp('1: Normal');
question=('Enter The Above options: ');
User_Choice=input(question,'s');

if (strcmp(User_Choice,'1')==1)
    %%
%'Normal Subjects' 
            d = dir('..\..\..\ThermalDatabase\Normal');%%% d stores a structure of 6 fields
           
            isub = [d(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
            nameFolds = {d(isub).name}'; 
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
            
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
            
            figure,imshow(I1);
            
            prompt = 'Enter column of left Eye';
            
            
            end
elseif (strcmp(User_Choice,'2')==1)
       %%
%'Malignant Subjects' 
            d = dir('..\..\..\ThermalDatabase\Malignant');%%% d stores a structure of 6 fields
           
            isub = [d(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
            nameFolds = {d(isub).name}'; 
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
            
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
            figure,imshow(I1); 
            end    
elseif (strcmp(User_Choice,'3')==1)
     %%
%'NonMalignant Subjects' 
            d = dir('..\..\..\ThermalDatabase\NonMalignant');%%% d stores a structure of 6 fields
           
            isub = [d(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
            nameFolds = {d(isub).name}'; 
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            
            for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\NonMaligant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
            
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
            
            figure,imshow(I1);
            end 
else (Invalid)
 
    
end
          