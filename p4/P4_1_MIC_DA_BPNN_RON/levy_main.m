clear global;
clear all; 
clc
%% I. ���ݼ�Ԥ����
%%
% 1. ����ѵ�����Ͳ��Լ�����
load MainFactor2.mat
DelNums = 142;
datSet=MainFactor;%35����ҪӰ������+2�в�Ʒ����ֵ
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
training_datSet_input = training_datSet(:,1:end-2).';
training_datSet_output = training_datSet(:,end)'; %ѡȡ��Ʒ����ֵ��Ϊ������
test_datSet_input = test_datSet(:,1:end-2).';
test_datSet_output = test_datSet(:,end)'; %ѡȡѡȡ��Ʒ����ֵ��Ϊ��������Ϊ������

%% II. ���ݹ�һ��
%%
[Train_matrix,PS_input] = mapminmax(training_datSet_input);
[train_output,PS_output] = mapminmax(training_datSet_output);
Test_matrix = mapminmax('apply',test_datSet_input,PS_input);


%% II. �����㷨����
%%
SearchAgents_no=40; % ��������
Max_iteration=20; % ����������
lb = [5,1,1,1,1];
ub = [12,3,3,6,5];
dim = length(lb);
fobj = @BPNN;
   
[Best_score,Best_pos,cg_curve,BestNet]=DA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,Train_matrix,train_output,Test_matrix,test_datSet_output,PS_output);

save BestNetXW.mat BestNetXW

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
