function [predict_all,corrpercent,net] = BPNN(Train_input,training_datSet_output,Test_input,test_datSet_output,paramvec)
train_output = [training_datSet_output<=5;training_datSet_output>5];
Test_output = [test_datSet_output<=5;test_datSet_output>5];

%% IV.����������
%����������
net = newff( Train_input, train_output,paramvec(1), { 'logsig' 'purelin' } , 'traingdx');
net.trainParam.epochs = 500;       %��������
net.trainParam.goal = 1e-4;         %ѵ��Ŀ����С���
net.trainParam.lr = 0.5;          %ѧϰ����
net.divideFcn = '';
net = train(net,Train_input,train_output);

%% V. �������
%%
% 1. ������
%Train_output_net = net(Train_input);
Test_output_net = net(Test_input);
predict_all = net([Train_input,Test_input]);
%%
% 3. �������ۺ���
%ͳ��ʶ����ȷ��
[~,Test_class]=max(Test_output);
[~ , s2] = size( Test_output_net) ;%s1��ά��,s2��������
hitNum = 0 ;
for i = 1 : s2
    [~ , Index] = max( Test_output_net( : ,  i ) ) ;
    if( Index  == Test_class(i)   ) 
        hitNum = hitNum + 1 ; 
    end
end
corrpercent = -hitNum / s2; 
end