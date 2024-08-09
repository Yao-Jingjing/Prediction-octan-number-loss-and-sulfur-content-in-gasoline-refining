function [predict_all,r2_test,net] = BPNN(Train_input,train_output,Test_input,test_datSet_output,PS_output,paramvec)
%laynum,TF1, TF2,BTF ,PF
TF1 = TFDecode(paramvec(2));
BTF = BTFDecode(paramvec(3));
PF = PFDecode(paramvec(4));

%% IV.建立神经网络
%建立神经网络
net = newff(Train_input,train_output,paramvec(1),{TF1},BTF,'learngdm',PF);
net.trainParam.epochs = 500;       %迭代次数
net.trainParam.goal = 1e-4;         %训练目标最小误差
net.trainParam.lr = 0.05;          %学习速率
net.divideFcn = '';
net = train(net,Train_input,train_output);

%% V. 仿真测试
%%
% 1. 输出结果
NN_test_outputsNorm = net(Test_input);
NN_all_outputsNorm = net([Train_input,Test_input]);
%%
% 2. 反归一化
predict_test = mapminmax('reverse',NN_test_outputsNorm,PS_output);
predict_all = mapminmax('reverse',NN_all_outputsNorm,PS_output);
%%
% 3. 计算评价函数
eval_test = cal_eval(test_datSet_output.',predict_test.');
r2_test = -eval_test(5);

end

function TF = TFDecode(value)
    switch(value)
        case 1 
            TF = 'purelin';
        case 2 
            TF = 'tansig';
        case 3 
            TF = 'logsig';
        otherwise
            TF = {};
    end
end
function BTF = BTFDecode(value)
    switch(value)
        case 1 
            BTF = 'trainlm';
        case 2 
            BTF = 'trainbr';
        case 3 
            BTF = 'trainrp';
        case 4 
            BTF = 'traincgf';
        case 5 
            BTF = 'traincgp';
        case 6 
            BTF = 'trainoss';
        otherwise
            BTF = {};
    end
end

function PF = PFDecode(value)
    switch(value)
        case 1 
            PF = 'mse';
        case 2 
            PF = 'sse';
        case 3 
            PF = 'sae';
        case 4 
            PF = 'mae';
        case 5 
            PF = 'crossentropy';
        otherwise
            PF = {};
    end
end