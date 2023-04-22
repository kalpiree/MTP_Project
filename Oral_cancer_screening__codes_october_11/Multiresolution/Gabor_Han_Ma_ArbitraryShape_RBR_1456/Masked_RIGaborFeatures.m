function F= Masked_RIGaborFeatures(I,M,Ul,Uh,S,K)
F=[];
 for m=0:S-1
    
         [KRe,KIm]= RIGaborKernel(Ul,Uh,S,K,m);
         
         [m,n]=size(KRe);
         U=ones(m,n);
         R=conv2(M,U,'same');
         Max_R=max(R(:));
         L=(R==Max_R);
             
         JR=conv2(I,KRe,'same');
         JI=conv2(I,KIm,'same');
         J=sqrt(JR.^2+JI.^2);

         F=[F,[Mask_BandFeature(J,L)]];
     
 end

end

function f =Mask_BandFeature(I,M)

L=logical(M);
f=[mean(abs(I(L))),sqrt(var(I(L)))];
end