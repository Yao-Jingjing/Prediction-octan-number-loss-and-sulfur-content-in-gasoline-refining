%% �ú���ֻ��Ϊ�˵õ�44��Ӱ������->��Ʒ�������ֵ��ӳ��ģ��
clear global;
clear all; 
clc

%% I. ���ݼ�Ԥ����
%%
% 1. ����ѵ�����Ͳ��Լ�����
load OptimizeFactor.mat %��47�У�ǰ������ԭ������ֵ�ͱ��������м�43������Ҫ�ٿر�����������3���޷��ģ���������ǲ�Ʒ��Ͳ�Ʒ����ֵ
% OptimizeFactor(142,:)=[];
% OptimizeFactor([190 300 306 286 324],:)=[];
% OptimizeFactor([142,191,288,300,306,325],:)=[];
OptimizeFactor([142,191,287,301,307,325],:)=[];

% OptimizeFactor([142,211,214,287,296,325],:)=[];
% OptimizeFactor([142,307,211,214,287,296,325],:)=[];
datSet=OptimizeFactor;%ǰ����ԭ�Ϻ͵�����3���䲻�ɿأ�����ȻΪ��ģ��Ҫ����

% 2. ����ѵ�����Ͳ��Լ�
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1��ndata��Щ��������ҵõ���һ���������������Ϊ����
test_dataNumber = int32(0.2*ndata);  %ѡȡ���ݼ��İٷ�֮��ʮ��Ϊ���Լ���
test_datSet = datSet(random_index(1:test_dataNumber),:);  %��������ǰtest_datSet�����ݵ���Ϊ��������Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %ʣ�µ�������Ϊѵ������training_datSet

save test_datSet_S.mat test_datSet;
save training_datSet_S.mat training_datSet;

% 3. ������ݼ���������
%ѵ��S
training_datSet_input = training_datSet(:,1:end-2).';
training_datSet_output = training_datSet(:,end-1).'; %ѡȡ��ƷSֵ��Ϊ������
test_datSet_input = test_datSet(:,1:end-2).';
test_datSet_output = test_datSet(:,end-1).'; %ѡȡѡȡ��ƷSֵ��Ϊ��������Ϊ������

%% II. ���ݹ�һ��
%%
[Train_matrix,PS_input] = mapminmax(training_datSet_input);
Test_matrix = mapminmax('apply',test_datSet_input,PS_input);


%% II. �����㷨����
%%
SearchAgents_no=40; % ��������
Max_iteration=12; % ����������
lb = 5;
ub = 30;
dim = length(lb);
fobj = @BPNN;
   
[Best_score,Best_pos,cg_curve,BestNetS]=DA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,Train_matrix,training_datSet_output,Test_matrix,test_datSet_output);
save BestNetS.mat BestNetS %��Ϊ��4�ʵ�Ԥ��ģ�ͣ�Ԥ����

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
