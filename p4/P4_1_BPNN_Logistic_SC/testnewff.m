clear;close all;
% clc;

%% II. ���ݼ�Ԥ����
%%
%1. ����ѵ�����Ͳ��Լ�����
load OptimizeFactor.mat %��47�У�ǰ������ԭ������ֵ�ͱ��������м�43������Ҫ�ٿر�������������ǲ�Ʒ��Ͳ�Ʒ����ֵ
OptimizeFactor([142,191,287,301,307,325],:)=[];
datSet=OptimizeFactor;%ǰ����ԭ�Ϻ͵�����3���䲻�ɿأ�����ȻΪ��ģ��Ҫ����
% 
%2. ����ѵ�����Ͳ��Լ�
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1��ndata��Щ��������ҵõ���һ���������������Ϊ����
test_dataNumber = int32(0.2*ndata);  %ѡȡ���ݼ��İٷ�֮��ʮ��Ϊ���Լ���
test_datSet = datSet(random_index(1:test_dataNumber),:);  %��������ǰtest_datSet�����ݵ���Ϊ��������Xtest
random_index = random_index(test_dataNumber+1:ndata);
training_datSet = datSet(random_index,:);          %ʣ�µ�������Ϊѵ������training_datSet
training_dataNumber = size(training_datSet,1);      %training_dataNumber��ѵ��������

% %�����
% test_datSet=OptimizeFactor;
% training_datSet=OptimizeFactor;

% 3. ������ݼ���������
training_datSet_input = training_datSet(:,1:end-2)';
training_datSet_output = training_datSet(:,end-1)'; %ѡȡ��ƷSֵ��Ϊ������
Train_output_real = [training_datSet_output<=5;training_datSet_output>5];%%�����������
[~,Train_class_real] = max(Train_output_real);
test_datSet_input = test_datSet(:,1:end-2)';
test_datSet_output = test_datSet(:,end-1)'; %ѡȡѡȡ��ƷSֵ��Ϊ��������Ϊ������
Test_output_real = [test_datSet_output<=5;test_datSet_output>5];%%�����������
[~,Test_class_real] = max(Test_output_real);

%����ֵ��һ��
[Train_input,PS_input] = mapminmax(training_datSet_input);
Test_input = mapminmax('apply',test_datSet_input,PS_input);

% %����������
% net = newff( Train_input, Train_output_real,15, { 'logsig' 'purelin' } , 'traingdx');%Train_input��Train_output����������ά��
% %����ѵ������
% net.trainparam.show = 50 ;
% net.trainparam.epochs = 500 ;
% net.trainparam.goal = 0.01 ;
% net.trainParam.lr = 0.01 ;

% %��������������
load BestNetS.mat
net = BestNetS;

%����
Train_output_predict = net(Train_input);
Test_output_predict = net(Test_input);

%ͳ��ѵ����ʶ����ȷ��
[~, ns2] = size( Train_output_predict ) ;%s1��ά��,s2��������
nhitNum = 0 ; Train_class_predict=zeros(size(Train_class_real));
for i = 1 : ns2
    [~ , nIndex] = max( Train_output_predict( : ,  i ) ) ;
    Train_class_predict(i)=nIndex;
    if( nIndex  == Train_class_real(i)   ) 
        nhitNum = nhitNum + 1 ; 
    end
end
sprintf('ѵ��ʶ������ %3.3f%%',100 * nhitNum / ns2 )

logical_1=logical(Train_class_predict==1);
logical_2=logical(Train_class_predict==2);
x0=1:ns2;
figure(2);
hold on;
scatter(x0(logical_1),training_datSet_output(logical_1));
scatter(x0(logical_2),training_datSet_output(logical_2),'filled');

%ͳ�Ʋ��Լ�ʶ����ȷ��
[~, s2] = size( Test_output_predict ) ;%s1��ά��,s2��������
hitNum = 0 ; Test_class_predict=zeros(size(Test_class_real));
for i = 1 : s2
    [~ , Index] = max( Test_output_predict( : ,  i ) ) ;
    Test_class_predict(i)=Index;
    if( Index  == Test_class_real(i)   ) 
        hitNum = hitNum + 1 ; 
    end
end
sprintf('����ʶ������ %3.3f%%',100 * hitNum / s2 )

logical_1=logical(Test_class_predict==1);
logical_2=logical(Test_class_predict==2);
x0=1:ns2;
figure(3);
hold on;
scatter(x0(logical_1),test_datSet_output(logical_1));
scatter(x0(logical_2),test_datSet_output(logical_2),'filled');

