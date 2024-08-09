clear global;
clear all; 
clc
%% II. �������ݼ�
%%
global BestNetS
global BestNetXW
global PS_input
global PS_output_XW
global OptimizeFactor
global OptimizRec; %�Ż�ǰ���¼����������ǰ�����

%% II. ���ݼ�Ԥ����Ϊ�˵õ�PS_input��PS_output_XW��ֻҪrng(0)��ѵ�����Ͳ��Լ��Ļ�����һ�µ�
%%
% 1. ����ѵ�����Ͳ��Լ�����
load BestNetS %��EvaluePerformance����ʹ��
load BestNetXW %��EvaluePerformance����ʹ��
load Range
load OptimizeFactor 
datSet=OptimizeFactor;
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
training_datSet_input = training_datSet(:,1:end-2)'; %����ֵ����ֵ��������ͬ
training_datSet_output_XW = training_datSet(:,end)'; %ֻ������ֵ����Ҫ����һ��
% 4. ���ݹ�һ��
[~,PS_input] = mapminmax(training_datSet_input);
[~,PS_output_XW] = mapminmax(training_datSet_output_XW);

%% I. �����㷨����
%35ά����������������в����Ż�
%�Ľ������㷨����DA�ļ�������Delta_min,��ȷ����С��Delta_max

%%
fixnums = [1,8];
fixnums = sort(fixnums);%��֤Ϊ����
lb = Range(1,:); %Range�Ѿ�ɾ�������Ż������У�������ǰ��
ub = Range(2,:);
dirt = Range(3,:);
 
SearchAgents_no=40; % ��������
Max_iteration=20; % ����������
fobj = @EvaluePerformance;
OptimizRec = [];
% for samp_i = 1:2
for samp_i = 1:size(OptimizeFactor,1)
    samp_i %��ʾ��ǰ�����ĸ�����
    [Best_score,Best_pos,cg_curve,Product]=DA(SearchAgents_no,Max_iteration,lb,ub,dirt,fobj,samp_i,fixnums);
    Beforeline = [samp_i,OptimizeFactor(samp_i,:)]; %�Ż�ǰ
    %�Ż���
    for i = 1:length(fixnums)%����̶��У���ԭΪ�������Ż�����
        fixcol = OptimizeFactor(samp_i,fixnums(i));%Ϊһ��ֵ
        Best_pos = [Best_pos(1:fixnums(i)-1,1); fixcol; Best_pos(fixnums(i):end,1)];
    end
    Afterline = [samp_i,Best_pos',Product];
    OptimizRec = cat(1,OptimizRec,Beforeline);
    OptimizRec = cat(1,OptimizRec,Afterline);
end
xlswrite('�������Ż�.xlsx',OptimizRec);

BeforeS = [];
BeforeXW = [];
AfterS = [];
AfterXW = [];
BeforeLossXW = [];
AfterLossXW = [];
id = [];
for i = 1:2:size(OptimizRec,1) %����ż����
    id = cat(1,id,(i+1)/2);
    BeforeS = cat(1,BeforeS,OptimizRec(i,end-1));
    BeforeXW = cat(1,BeforeXW,OptimizRec(i,end));
    BeforeLossXW = cat(1,BeforeLossXW,OptimizRec(i,2)-OptimizRec(i,end));
    AfterS = cat(1,AfterS,OptimizRec(i+1,end-1));
    AfterXW = cat(1,AfterXW,OptimizRec(i+1,end));
    AfterLossXW = cat(1,AfterLossXW,OptimizRec(i+1,2)-OptimizRec(i+1,end));
end
xlswrite('��������ƷS������.xlsx',[id,BeforeS,AfterS,BeforeLossXW,AfterLossXW,BeforeXW,AfterXW]);
