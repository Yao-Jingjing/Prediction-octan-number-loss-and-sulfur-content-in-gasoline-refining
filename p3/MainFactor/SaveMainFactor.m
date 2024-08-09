% 输出数据

%%
clear all
close all
clc

load Sample_Data;
load VarNum;

%%
%VarNum= VarNum([1:8,10:end]); %变量编号
Num = int16(zeros(1,max(VarNum))); %序号

for i =1:length(VarNum)
    Num(VarNum(i))=i; %交换元素值和索引值
end

% setVarNum = [356;111;353;306;233;357;26;301;122;231;44;54;79;276;346;251;22;...
%     159;249;76;272;154;1;96;242;253;218;60;131;171];

setVarNum = [356;111;353;112;306;116;233;357;26;301;122;231;107;44;54;79;...
    276;346;251;87;22;159;147;249;76;272;154;1;96;241];

setVarNum = [setVarNum; 363]';

% MainFactor = Sample_Data([1:141,143:end],Num(setVarNum));

MainFactor = Sample_Data(:,Num(setVarNum));
%%
save('MainFactor.mat','MainFactor');    
