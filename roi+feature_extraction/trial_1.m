%[p,q]=size(originalimg);
 matrix = zeros(480,640);
 pos_pentagon = [25 99 300 170 89 396 56 401 240 550];
 ROI = insertShape(matrix,'FilledPolygon',{pos_pentagon},'Color', {'white'},'Opacity',1,'LineWidth',1);
 lt = imread ("C:\Users\ntnbs\Downloads\new_img.jpg");
  maxval=max(max(lt));
        minval=min(min(lt)); 
        range=255/(maxval-minval);
        lt=range.*(lt-minval); 
        lt = uint8(lt); 
        originalimg=lt;
        %figure,imshow(originalimg);

        % % % % % gamma correction for mask generation
        gamma = 1.2;
        lt=uint8(1.*((double(lt)).^gamma));
        %figure,imshow(I1);
        
        %% 2.Thresholding to segment out facial region
        %   Global thresholding has been used. Global threshold set to 252.
        lt = imbinarize(lt);
 figure,imshow(lt,[]);
 %[p,q]=size(originalimg);
    %matrix = zeros(p,q);
    %[r,s] = size(matrix);
    %[r,s] = size(matrix);