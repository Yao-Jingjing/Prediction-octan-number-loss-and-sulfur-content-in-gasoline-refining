%% ���ļ����ڶ������Ż�����������Բ���ͼ
%% I. ��ջ�������
clc
clear

%% II. ���ݼ�Ԥ����
%%
% 1. ����ѵ�����Ͳ��Լ�����
load MainFactor %30��Factor+1��Result
xlswrite('MainFactor.xlsx',MainFactor);

datSet=MainFactor;

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
training_datSet_input = training_datSet(:,1:end-1).';
training_datSet_output = training_datSet(:,end).'; %ѡȡ��Ʒ����ֵ��Ϊ������
test_datSet_input = test_datSet(:,1:end-1).';
test_datSet_output = test_datSet(:,end).'; %ѡȡѡȡ��Ʒ����ֵ��Ϊ��������Ϊ������

test_datSet_new = test_datSet_input + (rand-0.5)*0.04*test_datSet_input; %���%+/-2��ƫ���Ŷ�����������������֤ģ����ȷ��
xlswrite('test_datSet_new.xlsx',test_datSet_new');%��GBDTģ�͵�����

%% III. ���ݹ�һ��
[Train_matrix,PS_input] = mapminmax(training_datSet_input);
[train_output,PS_output] = mapminmax(training_datSet_output);
Test_matrix = mapminmax('apply',test_datSet_input,PS_input);
Test_matrix_new = mapminmax('apply',test_datSet_new,PS_input);

%% IV.���þ��������Ż�����������
load BestNet
net = BestNet;

%% V. �������
%%
% 1. ������
NN_test_outputsNorm_new = net(Test_matrix_new);
%%
% 2. ����һ��
predict_test_new = mapminmax('reverse',NN_test_outputsNorm_new,PS_output);
%% VI. �����Ŷ������Ӧ��BPģ��Ԥ����
xlswrite('BPNN_y_new.xlsx',predict_test_new');