 clear all
 clc
 close all
 %%
 load('flag_Normal.mat');
 load('Result_ratio_Normal_1_07_16.mat');
 
 Normal_Result=Result_ratio_Normal_1_07_16;
 PR_Normal_Result=Result_ratio_proposed_Normal;
 
 nonzero_Normal=nnz(flag_Normal);
 Normal_Result=Normal_Result.*flag_Normal;
 mean_Normal_proposed=sum(Normal_Result)/nonzero_Normal;
 mean_Normal_PR=sum(PR_Normal_Result)/nonzero_Normal;
 
 
load('Result_ratio_Malig_1_07_16.mat');
load('flag_Malig.mat');

Malignant_Result=Result_ratio_Malig_1_07_16;
PR_Malignant_Result=Result_ratio_proposed_Malig;

Malignant_Result=Malignant_Result.*flag_Malig;
nonzero_Malig=nnz(flag_Malig);
mean_Malig_proposed=sum(Malignant_Result)/nonzero_Malig;
mean_Malig_PR=sum(PR_Malignant_Result)/nonzero_Malig;

load('flag_NonMalign.mat');
load('Result_ratio_NonMalig_1_07_16.mat');

NonMalignant_Result=Result_ratio_NonMalig_1_07_16;
PR_NonMalignant_Result=Result_ratio_proposed_NonMalig;

NonMalignant_Result=NonMalignant_Result.*flag_NonMalign;
nonzero_NonMalig=nnz(flag_NonMalign);
mean_NonMalig_proposed=sum(NonMalignant_Result)/nonzero_NonMalig;
mean_NonMalig_PR=sum(PR_NonMalignant_Result)/nonzero_NonMalig;

