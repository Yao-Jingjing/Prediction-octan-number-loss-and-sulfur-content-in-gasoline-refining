%% 该文件用于对蜻蜓优化过的网络测试并绘图
%% I. 清空环境变量
clc
clear

%% II. 数据集预处理
%%
% 1. 加载训练集和测试集数据
load MainFactor1 %30列Factor+1列Result
DelNums = 142;
datSet=MainFactor;%30列主要影响因素+1列产品辛烷值
datSet(DelNums,:)=[];

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
training_datSet_output = training_datSet(:,end)'; %选取产品辛烷值作为输出结果
test_datSet_input = test_datSet(:,1:end-1).';
test_datSet_output = test_datSet(:,end)'; %选取选取产品辛烷值作为输出结果作为输出结果

%% III. 数据归一化
[~,PS_input] = mapminmax(datSet(:,1:end-1)');
[~,PS_output] = mapminmax(datSet(:,end)');
Train_input = mapminmax('apply',training_datSet_input,PS_input);
Test_input = mapminmax('apply',test_datSet_input,PS_input);
train_output = mapminmax('apply',training_datSet_output,PS_output);

%% IV.采用经过蜻蜓优化过的神经网络
load BestNet
net = BestNet;

%% V. 仿真测试
%%
% 1. 输出结果
NN_train_outputsNorm = net(Train_input);
NN_test_outputsNorm = net(Test_input);
%%
% 2. 反归一化
predict_train = mapminmax('reverse',NN_train_outputsNorm,PS_output);
predict_test = mapminmax('reverse',NN_test_outputsNorm,PS_output);
%%
% 3. 结果对比
result_train = [training_datSet_output.' predict_train.'];
result_test = [test_datSet_output.' predict_test.'];
%%
% 4. 计算评价函数
eval_train = cal_eval(training_datSet_output.',predict_train.');
eval_test = cal_eval(test_datSet_output.',predict_test.');
mse_train = eval_train(1);
rmse_train = eval_train(2);
mae_train = eval_train(3);
mape_train = eval_train(4);
r2_train = eval_train(5);
mse_test = eval_test(1);
rmse_test = eval_test(2);
mae_test = eval_test(3);
mape_test = eval_test(4);
r2_test = eval_test(5);

%% VI. 绘图
figure(1);
plot(1:length(training_datSet_output),training_datSet_output,'r-*',1:length(predict_train),predict_train,'b:o');
grid on;
legend('True Value','Predicted Value');
xlabel('Sample Number');
ylabel('Sample Output Value');
string_1 = {'Comparison of training set prediction results';['mse = ' num2str(mse_train) ' R^2 = ' num2str(r2_train)]};
title(string_1);
figure(2);
plot(1:length(test_datSet_output),test_datSet_output,'r-*',1:length(predict_test),predict_test,'b:o');
grid on;
legend('TrueValue','PredictedValue');
xlabel('Sample Number');
ylabel('Sample Output Value');
string_2 = {'Comparison of test set prediction results';['mse = ' num2str(mse_test) ' R^2 = ' num2str(r2_test)]};
title(string_2);

