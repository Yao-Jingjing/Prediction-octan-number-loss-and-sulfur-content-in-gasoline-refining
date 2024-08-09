clear all
close all
clc

load Sample_Data;
load VarNum;

%% 自变量与目标MIC系数
Sample_Data(142,:)=[];
% % Sample_Data([190 300 306 286 324],:)=[];
% % Sample_Data([142,211,214,287,296,325],:)=[];

% Sample_Data([142,191,287,301,307,325],:)=[];

Factors = Sample_Data(:,[1:7,10:end]);%
Result = Sample_Data(:,8); %产品硫含量为目标

[m,n] = size(Factors);
MICCorrS=[];
for j=1:n
    u2=Factors(:,j);
    minestats = mine(Result',u2');
    MICCorrS(j,1)=minestats.mic;
end

save('MICCorrS.mat','MICCorrS');  