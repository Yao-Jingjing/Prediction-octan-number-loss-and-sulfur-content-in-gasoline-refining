%% 该函数只是为了得到44列影响因素->产品硫和辛烷值的映射模型
clear global;
clear all; 
clc

%% I. 数据集预处理
%%
% 1. 加载训练集和测试集数据
load OptimizeFactor.mat %共47列，前两列是原料辛烷值和饱和烃，中间43列是主要操控变量，倒数第3列无法改，最后两列是产品硫和产品辛烷值
% OptimizeFactor(142,:)=[];
% OptimizeFactor([190 300 306 286 324],:)=[];
% OptimizeFactor([142,191,288,300,306,325],:)=[];
OptimizeFactor([142,191,287,301,307,325],:)=[];

% OptimizeFactor([142,211,214,287,296,325],:)=[];
% OptimizeFactor([142,307,211,214,287,296,325],:)=[];
datSet=OptimizeFactor;%前两列原料和倒数第3列虽不可控，但仍然为建模重要变量

% 2. 划分训练集和测试集
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1到ndata这些数随机打乱得到的一个随机数字序列作为索引
test_dataNumber = int32(0.2*ndata);  %选取数据集的百分之二十作为测试集合
test_datSet = datSet(random_index(1:test_dataNumber),:);  %以索引的前test_datSet个数据点作为测试样本Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %剩下的数据作为训练样本training_datSet

save test_datSet_S.mat test_datSet;
save training_datSet_S.mat training_datSet;

% 3. 拆分数据集输入和输出
%训练S
training_datSet_input = training_datSet(:,1:end-2).';
training_datSet_output = training_datSet(:,end-1).'; %选取产品S值作为输出结果
test_datSet_input = test_datSet(:,1:end-2).';
test_datSet_output = test_datSet(:,end-1).'; %选取选取产品S值作为输出结果作为输出结果

%% II. 数据归一化
%%
[Train_matrix,PS_input] = mapminmax(training_datSet_input);
Test_matrix = mapminmax('apply',test_datSet_input,PS_input);


%% II. 蜻蜓算法变量
%%
SearchAgents_no=40; % 蜻蜓数量
Max_iteration=12; % 最大迭代次数
lb = 5;
ub = 30;
dim = length(lb);
fobj = @BPNN;
   
[Best_score,Best_pos,cg_curve,BestNetS]=DA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,Train_matrix,training_datSet_output,Test_matrix,test_datSet_output);
save BestNetS.mat BestNetS %作为第4问的预测模型，预测硫

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
