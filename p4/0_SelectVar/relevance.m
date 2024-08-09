clear all
close all
clc

load Sample_Data;
load VarNum;
load MICCorrS;

%% �Ա�����Ŀ����������Է���
Sample_Data(142,:)=[];
% % Sample_Data([190 300 306 286 324],:)=[];
% 
% % Sample_Data([142,211,214,287,296,325],:)=[];
% 
% Sample_Data([142,191,287,301,307,325],:)=[];

[Train_matrix,PS_input] = mapminmax(Sample_Data');
Factors = Train_matrix([1:7,10:end],:);%��Ϊά�ȣ���Ϊ������
Result = Train_matrix(8,:); %��Ʒ����ֵΪĿ��

Corr = zeros(size(Factors,1),1);
for i = 1:size(Factors,1)
    CorrMat = corrcoef(Factors(i,:)',Result');
    Corr(i,1) = CorrMat(1,2);
end
AbsCorr = abs(Corr);
[DescendAbsCorr,index] = sort(AbsCorr,'descend');

%ǰ30����ر���
% sort(VarNum(index(1:30)))
% disp(Sample_Name(index(1:30)))

%% �Ա���֮���ǿ�����
[FactorCorr,FactorP] = corrcoef(Factors');
AbsFactorCorr = abs(FactorCorr);

%%
VarNum= VarNum([1:7,10:end]); %�������
Num = int16(zeros(1,max(VarNum))); %���

for i =1:length(VarNum)
    Num(VarNum(i))=i; %����Ԫ��ֵ������ֵ
end
%Num=Num(logical(Num));
%% ����
A=AbsFactorCorr; ANum=zeros(size(A));
for i = 1: size(A,1)
    for j = 1: size(A,2)
        ANum(i,j)=VarNum(i);
        if i<j
            A(i,j)=nan;
            ANum(i,j)=nan;            
        end
        if A(i,j)<0.9
            A(i,j)=nan; 
            ANum(i,j)=nan;       
        end        
    end
end

s=1:size(ANum,1);
for i = 1: size(ANum,1)
    logical_1=logical(~isnan(ANum(i,:)));
    if sum(logical_1)>1
        q=s(logical_1);
        for j=1:length(q)-1
            logical_2=logical(~isnan(ANum(:,q(j+1))));
            ANum(logical_2,q(1))=ANum(logical_2,q(j+1));            
        end
        ANum(:,q(2:end))=[];
    end
end

%% ����Ϣϵ��
MIC=zeros(size(ANum));
MIC(:,:)=nan;
for i=1:size(ANum,1)
    for j=1:size(ANum,2)
        if ~isnan(ANum(i,j))
            MIC(i,j)= MICCorrS(Num(ANum(i,j)));
        end
    end
end

%% ǰ30
for j=1:size(ANum,2)
    F = MIC(:,j);
    logical_1 = logical(~isnan(F));
    F1(1,j)=max(F(logical_1));
end
[~, I1] = sort(F1,'descend');
F1=F1(I1);

setVar=[];
for i = 1:size(I1,2)
    F = MIC(:,I1(i));
    logical_1 = logical(~isnan(F));
    n = sum(logical_1);
    F1 = ones(n,1); F1(:)=i;
    [F2,I2]=sort(F(logical_1),'descend');
    F3=ANum(logical_1,I1(i));
    F3=F3(I2);
    F0 = [F1 F3 F2];   
    setVar = [setVar; F0];    
end


setFactor=[];
for i=1:112
    for j=1:112
        setFactor(i,j)=FactorCorr(Num(setVar(i,2)),Num(setVar(j,2)));
    end
end

[~,ia,~] = unique(setVar(:,1),'rows');
setVar2=setVar(ia,:);
setFactor2=[];
for i=1:20
    for j=1:20
        setFactor2(i,j)=FactorCorr(Num(setVar2(i,2)),Num(setVar2(j,2)));
    end
end






