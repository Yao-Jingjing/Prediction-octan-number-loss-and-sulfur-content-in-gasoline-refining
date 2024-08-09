%% 该文件用于对蜻蜓优化过的网络测试并绘图
%% I. 清空环境变量
clc
clear

%% II. 数据集预处理
%%
% 1. 加载训练集和测试集数据
load MainFactor %30列Factor+1列Result
xlswrite('MainFactor.xlsx',MainFactor);

datSet=MainFactor;

% 2. 划分训练集和测试集
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1到ndata这些数随机打乱得到的一个随机数字序列作为索引
test_dataNumber = int32(0.2*ndata);  %选取数据集的百分之二十作为测试集合
test_datSet = datSet(random_index(1:test_dataNumber),:);  %以索引的前test_datSet个数据点作为测试样本Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %剩下的数据作为训练样本training_datSet
training_dataNumber = size(training_datSet,1);      %training_dataNumber：训练样本数

% 3. 拆分数据集输入和输出
training_datSet_input = training_datSet(:,1:end-1).';
training_datSet_output = training_datSet(:,end).'; %选取产品辛烷值作为输出结果
test_datSet_input = test_datSet(:,1:end-1).';
test_datSet_output = test_datSet(:,end).'; %选取选取产品辛烷值作为输出结果作为输出结果

test_datSet_new = test_datSet_input + (rand-0.5)*0.04*test_datSet_input; %添加%+/-2的偏差扰动，产生新样本，验证模型正确性
xlswrite('test_datSet_new.xlsx',test_datSet_new');%给GBDT模型的输入

%% III. 数据归一化
[Train_matrix,PS_input] = mapminmax(training_datSet_input);
[train_output,PS_output] = mapminmax(training_datSet_output);
Test_matrix = mapminmax('apply',test_datSet_input,PS_input);
Test_matrix_new = mapminmax('apply',test_datSet_new,PS_input);

%% IV.采用经过蜻蜓优化过的神经网络
load BestNet
net = BestNet;

%% V. 仿真测试
%%
% 1. 输出结果
NN_test_outputsNorm_new = net(Test_matrix_new);
%%
% 2. 反归一化
predict_test_new = mapminmax('reverse',NN_test_outputsNorm_new,PS_output);
%% VI. 保存扰动输入对应的BP模型预测结果
xlswrite('BPNN_y_new.xlsx',predict_test_new');