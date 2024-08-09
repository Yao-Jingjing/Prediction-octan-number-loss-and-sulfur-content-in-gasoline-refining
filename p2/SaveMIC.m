clear all
close all
clc

load Sample_Data;
load VarNum;

%% �Ա�����Ŀ��MICϵ��
Sample_Data(142,:)=[];
Factors = Sample_Data(:,[1:8,10:end]);%
Result = Sample_Data(:,9); %��Ʒ����ֵΪĿ��

[m,n] = size(Factors);
MICCorr=[];
for j=1:n
    u2=Factors(:,j);
    minestats = mine(Result',u2');
    MICCorr(j,1)=minestats.mic;
end

save('MICCorr.mat','MICCorr');  