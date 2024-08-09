clear all
close all
clc

load Sample_Data;
load VarNum;
load MICCorr;

%% �Ա�����Ŀ����������Է���
[Train_matrix,PS_input] = mapminmax(Sample_Data');
Factors = Train_matrix([1:8,10:end],[1:141,143:end]);%��Ϊά�ȣ���Ϊ������
Result = Train_matrix(9,[1:141,143:end]); %��Ʒ����ֵΪĿ��

Corr = zeros(size(Factors,1),1);
for i = 1:size(Factors,1)
    CorrMat = corrcoef(Factors(i,:)',Result');
    Corr(i,1) = CorrMat(1,2);
end
AbsCorr = abs(Corr);
[DescendAbsCorr,index] = sort(AbsCorr,'descend');

%%
VarNum= VarNum([1:8,10:end]); %�������
Num = int16(zeros(1,max(VarNum))); %���

for i =1:length(VarNum)
    Num(VarNum(i))=i; %����Ԫ��ֵ������ֵ
end

a = [356;111;353;306;233;357;26;301;122;231;44;54;79;276;346;251;22;...
    159;249;76;272;154;1;96;242;253;218;60;131;171];
b=[218,313,314,53,247];
setVarNum=[a;b'];
setCorr=Corr(Num(setVarNum));





