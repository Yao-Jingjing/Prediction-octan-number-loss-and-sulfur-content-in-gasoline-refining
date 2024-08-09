clear global;
clear all; 
clc
%% II. 加载数据集
%%
global BestNetS
global BestNetXW
global PS_input
global PS_output_XW
global OptimizeFactor
global OptimizRec; %优化前后记录，按样本从前向后排

%% II. 数据集预处理，为了得到PS_input、PS_output_XW，只要rng(0)，训练集和测试集的划分是一致的
%%
% 1. 加载训练集和测试集数据
load BestNetS %供EvaluePerformance函数使用
load BestNetXW %供EvaluePerformance函数使用
load Range
load OptimizeFactor 
datSet=OptimizeFactor;
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
training_datSet_input = training_datSet(:,1:end-2)'; %辛烷值和硫值的输入相同
training_datSet_output_XW = training_datSet(:,end)'; %只有辛烷值才需要反归一化
% 4. 数据归一化
[~,PS_input] = mapminmax(training_datSet_input);
[~,PS_output_XW] = mapminmax(training_datSet_output_XW);

%% I. 蜻蜓算法变量
%35维输入变量，其中两列不能优化
%改进蜻蜓算法，在DA文件中增加Delta_min,并确定其小于Delta_max

%%
fixnums = [1,8];
fixnums = sort(fixnums);%保证为升序
lb = Range(1,:); %Range已经删除不可优化变量列，并依次前移
ub = Range(2,:);
dirt = Range(3,:);
 
SearchAgents_no=40; % 蜻蜓数量
Max_iteration=20; % 最大迭代次数
fobj = @EvaluePerformance;
OptimizRec = [];
% for samp_i = 1:2
for samp_i = 1:size(OptimizeFactor,1)
    samp_i %显示当前处理哪个样本
    [Best_score,Best_pos,cg_curve,Product]=DA(SearchAgents_no,Max_iteration,lb,ub,dirt,fobj,samp_i,fixnums);
    Beforeline = [samp_i,OptimizeFactor(samp_i,:)]; %优化前
    %优化后
    for i = 1:length(fixnums)%插入固定列，还原为完整的优化输入
        fixcol = OptimizeFactor(samp_i,fixnums(i));%为一个值
        Best_pos = [Best_pos(1:fixnums(i)-1,1); fixcol; Best_pos(fixnums(i):end,1)];
    end
    Afterline = [samp_i,Best_pos',Product];
    OptimizRec = cat(1,OptimizRec,Beforeline);
    OptimizRec = cat(1,OptimizRec,Afterline);
end
xlswrite('各样本优化.xlsx',OptimizRec);

BeforeS = [];
BeforeXW = [];
AfterS = [];
AfterXW = [];
BeforeLossXW = [];
AfterLossXW = [];
id = [];
for i = 1:2:size(OptimizRec,1) %正好偶数行
    id = cat(1,id,(i+1)/2);
    BeforeS = cat(1,BeforeS,OptimizRec(i,end-1));
    BeforeXW = cat(1,BeforeXW,OptimizRec(i,end));
    BeforeLossXW = cat(1,BeforeLossXW,OptimizRec(i,2)-OptimizRec(i,end));
    AfterS = cat(1,AfterS,OptimizRec(i+1,end-1));
    AfterXW = cat(1,AfterXW,OptimizRec(i+1,end));
    AfterLossXW = cat(1,AfterLossXW,OptimizRec(i+1,2)-OptimizRec(i+1,end));
end
xlswrite('仅保留产品S和辛烷.xlsx',[id,BeforeS,AfterS,BeforeLossXW,AfterLossXW,BeforeXW,AfterXW]);
