%% 该文件用于对蜻蜓优化过的网络测试并绘图
%% I. 清空环境变量
clc
clear
close all

%% II. 数据集预处理
%%
% 1. 加载训练集和测试集数据
load Range
load MainFactor2 %35列Factor+2列Result
DelNums = 142;
datSet=MainFactor;%35列主要影响因素+2列产品值
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
training_datSet_input = training_datSet(:,1:end-2).';
training_datSet_output = training_datSet(:,end)'; %选取产品辛烷值作为输出结果
test_datSet_input = test_datSet(:,1:end-2).';
test_datSet_output = test_datSet(:,end)'; %选取选取产品辛烷值作为输出结果作为输出结果

%% III. 数据归一化
[Train_input,PS_input] = mapminmax(training_datSet_input);
[train_output,PS_output] = mapminmax(training_datSet_output);
Test_input = mapminmax('apply',test_datSet_input,PS_input);

%% IV.采用经过蜻蜓优化过的神经网络
load BestNetXW
net = BestNetXW;
% net = newff(Train_matrix,train_output,12,{'tansig', 'tansig'},'trainlm','learngdm','mse');
% net.trainParam.epochs = 500;       %迭代次数
% net.trainParam.goal = 1e-4;         %训练目标最小误差
% net.trainParam.lr = 0.05;          %学习速率
% net.divideFcn = '';

net = train(net,Train_input,train_output);
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
oldIndex = 1:size(datSet,2)-2;
fixnums = [1,6];
fixnums = sort(fixnums);%保证为升序
oldIndex(:,fixnums) = [];

one_sample = datSet(133,:);%第1个样本
for newIndex = 1:size(Range,2)%不同列变量
    valueRange = Range(1,newIndex):Range(3,newIndex):Range(2,newIndex);
    ColSamps = repmat(one_sample,length(valueRange),1);%仅有一列变量不同的样本集
    for i = 1:length(valueRange) %变量不同取值
        oldInd = oldIndex(newIndex);
        ColSamps(i,oldInd) = valueRange(i);
    end
    ColInput = mapminmax('apply',ColSamps(:,1:end-2)',PS_input);
    NN_Col_outputsNorm = net(ColInput);
    Col_output = mapminmax('reverse',NN_Col_outputsNorm,PS_output);
    figure(newIndex)
    plot(valueRange,Col_output)
end


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

% %% VI. 绘图
% figure(1);
% plot(1:length(training_datSet_output),training_datSet_output,'r-*',1:length(predict_train),predict_train,'b:o');
% grid on;
% legend('True Value','Predicted Value');
% xlabel('Sample Number');
% ylabel('Sample Output Value');
% string_1 = {'Comparison of training set prediction results';['mse = ' num2str(mse_train) ' R^2 = ' num2str(r2_train)]};
% title(string_1);
% figure(2);
% plot(1:length(test_datSet_output),test_datSet_output,'r-*',1:length(predict_test),predict_test,'b:o');
% grid on;
% legend('TrueValue','PredictedValue');
% xlabel('Sample Number');
% ylabel('Sample Output Value');
% string_2 = {'Comparison of test set prediction results';['mse = ' num2str(mse_test) ' R^2 = ' num2str(r2_test)]};
% title(string_2);
% 
% figure(3);
% plot(predict_new)
%save new_datSet2.mat new_datSet2
%new_datSet2 = repmat(new_datSet2(1,:),8,1);