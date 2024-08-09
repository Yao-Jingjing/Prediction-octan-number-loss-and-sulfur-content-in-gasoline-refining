clear;close all;
% clc;

%% II. 数据集预处理
%%
%1. 加载训练集和测试集数据
load OptimizeFactor.mat %共47列，前两列是原料辛烷值和饱和烃，中间43列是主要操控变量，最后两列是产品硫和产品辛烷值
OptimizeFactor([142,191,287,301,307,325],:)=[];
datSet=OptimizeFactor;%前两列原料和倒数第3列虽不可控，但仍然为建模重要变量
% 
%2. 划分训练集和测试集
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1到ndata这些数随机打乱得到的一个随机数字序列作为索引
test_dataNumber = int32(0.2*ndata);  %选取数据集的百分之二十作为测试集合
test_datSet = datSet(random_index(1:test_dataNumber),:);  %以索引的前test_datSet个数据点作为测试样本Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %剩下的数据作为训练样本training_datSet
training_dataNumber = size(training_datSet,1);      %training_dataNumber：训练样本数

% %不拆分
% test_datSet=OptimizeFactor;
% training_datSet=OptimizeFactor;

% 3. 拆分数据集输入和输出
training_datSet_input = training_datSet(:,1:end-2)';
training_datSet_output = training_datSet(:,end-1)'; %选取产品S值作为输出结果
Train_output_real = [training_datSet_output<=5;training_datSet_output>5];%%构造输出矩阵
[~,Train_class_real] = max(Train_output_real);
test_datSet_input = test_datSet(:,1:end-2)';
test_datSet_output = test_datSet(:,end-1)'; %选取选取产品S值作为输出结果作为输出结果
Test_output_real = [test_datSet_output<=5;test_datSet_output>5];%%构造输出矩阵
[~,Test_class_real] = max(Test_output_real);

%特征值归一化
[Train_input,PS_input] = mapminmax(training_datSet_input);
Test_input = mapminmax('apply',test_datSet_input,PS_input);

% %创建神经网络
% net = newff( Train_input, Train_output_real,15, { 'logsig' 'purelin' } , 'traingdx');%Train_input，Train_output的行数都是维度
% %设置训练参数
% net.trainparam.show = 50 ;
% net.trainparam.epochs = 500 ;
% net.trainparam.goal = 0.01 ;
% net.trainParam.lr = 0.01 ;

% %采用现有神经网络
load BestNetS.mat
net = BestNetS;

%仿真
Train_output_predict = net(Train_input);
Test_output_predict = net(Test_input);

%统计训练集识别正确率
[~, ns2] = size( Train_output_predict ) ;%s1是维度,s2是样本数
nhitNum = 0 ; Train_class_predict=zeros(size(Train_class_real));
for i = 1 : ns2
    [~ , nIndex] = max( Train_output_predict( : ,  i ) ) ;
    Train_class_predict(i)=nIndex;
    if( nIndex  == Train_class_real(i)   ) 
        nhitNum = nhitNum + 1 ; 
    end
end
sprintf('训练识别率是 %3.3f%%',100 * nhitNum / ns2 )

logical_1=logical(Train_class_predict==1);
logical_2=logical(Train_class_predict==2);
x0=1:ns2;
figure(2);
hold on;
scatter(x0(logical_1),training_datSet_output(logical_1));
scatter(x0(logical_2),training_datSet_output(logical_2),'filled');

%统计测试集识别正确率
[~, s2] = size( Test_output_predict ) ;%s1是维度,s2是样本数
hitNum = 0 ; Test_class_predict=zeros(size(Test_class_real));
for i = 1 : s2
    [~ , Index] = max( Test_output_predict( : ,  i ) ) ;
    Test_class_predict(i)=Index;
    if( Index  == Test_class_real(i)   ) 
        hitNum = hitNum + 1 ; 
    end
end
sprintf('测试识别率是 %3.3f%%',100 * hitNum / s2 )

logical_1=logical(Test_class_predict==1);
logical_2=logical(Test_class_predict==2);
x0=1:ns2;
figure(3);
hold on;
scatter(x0(logical_1),test_datSet_output(logical_1));
scatter(x0(logical_2),test_datSet_output(logical_2),'filled');

