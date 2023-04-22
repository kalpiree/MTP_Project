%  d = dir('F:\MS\matlab_code\WORK\TDatabase_10_4_2017\Normal');
% d = dir('F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant');
   d = dir('I:\ThermalOOC_Manashi\NonMalignant');          
       %d = dir('F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant');      
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
            
            for folder_idx=1:no_dir
             disp(nameFolds(folder_idx));
%              check=[24,61,63,65,75];
%              if ismember(folder_idx,check)
%                  continue;
%              end
             close all;
             rel_path_dest= ['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx},'\'];
             cd(rel_path_dest);
             folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
%              if exist(folder_name)
%                  remove(folder_name)
%              end    
              if exist(folder_name)
                   rmdir(folder_name,'s');
              end
%                     
%                     cd(['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\Normal\',nameFolds{folder_idx},'\'])
                    mkdir(['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx},'\',folder_name]);
                    cd(folder_name);
               
  %           mkdir(folder_name);
             rel_path_dest_1=[rel_path_dest,folder_name]
             rel_path_source=['I:\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','A_ROI_Front_' nameFolds{folder_idx} ,'\A_ROI_Front.mat'];
             if (~exist (rel_path_source))
                 continue;
             end    

    
            copyfile(rel_path_source,rel_path_dest_1)
%               
             
            end