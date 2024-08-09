%将删除列还原的示例（为矩阵插入任意列）
clear;clc;
x=1:8;
fixnums=[1,3,7];
x(:,fixnums)=[];
x
y=1:8;
for i = 1:length(fixnums)
    fixcol = y(1,fixnums(i));
    x = [x(:,1:fixnums(i)-1),fixcol,x(:,fixnums(i):end)];
end
x