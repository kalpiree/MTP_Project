load('Terravic_data');
imDir = ['C:\Users\chaithan\Desktop\Terravic Dataset'];
addpath(imDir);
negativeFolder = ['C:\Users\chaithan\Desktop\Terravic Negative'];
trainCascadeObjectDetector('Terravic_Face_Detector.xml',Terravic_data,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);