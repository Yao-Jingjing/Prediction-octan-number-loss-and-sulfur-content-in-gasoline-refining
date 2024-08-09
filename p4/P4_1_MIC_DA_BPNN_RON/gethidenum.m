function hidenum = gethidenum(n,m,samples,type) 
    switch type
        case 1 %���鹫ʽ
            hidenum = gethidenum1(n,m,samples);
        case 2
            hidenum = gethidenum2(n,m,samples);
        case 3
            hidenum = gethidenum3(n,m,samples);
        case 4
            hidenum = gethidenum4(n,m,samples);
    end
end

%https://wenku.baidu.com/view/fd6acbcf5ef7ba0d4b733b1c.html
function hidenum = gethidenum1(n,m,samples) %���鹫ʽ1
    n1 = round(sqrt(n+m)+1:10);%����ڵ����   
    hidenum = [];
    for i = n1
        Sum = 0;
        for j = 1:i
            Sum = Sum + nchoosek(i,j);
        end
        if Sum > samples %�鿴�������Ƿ�����С��Sum
            break;
        end
        hidenum = cat(2,hidenum,i);
    end
end

function hidenum = gethidenum2(n,m,samples) %fangfaGorman����
    hidenum = log2(n);%����ڵ����   
    hidenum = round(hidenum);
end

function hidenum = gethidenum3(n,m,samples) %Kolmogorov����
    hidenum = 2*n+1;%����ڵ����   
    hidenum = round(hidenum);
end

%https://www.csdn.net/gather_2e/MtjaIg4sNTIzNjYtYmxvZwO0O0OO0O0O.html
function hidenum = gethidenum4(n,m,samples) %���鹫ʽ2
    hidenum = sqrt(0.43*n*m+0.12*m*m+2.54*n+0.77*m+0.35)+0.51 ;%����ڵ���� 
    hidenum = round(hidenum);
end
