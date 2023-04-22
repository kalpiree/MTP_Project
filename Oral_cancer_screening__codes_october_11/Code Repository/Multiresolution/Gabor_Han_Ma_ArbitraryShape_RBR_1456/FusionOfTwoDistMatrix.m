function D = FusionOfTwoDistMatrix(D1,D2)

[M,N]=size(D1);
for i=1:N
    [~,I1]=sort(D1(i,:));
    [~,I2]=sort(D2(i,:));
    for k=1:N
        R1(i,I1(k))=k;
        R2(i,I2(k))=k;
    end
end
D=R1+R2;
end

