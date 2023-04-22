function Fmax= Masked_RIGaborFeatures(I,M,Ul,Uh,S,K)
Fmax=[];
response_cell=cell(1,6);

 for m=0:S-1
    
         [all_kernels_real,all_kernels_img,KRe,KIm]= RIGaborKernel(Ul,Uh,S,K,m);
         [rows,cols]=size(KRe);
        %  F=[];
        for n=0:1:5
            KRe=all_kernels_real{1,n+1};
            KIm=all_kernels_img{1,n+1};
        
        
         U=ones(rows,cols);
         R=conv2(M,U,'same');
         Max_R=max(R(:));
         L=(R==Max_R);
           
         JR=conv2(I,KRe,'same');
         JI=conv2(I,KIm,'same');
         J=sqrt(JR.^2+JI.^2);
%--------------------------------

response_cell{1,n+1}=J;

%----------------------------------- 
        end
 %--------------------------------------------       
     m1=response_cell{1,1};
     m2=response_cell{1,2};
     m3=response_cell{1,3};
     m4=response_cell{1,4};
     m5=response_cell{1,5};
     m6=response_cell{1,6};
     New=zeros(size(m1,1),size(m1,2));
     for x = 1: size(m1,1)
       
         for y = 1: size(m1,2)
         tmp=[ m1(x,y), m2(x,y), m3(x,y), m4(x,y), m5(x,y), m6(x,y) ];
         New(x,y)=max(tmp(:));
        
         end
        
     end
        
        
        
%-----------------------------------------------        
         
   F=Mask_BandFeature(New,L);
   Fmax=[Fmax,F];      
 end

end

function f =Mask_BandFeature(I,M)

L=logical(M);
f=[mean(abs(I(L))),sqrt(var(I(L)))];
end













%------------------------------------------------------------------------
% % function Fmax= Masked_RIGaborFeatures(I,M,Ul,Uh,S,K)
% % Fmax=[];
% % features=cell(1,6);
% %  for m=0:S-1
% %     
% %          [all_kernels_real,all_kernels_img,KRe,KIm]= RIGaborKernel(Ul,Uh,S,K,m);
% %          [rows,cols]=size(KRe);
% %           F=[];
% %         for n=0:1:5
% %             KRe=all_kernels_real{1,n+1};
% %             KIm=all_kernels_img{1,n+1};
% %         
% %         
% %          U=ones(rows,cols);
% %          R=conv2(M,U,'same');
% %          Max_R=max(R(:));
% %          L=(R==Max_R);
% %            
% %          JR=conv2(I,KRe,'same');
% %          JI=conv2(I,KIm,'same');
% %          J=sqrt(JR.^2+JI.^2);
% % %--------------------------------
% % %expt
% %      % imshow(J);
% % 
% % 
% % %----------------------------------- 
% %         features{1,n+1}=Mask_BandFeature(J,L);
% %         
% %             
% %          
% %         end
% %          
% %    F=features{1,:};
% %    Fmax=[Fmax,F];      
% %  end
% % 
% % end
% % 
% % function f =Mask_BandFeature(I,M)
% % 
% % L=logical(M);
% % f=[mean(abs(I(L))),sqrt(var(I(L)))];
% % end