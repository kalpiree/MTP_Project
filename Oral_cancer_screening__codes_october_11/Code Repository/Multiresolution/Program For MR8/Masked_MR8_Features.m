function f = Masked_MR8_Features(I,M,ROS_idx,N_Scale,N_Orientation)

[m,n]=size(I);
F_Size=9;
U=ones(F_Size,F_Size);
P=conv2(M,U,'same');
Max_P=max(P(:));
L=(P==Max_P);

F=makeRFSfilters(ROS_idx,N_Scale,N_Orientation);
I=double(I);

R=zeros(m,n,10);

for i=1:(2*N_Scale)
    for j=1:N_Orientation
        Y=double(filter2(F(:,:,(i-1)*2*N_Scale+j),I,'same'));
        R(:,:,i)=max(R(:,:,i),Y);
    end
end
 
Y=double(filter2(F(:,:,(2*N_Scale*N_Orientation)+1),I,'same'));
R(:,:,7)=Y;

Y=double(filter2(F(:,:,(2*N_Scale*N_Orientation)+2),I,'same'));
R(:,:,8)=Y;

% f1=Masked_BandFeature(R(:,:,1),L);
% f2=Masked_BandFeature(R(:,:,2),L);
% f3=Masked_BandFeature(R(:,:,3),L);
% f4=Masked_BandFeature(R(:,:,4),L);
% f5=Masked_BandFeature(R(:,:,5),L);
% f6=Masked_BandFeature(R(:,:,6),L);
% f7=Masked_BandFeature(R(:,:,7),L);
% f8=Masked_BandFeature(R(:,:,8),L);
% 
% f=[f1,f2,f3,f4,f5,f6,f7,f8];

f=[];
for i=1:(2*N_Scale)+2
    f=[f,Masked_BandFeature(R(:,:,i),L)];
end
end



function f =Masked_BandFeature(I,M)

L=logical(M);
f=[mean(abs(I(L))),sqrt(var(I(L)))];
end
