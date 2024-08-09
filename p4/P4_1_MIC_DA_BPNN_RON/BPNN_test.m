%% ���ļ����ڶ������Ż�����������Բ���ͼ
%% I. ��ջ�������
clc
clear
close all

%% II. ���ݼ�Ԥ����
%%
% 1. ����ѵ�����Ͳ��Լ�����
load Range
load MainFactor2 %35��Factor+2��Result
DelNums = 142;
datSet=MainFactor;%35����ҪӰ������+2�в�Ʒֵ
datSet(DelNums,:)=[];

% 2. ����ѵ�����Ͳ��Լ�
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1��ndata��Щ��������ҵõ���һ���������������Ϊ����
test_dataNumber = int32(0.2*ndata);  %ѡȡ���ݼ��İٷ�֮��ʮ��Ϊ���Լ���
test_datSet = datSet(random_index(1:test_dataNumber),:);  %��������ǰtest_datSet�����ݵ���Ϊ��������Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %ʣ�µ�������Ϊѵ������training_datSet
training_dataNumber = size(training_datSet,1);      %training_dataNumber��ѵ��������

% 3. ������ݼ���������
training_datSet_input = training_datSet(:,1:end-2).';
training_datSet_output = training_datSet(:,end)'; %ѡȡ��Ʒ����ֵ��Ϊ������
test_datSet_input = test_datSet(:,1:end-2).';
test_datSet_output = test_datSet(:,end)'; %ѡȡѡȡ��Ʒ����ֵ��Ϊ��������Ϊ������

%% III. ���ݹ�һ��
[Train_input,PS_input] = mapminmax(training_datSet_input);
[train_output,PS_output] = mapminmax(training_datSet_output);
Test_input = mapminmax('apply',test_datSet_input,PS_input);

%% IV.���þ��������Ż�����������
load BestNetXW
net = BestNetXW;
% net = newff(Train_matrix,train_output,12,{'tansig', 'tansig'},'trainlm','learngdm','mse');
% net.trainParam.epochs = 500;       %��������
% net.trainParam.goal = 1e-4;         %ѵ��Ŀ����С���
% net.trainParam.lr = 0.05;          %ѧϰ����
% net.divideFcn = '';

net = train(net,Train_input,train_output);
%% V. �������
%%
% 1. ������
NN_train_outputsNorm = net(Train_input);
NN_test_outputsNorm = net(Test_input);

%%
% 2. ����һ��
predict_train = mapminmax('reverse',NN_train_outputsNorm,PS_output);
predict_test = mapminmax('reverse',NN_test_outputsNorm,PS_output);

%%
oldIndex = 1:size(datSet,2)-2;
fixnums = [1,6];
fixnums = sort(fixnums);%��֤Ϊ����
oldIndex(:,fixnums) = [];

one_sample = datSet(133,:);%��1������
for newIndex = 1:size(Range,2)%��ͬ�б���
    valueRange = Range(1,newIndex):Range(3,newIndex):Range(2,newIndex);
    ColSamps = repmat(one_sample,length(valueRange),1);%����һ�б�����ͬ��������
    for i = 1:length(valueRange) %������ͬȡֵ
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
% 3. ����Ա�
result_train = [training_datSet_output.' predict_train.'];
result_test = [test_datSet_output.' predict_test.'];
%%
% 4. �������ۺ���
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

% %% VI. ��ͼ
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