clear;
% 1. 加载训练集和测试集数据
load OptimizeFactor.mat %共47列，前两列是原料辛烷值和饱和烃，中间43列是主要操控变量，倒数第3列无法改，最后两列是产品硫和产品辛烷值
OptimizeFactor([142,191,287,301,307,325],:)=[];
datSet=OptimizeFactor;%前两列原料和倒数第3列虽不可控，但仍然为建模重要变量

% 2. 划分训练集和测试集
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1到ndata这些数随机打乱得到的一个随机数字序列作为索引
test_dataNumber = int32(0.2*ndata);  %选取数据集的百分之二十作为测试集合