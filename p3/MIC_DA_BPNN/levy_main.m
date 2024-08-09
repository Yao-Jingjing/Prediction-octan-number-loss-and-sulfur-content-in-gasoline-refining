clear global;
clear all; 
clc
%% I. ���ݼ�Ԥ����
%%
% 1. ����ѵ�����Ͳ��Լ�����
load MainFactor1.mat
DelNums = 142;
datSet=MainFactor;%30����ҪӰ������+1�в�Ʒ����ֵ
datSet(DelNums,:)=[];

% 2. ����ѵ�����Ͳ��Լ�
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1��ndata��Щ��������ҵõ���һ���������������Ϊ����
test_dataNumber = int32(0.2*ndata);  %ѡȡ���ݼ��İٷ�֮��ʮ��Ϊ���Լ���
test_datSet = datSet(random_index(1:test_dataNumber),:);  %��������ǰtest_datSet�����ݵ���Ϊ��������Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %ʣ�µ�������Ϊѵ������training_datSet

% 3. ������ݼ���������
training_datSet_input = training_datSet(:,1:end-1)';
training_datSet_output = training_datSet(:,end)'; %ѡȡ��Ʒ����ֵ��Ϊ������
test_datSet_input = test_datSet(:,1:end-1)';
test_datSet_output = test_datSet(:,end)'; %ѡȡѡȡ��Ʒ����ֵ��Ϊ��������Ϊ������

%% II. ���ݹ�һ��
%%
[~,PS_input] = mapminmax(datSet(:,1:end-1)');
[~,PS_output] = mapminmax(datSet(:,end)');
Train_input = mapminmax('apply',training_datSet_input,PS_input);
Test_input = mapminmax('apply',test_datSet_input,PS_input);
train_output = mapminmax('apply',training_datSet_output,PS_output);

%% II. �����㷨����
%%
SearchAgents_no=40; % ��������
Max_iteration=20; % ����������
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
