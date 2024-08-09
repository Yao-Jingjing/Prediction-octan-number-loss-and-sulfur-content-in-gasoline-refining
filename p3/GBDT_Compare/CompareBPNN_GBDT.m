clear;clc;close all;
BPNN_y_new=xlsread('BPNN_y_new.xlsx');
GBDT_y_new=xlsread('GBDT_y_new.xlsx');
GBDT_y_new=GBDT_y_new(2:end,2);
eval = cal_eval(BPNN_y_new,GBDT_y_new);
mse = eval(1);
rmse = eval(2);
mae = eval(3);
mape = eval(4);
r2 = eval(5);
figure(1);
plot(1:length(BPNN_y_new),BPNN_y_new,'r-*',1:length(GBDT_y_new),GBDT_y_new,'b:o');
grid on;
legend('BPNN Value','GBDT Value');
xlabel('Sample Number');
ylabel('Sample Output Value');
figure(2);
scatter(BPNN_y_new,GBDT_y_new)
axis([85,90,85,90])
xlabel('BPNN Output');
ylabel('GBDT Output');