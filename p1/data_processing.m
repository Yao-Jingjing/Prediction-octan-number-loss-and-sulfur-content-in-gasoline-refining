% ����Ԥ����
% Excel ����

%%
clear all
close all
clc

%% ���������Ϣ
TmpFileName = 'data/�����ģ�354������������Ϣ.xlsx';
TmpData = importdata(TmpFileName);

VarList = [TmpData.textdata(2:end,2:5), num2cell(TmpData.data(:,6))];

%% �������������
TmpFileName = 'data/��������285�ź�313������ԭʼ����.xlsx';
TmpData = importdata(TmpFileName);

%��������
V = cell(2,1); %��������
% V_Name = cell(2,1); %��������λ��
% raw = cell(2,7); %ԭ�����ʣ�1.���� 2.����ֵRON 3.������ 4.ϩ�� 5.���� 6.��ֵ 7.�ܶ�
% pp = cell(2,2); %��Ʒ���ʣ�1.���� 2.����ֵRON
% sa = cell(2,2); %������������1.��̿ 2.��
% ra = cell(2,2); %������������1.��̿ 2.��

raw = TmpData.data.raw_material(:, 4:10);
raw(:,[2 3 4 5]) = raw(:,[5 2 3 4]); %��������
pp = TmpData.data.product(:, 4:5);
pp(:,[1 2]) = pp(:, [2 1]); %��������
sa = TmpData.data.Spent_adsorbent(:, 4:5);
ra = TmpData.data.Regenerated_adsorbent(:, 4:5);

V{1} = TmpData.data.Manipulate_variable(1:40, :); %����285
V{2} = TmpData.data.Manipulate_variable(42:81, :); %����313
V_Name = TmpData.textdata.Manipulate_variable(2, 2:end); %��������λ��

%% ����Ԥ�����325����������
TmpFileName = 'data/����һ��325����������.xlsx';
TmpData = importdata(TmpFileName);

%TmpData.data(2:end, 3:11) TmpData.data(2:end, 13:end)
Sample_Data = TmpData.data(2:end, 17:end); %����������������
Sample_Name = TmpData.textdata(2, 17:end); 

% ʹ������ʽ���б���ƥ��
[~,I1] = sort(Sample_Name); [~,I2] = sort(I1);
[~,I3] = sort(V_Name);
V_Name = V_Name(I3);
V_Name = V_Name(I2);
V{1} = V{1}(:,I3);
V{1} = V{1}(:,I2);
V{2} = V{2}(:,I3);
V{2} = V{2}(:,I2);

[~, VarNum] = sort(VarList(:,1));
VarNum = VarNum(I2)'; %�����������
VarDelta = cell2mat(VarList(VarNum,5));%��������ÿ�ε�������
VarDelta(isnan(VarDelta))=0; %��ֵ��0

%��13���ǲ��������������
VarNum = [size(VarNum,2)+1:size(VarNum,2)+13 VarNum];
Sample_Name = [TmpData.textdata(3, 3:16) Sample_Name];%����13���ǲ���������

%% ��������(4)�������С�޷�
tmp=V{1}(:,300);
[V{1}] = max_min_limit(V{1},Sample_Data);
nanCount_1 = numel(V{1}(isnan(V{1})));
disp('��������(4):')
disp(['����285�޳�������Χ������',num2str(nanCount_1),'��', ',���޳�',num2str(nanCount_1),'��'])
V{1}(:,300)=tmp;

tmp=V{2}(:,300);
[V{2}] = max_min_limit(V{2},Sample_Data); 
nanCount_2 = numel(V{2}(isnan(V{2})));
nanCount = nanCount_1 + nanCount_2;
disp(['����313�޳�������Χ������', num2str(nanCount_2),'��', ',���޳�',num2str(nanCount),'��'])
V{2}(:,300)=tmp;

disp('�۲����ݣ����ֱ���300���޳�Ϊ��ֵ��������:')
disp(['    285��/313������ֵ,' '                  325���������ֵ'])
disp([vpa(max(tmp)) vpa(TmpData.data(326,316))])

nanCount=nanCount-80;
disp(['�ָ�����300������,ʵ�ʹ��޳�',num2str(nanCount),'��'])

%% ��������(1)����ȱ���ݴ���
%�����λ��2Сʱ������40��������ȱʧ10�����ݣ�����Ϊ��ȱ���ݽ϶࣬����λ��ɾ��
for j=1:size(V{1},2)
    logical_1=isnan(V{1}(:,j));
    if sum(logical_1)>=10
        V{1}(:,j)=nan;
    end
end
nanCount_3 = numel(V{1}(isnan(V{1})))+40-nanCount_1;
nanCount = nanCount + nanCount_3;
disp(' ')
disp('��������(1):')
disp(['����285�޳���ȱ����',num2str(nanCount_3),'��', ',���޳�',num2str(nanCount),'��'])

for j=1:size(V{2},2)
    logical_1=isnan(V{2}(:,j));
    if sum(logical_1)>=10
        V{2}(:,j)=nan;
    end
end
nanCount_4 = numel(V{2}(isnan(V{2})))+40-nanCount_2;
nanCount = nanCount + nanCount_4;
disp(['����313�޳���ȱ����',num2str(nanCount_4),'��', ',���޳�',num2str(nanCount),'��'])

%% ��������(5)��3��׼��
%��ӷǲ�������
Sample_Data=[TmpData.data(2:end, 3:11) TmpData.data(2:end, 13:16) Sample_Data];
% [Sample_Data(:,1:13)] = three_sigma(Sample_Data(:,1:13));
nanCount_5 = numel(Sample_Data(isnan(Sample_Data)));
nanCount = nanCount + nanCount_5;
disp(' ')
disp('��������(5):')
disp(['�ǲ��������޳��ִ��������', num2str(nanCount_5),'��', ',���޳�',num2str(nanCount),'��'])

%% 285/313����ƽ��
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

%����ƥ��
mean_285 = mean_285(I3);
mean_285 = mean_285(I2);
mean_313 = mean_313(I3);
mean_313 = mean_313(I2);

mean_285 = [raw(1,:) pp(1,:) sa(1,:) ra(1,:) mean_285]; %��ӷǲ�������
mean_313 = [raw(2,:) pp(2,:) sa(2,:) ra(2,:) mean_313]; %��ӷǲ�������

Sample_Data(285,:) = mean_285; %�����滻
Sample_Data(313,:) = mean_313;

%% ��������(2)��ɾ������ȫ��Ϊ��ֵ��λ��
%��Ч�㼰λ��ȫ���������ݻ����������Ϊ�ǿ�ֵ
%λ��������������֮��С��ÿ�����������ֵ����Ϊ�����������

logical_1 = (max(Sample_Data)-min(Sample_Data))>=[ones(13,1); abs(VarDelta)]';
logical_2 = ~all(isnan(Sample_Data),1);
logical_2 = logical_1 & logical_2;
Sample_Data = Sample_Data(:,logical_2);
disp(' ')
disp('��������(2):')
disp(['�޳�ȫ��Ϊ��ֵ��λ��', num2str(sum(~logical_2)),'��'])
DelNum = VarNum(~logical_2);
if ~isempty(DelNum) %��������ڿ�ֵ��λ����
    disp(['ɾ����λ����Ϊ ', num2str(DelNum)])
end

VarNum=VarNum(logical_2);
Sample_Name=Sample_Name(logical_2);
%% ��������(3):������ֿ�ֵ��
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
disp('��������(3):')
disp(['�����ֵ��', num2str(k),'��'])

logical_2 = all(~isnan(Sample_Data),1);
Sample_Data = Sample_Data(:,logical_2); %ɾ����Чλ��
DelNum = VarNum(~logical_2);
disp(' ')
if ~isempty(DelNum) %��������ڿ�ֵ��λ����
    disp(['ɾ����λ����Ϊ ', num2str(DelNum)])
end
disp(['����󣬻���', num2str(sum(~logical_2(14:end))),'�д��ڿ�ֵ��λ��'])
disp(['����', num2str(sum(logical_2)),'��'])
% DelVar = Sample_Name(~logical_2); %ɾ��������
% disp(['λ��Ϊ ', DelVar])
VarNum=VarNum(logical_2);
Sample_Name=Sample_Name(logical_2);

%%
save('Sample_Data.mat','Sample_Data');  
save('VarNum.mat','VarNum');  
save('Sample_Name.mat','Sample_Name');  
