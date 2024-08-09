function [predict_all,corrpercent,net] = BPNN(Train_input,training_datSet_output,Test_input,test_datSet_output,paramvec)
train_output = [training_datSet_output<=5;training_datSet_output>5];
Test_output = [test_datSet_output<=5;test_datSet_output>5];

%% IV.建立神经网络
%建立神经网络
net = newff( Train_input, train_output,paramvec(1), { 'logsig' 'purelin' } , 'traingdx');
net.trainParam.epochs = 500;       %迭代次数
net.trainParam.goal = 1e-4;         %训练目标最小误差
net.trainParam.lr = 0.5;          %学习速率
net.divideFcn = '';
net = train(net,Train_input,train_output);

%% V. 仿真测试
%%
% 1. 输出结果
%Train_output_net = net(Train_input);
Test_output_net = net(Test_input);
predict_all = net([Train_input,Test_input]);
%%
% 3. 计算评价函数
%统计识别正确率
[~,Test_class]=max(Test_output);
[~ , s2] = size( Test_output_net) ;%s1是维度,s2是样本数
hitNum = 0 ;
for i = 1 : s2
    [~ , Index] = max( Test_output_net( : ,  i ) ) ;
    if( Index  == Test_class(i)   ) 
        hitNum = hitNum + 1 ; 
    end
end
corrpercent = -hitNum / s2; 
end