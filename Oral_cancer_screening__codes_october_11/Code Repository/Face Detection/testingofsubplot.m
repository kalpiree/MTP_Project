close all;
clc;
T093 = mat2gray(xlsread('T093.csv'));
T093_lt = mat2gray(xlsread('T093_lt.csv'));
T093_rt = mat2gray(xlsread('T093_rt.csv'));
subplot(1,3,1),imshow(T093);
subplot(1,3,2),imshow(T093_lt);
subplot(1,3,3),imshow(T093_rt);