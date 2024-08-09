clear global;
clear all; 
clc
%% I. 数据集预处理
%%
% 1. 加载训练集和测试集数据
load MainFactor1.mat
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

% 3. 拆分数据集输入和输出
training_datSet_input = training_datSet(:,1:end-1)';
training_datSet_output = training_datSet(:,end)'; %选取产品辛烷值作为输出结果
test_datSet_input = test_datSet(:,1:end-1)';
test_datSet_output = test_datSet(:,end)'; %选取选取产品辛烷值作为输出结果作为输出结果

%% II. 数据归一化
%%
[~,PS_input] = mapminmax(datSet(:,1:end-1)');
[~,PS_output] = mapminmax(datSet(:,end)');
Train_input = mapminmax('apply',training_datSet_input,PS_input);
Test_input = mapminmax('apply',test_datSet_input,PS_input);
train_output = mapminmax('apply',training_datSet_output,PS_output);

%% II. 蜻蜓算法变量
%%
SearchAgents_no=40; % 蜻蜓数量
Max_iteration=20; % 最大迭代次数
lb = [5,1,1,1];
ub = [12,3,6,5];
dim = length(lb);
fobj = @BPNN;
   
[Best_score,Best_pos,cg_curve,BestNet]=DA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,Train_input,train_output,Test_input,test_datSet_output,PS_output);

save BestNet.mat BestNet 

%Draw objective space
figure;
semilogy(cg_curve,'Color','r')
title('Convergence curve')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid off
box on
legend('DA')

display(['The best solution obtained by DA is : ', num2str(Best_pos')]);
display(['The best optimal value of the objective funciton found by DA is : ', num2str(Best_score)]);
