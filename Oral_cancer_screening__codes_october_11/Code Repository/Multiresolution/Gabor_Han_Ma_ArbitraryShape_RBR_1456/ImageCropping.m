function [CI,CM]= ImageCropping(I,M)

%     M=imread('Mask_10.tiff');
%     M=rgb2gray(M);

%     I=imread('Tex (131).tiff');

      I=double(I);
      [m,n]=size(I);
      %M=(M>0); % hid this statement
%     J=I.*M;
%     figure,imshow(J,[]);

       [a,b]=size(M);%anjali

      Stats = regionprops(M,'BoundingBox','Centroid');
      BB=Stats.BoundingBox;
      
%       x1=floor(BB(1));
%       y1=floor(BB(2));
%       x2=ceil(BB(1)+BB(3));
%       y2=ceil(BB(2)+BB(4));

      Center=Stats.Centroid;
      xc=double(Center(1));
      yc=double(Center(2));
      d=max(ceil(sqrt((BB(1)-xc)^2+(BB(2)-yc)^2)),...
            ceil(sqrt((BB(1)+BB(3)-xc)^2+(BB(2)+BB(4)-yc)^2)));
      d=uint16(d);
      %d=double(d); % anjali
      I1=zeros(2*d+m,2*d+n);
      %M1=zeros(2*d+m,2*d+n);
      M1=zeros(2*d+a,2*d+b);%anjali
      
      I1(d+1:d+m,d+1:d+n)=double(I(1:m,1:n));
     % M1(d+1:d+m,d+1:d+n)=double(M(1:m,1:n));
      M1(d+1:d+a,d+1:d+b)=double(M(1:a,1:b));%anjali
     
%     J1=J(y1:y2,x1:x2);
%     figure,imshow(J1,[]);

      CI=double(I1(yc+d-d:yc+d+d,xc+d-d:xc+d+d));
      CM=double(M1(yc+d-d:yc+d+d,xc+d-d:xc+d+d));
      CI=CI.*CM;
      
%     figure,imshow(CI,[]);
%     figure,imshow(CM,[]);

end
