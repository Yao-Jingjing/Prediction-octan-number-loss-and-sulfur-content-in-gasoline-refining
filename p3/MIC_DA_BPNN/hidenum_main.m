n = 30;%输入
m=1;%输出
samples = 325; %样本数

hidenum1 = gethidenum(n,m,samples,1)%得到[7,8]
hidenum2 = gethidenum(n,m,samples,2)%得到5
hidenum3 = gethidenum(n,m,samples,3)%得到61
hidenum4 = gethidenum(n,m,samples,4)%得到10

%训练样本数必须多于网络模型的连接权数，一般为2~10倍训练样本数必须多于网络模型的连接权数，一般为2~10倍
% 连接数30*hidenum+hidenum应小于325，故hidenum<10.48

%之后再采用蜻蜓优化，实测出隐层个数、非线性函数类型等最优参数
main();