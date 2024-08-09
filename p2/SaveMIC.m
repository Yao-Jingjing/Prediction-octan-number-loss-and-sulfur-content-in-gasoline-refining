clear all
close all
clc

load Sample_Data;
load VarNum;

%% 自变量与目标MIC系数
Sample_Data(142,:)=[];
Factors = Sample_Data(:,[1:8,10:end]);%
Result = Sample_Data(:,9); %产品辛烷值为目标

[m,n] = size(Factors);
MICCorr=[];
for j=1:n
    u2=Factors(:,j);
    minestats = mine(Result',u2');
    MICCorr(j,1)=minestats.mic;
end

save('MICCorr.mat','MICCorr');  