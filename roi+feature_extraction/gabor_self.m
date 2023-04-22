function gb = gabor_self(I,bw,theta) 
%I= imread("C:\Users\ntnbs\Downloads\sample_.jpg");
i = im2gray(I);
i = imresize(i, [500 500]); 
[a,b] =size(i);
%subplot(1,3,1);
%figure,imshow(i);
i= im2double(i);
gamma=0.3;
psi =0;
%theta =90;
%bw = 2.8;
lambda=3.5;
pi =180;
gb = zeros(a,b);
%for bw = 1:40:3
    %for theta = 0:180:30
        for x= 1:a
            for y = 1:b
                x_theta = i(x,y)*cos(theta)+i(x,y)*sin(theta);
                %y_theta = i(x,y)*sin(theta)+i(x,y)*cos(theta);
                y_theta = -i(x,y)*cos(theta)+i(x,y)*sin(theta);
                gb(x,y) = gb(x,y)+ exp(-(x_theta.^2/2*bw^2+ gamma^2*y_theta.^2/2*bw^2))*cos(2*pi/lambda*x_theta+psi);

            end    
        end
end    