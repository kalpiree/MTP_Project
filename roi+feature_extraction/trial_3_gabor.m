I= imread("C:\Users\ntnbs\Downloads\sample_.jpg");
i = im2gray(I);
[a,b] =size(i)
%subplot(1,3,1);
%figure,imshow(i);
i= im2double(i);
gamma=0.3;
psi =0;
theta =90;
bw = 2.8;
lambda=3.5;
pi =180;
%for bw = 1:40:3
    %for theta = 0:180:30
        for x= 1:a
            for y = 1:b
                x_theta = i(x,y)*cos(theta)+i(x,y)*sin(theta);
                %y_theta = i(x,y)*sin(theta)+i(x,y)*cos(theta);
                y_theta = -i(x,y)*cos(theta)+i(x,y)*sin(theta);
                gb(x,y) = exp(-(x_theta.^2/2*bw^2+ gamma^2*y_theta.^2/2*bw^2))*cos(2*pi/lambda*x_theta+psi);

            end    
        end
        %i3 = i.*gb;
        figure,imshow(gb);
        %hold on 
        
    %end  
%end 
    

%subplot(1,3,2);
%figure,imshow(gb)
%i3 = i.*gb;
%subplot(1,3,3);
%figure,imshow(i3)
%figure,imhist(gb);
%figure,imhist(i3);
kall = kurtosis(gb,1,'all')
yall = skewness(gb,1,'all')
V = var(gb,1,"all")
M= mean(gb,"all")
glcm = graycomatrix(gb,'Offset',[-1 0;0 1;-1 1;-1 -1],'Symmetric',true);
stats = graycoprops(glcm);
%C = struct2cell(stats);
%C(1)
contrast = vertcat(stats.Contrast);
correlation = vertcat(stats.Correlation);
energy = vertcat(stats.Energy);
homogeneity = vertcat(stats.Homogeneity);
T = cat(2,contrast,correlation,energy,homogeneity,kall,yall,V,M);
T = cat(2,T,contrast,correlation,energy,homogeneity,kall,yall,V,M)
U = array2table(T);
U =[U;U]
%% not much use
%k=[];

%for i=1:size(MyMatrix)
    %k = MyMatrix(i);
%end
%for i=1:size(MyMatrix)
    %fprintf('%.2f,\n',k);
%end

%size(MyMatrix)
t= struct2table(stats);


