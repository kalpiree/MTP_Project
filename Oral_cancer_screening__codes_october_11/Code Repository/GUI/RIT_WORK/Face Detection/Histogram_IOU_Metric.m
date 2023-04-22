clear all
%% Proposed Method
load('Results_Proposed.mat');
IOU_Overall=IOU_Overall.*(IOU_Overall>0);
x1=IOU_Overall;
centers=0.1:0.2:1;
counts(1,:) = hist(x1,centers);
clear all
%% ACEEE Method
load('Results_ACEEE.mat');centers=0.1:0.2:1;
IOU_Overall=IOU_Overall.*(IOU_Overall>0);
x2=IOU_Overall;
counts(1,:) = hist(x2,centers);
clear all

%% PR Otsu Method
load('Results_PR.mat');centers=0.1:0.2:1;
IOU_Overall=IOU_Overall.*(IOU_Overall>0);
x3=IOU_Overall;
counts(1,:) = hist(x3,centers);
clear all

%% Viola Method
load('Results_Viola.mat');centers=0.1:0.2:1;
IOU_Overall=IOU_Overall.*(IOU_Overall>0);
x4=IOU_Overall;
counts(1,:) = hist(x4,centers);
clear all

%% Viola Optical Method
load('Results_Viola_Optical.mat');centers=0.1:0.2:1;
IOU_Overall=IOU_Overall.*(IOU_Overall>0);
x6=IOU_Overall;
counts(1,:) = hist(x6,centers);
clear all

%% Plots
% alpha(0.9);
% colour_map=['r','g','y','b','c'];
% count(:,1)=sort(counts(:,1),'descend');
% count(:,2)=sort(counts(:,2),'descend');
% count(:,3)=sort(counts(:,3),'descend');
% count(:,4)=sort(counts(:,4),'descend');
% count(:,5)=sort(counts(:,5),'descend');
% for i=1:5
%     for j=1:5
%         [p,q]=find(count(i,j)==counts,1);
%         colour_matrix(i,j)=colour_map(p);
%     end
% end
figure();
% for i=1:5
%     bar(centers,count(1,i),colour_matrix(1,i));hold on;
% end
% bar(centers,count(2,:),colour_matrix(2,:));hold on;
% bar(centers,count(3,:),colour_matrix(3,:));hold on;
% bar(centers,count(4,:),colour_matrix(4,:));hold on;
% bar(centers,count(5,:),colour_matrix(5,:));hold on;
y=[];
for i=1:5
y(i,:)=counts(:,i);
end
figure();
bar(centers,y);


