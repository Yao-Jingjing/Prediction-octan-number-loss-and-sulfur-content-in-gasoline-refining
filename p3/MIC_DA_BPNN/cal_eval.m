function [eval_train] = cal_eval(YReal, YPred)
eval_train = zeros(5,1);
eval_train(1) = mean((YReal-YPred).^2); %mse
eval_train(2) = sqrt(eval_train(1));       %rmse
eval_train(3) = mean(abs(YReal - YPred));  %mae
eval_train(4) = mean(abs((YReal - YPred)./YReal))*100; %MAPE 平均百分比误差
eval_train(5) = 1 - (sum((YPred - YReal).^2) / sum((YReal - mean(YReal)).^2)); %r2
end