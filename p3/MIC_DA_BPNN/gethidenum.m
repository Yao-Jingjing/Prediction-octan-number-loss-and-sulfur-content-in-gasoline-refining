function hidenum = gethidenum(n,m,samples,type) 
    switch type
        case 1 %经验公式
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
function hidenum = gethidenum1(n,m,samples) %经验公式1
    n1 = round(sqrt(n+m)+1:10);%隐层节点个数   
    hidenum = [];
    for i = n1
        Sum = 0;
        for j = 1:i
            Sum = Sum + nchoosek(i,j);
        end
        if Sum > samples %查看样本数是否满足小于Sum
            break;
        end
        hidenum = cat(2,hidenum,i);
    end
end

function hidenum = gethidenum2(n,m,samples) %fangfaGorman定理
    hidenum = log2(n);%隐层节点个数   
    hidenum = round(hidenum);
end

function hidenum = gethidenum3(n,m,samples) %Kolmogorov定理
    hidenum = 2*n+1;%隐层节点个数   
    hidenum = round(hidenum);
end

%https://www.csdn.net/gather_2e/MtjaIg4sNTIzNjYtYmxvZwO0O0OO0O0O.html
function hidenum = gethidenum4(n,m,samples) %经验公式2
    hidenum = sqrt(0.43*n*m+0.12*m*m+2.54*n+0.77*m+0.35)+0.51 ;%隐层节点个数 
    hidenum = round(hidenum);
end
