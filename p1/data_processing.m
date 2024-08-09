% 数据预处理
% Excel 处理

%%
clear all
close all
clc

%% 导入变量信息
TmpFileName = 'data/附件四：354个操作变量信息.xlsx';
TmpData = importdata(TmpFileName);

VarList = [TmpData.textdata(2:end,2:5), num2cell(TmpData.data(:,6))];

%% 导入待处理数据
TmpFileName = 'data/附件三：285号和313号样本原始数据.xlsx';
TmpData = importdata(TmpFileName);

%变量定义
V = cell(2,1); %操作变量
% V_Name = cell(2,1); %操作变量位号
% raw = cell(2,7); %原料性质：1.硫含量 2.辛烷值RON 3.饱和烃 4.烯烃 5.芳烃 6.溴值 7.密度
% pp = cell(2,2); %产品性质：1.硫含量 2.辛烷值RON
% sa = cell(2,2); %待生吸附剂：1.焦炭 2.硫
% ra = cell(2,2); %再生吸附剂：1.焦炭 2.硫

raw = TmpData.data.raw_material(:, 4:10);
raw(:,[2 3 4 5]) = raw(:,[5 2 3 4]); %重新排列
pp = TmpData.data.product(:, 4:5);
pp(:,[1 2]) = pp(:, [2 1]); %重新排列
sa = TmpData.data.Spent_adsorbent(:, 4:5);
ra = TmpData.data.Regenerated_adsorbent(:, 4:5);

V{1} = TmpData.data.Manipulate_variable(1:40, :); %样本285
V{2} = TmpData.data.Manipulate_variable(42:81, :); %样本313
V_Name = TmpData.textdata.Manipulate_variable(2, 2:end); %操作变量位号

%% 导入预处理的325个样本数据
TmpFileName = 'data/附件一：325个样本数据.xlsx';
TmpData = importdata(TmpFileName);

%TmpData.data(2:end, 3:11) TmpData.data(2:end, 13:end)
Sample_Data = TmpData.data(2:end, 17:end); %样本操作变量数据
Sample_Name = TmpData.textdata(2, 17:end); 

% 使用排序方式进行变量匹配
[~,I1] = sort(Sample_Name); [~,I2] = sort(I1);
[~,I3] = sort(V_Name);
V_Name = V_Name(I3);
V_Name = V_Name(I2);
V{1} = V{1}(:,I3);
V{1} = V{1}(:,I2);
V{2} = V{2}(:,I3);
V{2} = V{2}(:,I2);

[~, VarNum] = sort(VarList(:,1));
VarNum = VarNum(I2)'; %操作变量编号
VarDelta = cell2mat(VarList(VarNum,5));%操作变量每次调整幅度
VarDelta(isnan(VarDelta))=0; %空值置0

%对13个非操作变量继续编号
VarNum = [size(VarNum,2)+1:size(VarNum,2)+13 VarNum];
Sample_Name = [TmpData.textdata(3, 3:16) Sample_Name];%加入13个非操作变量名

%% 数据整定(4)：最大最小限幅
tmp=V{1}(:,300);
[V{1}] = max_min_limit(V{1},Sample_Data);
nanCount_1 = numel(V{1}(isnan(V{1})));
disp('数据整定(4):')
disp(['样本285剔除操作范围外数据',num2str(nanCount_1),'个', ',共剔除',num2str(nanCount_1),'个'])
V{1}(:,300)=tmp;

tmp=V{2}(:,300);
[V{2}] = max_min_limit(V{2},Sample_Data); 
nanCount_2 = numel(V{2}(isnan(V{2})));
nanCount = nanCount_1 + nanCount_2;
disp(['样本313剔除操作范围外数据', num2str(nanCount_2),'个', ',共剔除',num2str(nanCount),'个'])
V{2}(:,300)=tmp;

disp('观察数据，发现变量300被剔除为数值精度问题:')
disp(['    285号/313号数据值,' '                  325组样本最大值'])
disp([vpa(max(tmp)) vpa(TmpData.data(326,316))])

nanCount=nanCount-80;
disp(['恢复变量300的数据,实际共剔除',num2str(nanCount),'个'])

%% 数据整定(1)：残缺数据处理
%假设各位点2小时样本中40个数据中缺失10个数据，则认为残缺数据较多，将该位点删除
for j=1:size(V{1},2)
    logical_1=isnan(V{1}(:,j));
    if sum(logical_1)>=10
        V{1}(:,j)=nan;
    end
end
nanCount_3 = numel(V{1}(isnan(V{1})))+40-nanCount_1;
nanCount = nanCount + nanCount_3;
disp(' ')
disp('数据整定(1):')
disp(['样本285剔除残缺数据',num2str(nanCount_3),'个', ',共剔除',num2str(nanCount),'个'])

for j=1:size(V{2},2)
    logical_1=isnan(V{2}(:,j));
    if sum(logical_1)>=10
        V{2}(:,j)=nan;
    end
end
nanCount_4 = numel(V{2}(isnan(V{2})))+40-nanCount_2;
nanCount = nanCount + nanCount_4;
disp(['样本313剔除残缺数据',num2str(nanCount_4),'个', ',共剔除',num2str(nanCount),'个'])

%% 数据整定(5)：3σ准则
%添加非操作变量
Sample_Data=[TmpData.data(2:end, 3:11) TmpData.data(2:end, 13:16) Sample_Data];
% [Sample_Data(:,1:13)] = three_sigma(Sample_Data(:,1:13));
nanCount_5 = numel(Sample_Data(isnan(Sample_Data)));
nanCount = nanCount + nanCount_5;
disp(' ')
disp('数据整定(5):')
disp(['非操作变量剔除粗大误差数据', num2str(nanCount_5),'个', ',共剔除',num2str(nanCount),'个'])

%% 285/313样本平均
mean_285 = zeros(1,size(V{1},2));
for j = 1: size(V{1},2)    
    a = V{1}(:,j);    
    logical_1=isnan(a);
    if sum(logical_1)==40
        mean_285(j)=nan;
    else
        notNanValues=a(~isnan(a));
        mean_285(j)=sum(notNanValues)./length(notNanValues);   
    end
end 

mean_313 = zeros(1,size(V{2},2));
for j = 1: size(V{2},2)    
    a = V{2}(:,j);
    logical_1=isnan(a);
    if sum(logical_1)==40
        mean_313(j)=nan;
    else
        notNanValues=a(~isnan(a));
        mean_313(j)=sum(notNanValues)./length(notNanValues);   
    end
end 

%变量匹配
mean_285 = mean_285(I3);
mean_285 = mean_285(I2);
mean_313 = mean_313(I3);
mean_313 = mean_313(I2);

mean_285 = [raw(1,:) pp(1,:) sa(1,:) ra(1,:) mean_285]; %添加非操作变量
mean_313 = [raw(2,:) pp(2,:) sa(2,:) ra(2,:) mean_313]; %添加非操作变量

Sample_Data(285,:) = mean_285; %样本替换
Sample_Data(313,:) = mean_313;

%% 数据整定(2)：删除数据全部为空值的位点
%无效点及位点全部样本数据基本相等则认为是空值
%位点两个样本数据之差小于每次允许调整幅值则认为两个数据相等

logical_1 = (max(Sample_Data)-min(Sample_Data))>=[ones(13,1); abs(VarDelta)]';
logical_2 = ~all(isnan(Sample_Data),1);
logical_2 = logical_1 & logical_2;
Sample_Data = Sample_Data(:,logical_2);
disp(' ')
disp('数据整定(2):')
disp(['剔除全部为空值的位点', num2str(sum(~logical_2)),'个'])
DelNum = VarNum(~logical_2);
if ~isempty(DelNum) %输出还存在空值的位点名
    disp(['删除的位点编号为 ', num2str(DelNum)])
end

VarNum=VarNum(logical_2);
Sample_Name=Sample_Name(logical_2);
%% 数据整定(3):替代部分空值点
k=0;
for i = 2:size(Sample_Data,1)-1
    for j = 1:size(Sample_Data,2)
        if isnan(Sample_Data(i,j))
            Sample_Data(i,j)=(Sample_Data(i-1,j)+Sample_Data(i+1,j))/2;
            k=k+1;
        end
    end
end
disp(' ')
disp('数据整定(3):')
disp(['替代空值点', num2str(k),'个'])

logical_2 = all(~isnan(Sample_Data),1);
Sample_Data = Sample_Data(:,logical_2); %删除无效位点
DelNum = VarNum(~logical_2);
disp(' ')
if ~isempty(DelNum) %输出还存在空值的位点名
    disp(['删除的位点编号为 ', num2str(DelNum)])
end
disp(['处理后，还有', num2str(sum(~logical_2(14:end))),'列存在空值的位点'])
disp(['变量', num2str(sum(logical_2)),'个'])
% DelVar = Sample_Name(~logical_2); %删除的列名
% disp(['位号为 ', DelVar])
VarNum=VarNum(logical_2);
Sample_Name=Sample_Name(logical_2);

%%
save('Sample_Data.mat','Sample_Data');  
save('VarNum.mat','VarNum');  
save('Sample_Name.mat','Sample_Name');  
