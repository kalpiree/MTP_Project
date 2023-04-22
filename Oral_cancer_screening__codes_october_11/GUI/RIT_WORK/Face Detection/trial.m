dbstop if error;
img_display =input('enter image name');
img_display1=img_display(img_display>0);
min1 = min(img_display1);
max1 = max(img_display1);
figure, imshow(img_display,[min1 max1]);