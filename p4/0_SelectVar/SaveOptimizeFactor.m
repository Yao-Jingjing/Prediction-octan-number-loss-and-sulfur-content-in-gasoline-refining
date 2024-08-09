load MainFactor;

load Sample_Data;
load VarNum;
% Sample_Data(142,:)=[];

%VarNum= VarNum([1:7,10:end]); %变量编号
Num = int16(zeros(1,max(VarNum))); %序号
for i =1:length(VarNum)
    Num(VarNum(i))=i; %交换元素值和索引值
end

b=[218,313,314,53,247];
b=[b 362];
a=Num(b);

OptimizeFactor = [MainFactor(:,1:end-1) Sample_Data(:,a) MainFactor(:,end)];
save('OptimizeFactor.mat','OptimizeFactor')
