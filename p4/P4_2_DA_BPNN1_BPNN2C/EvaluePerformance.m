function [score,Product] = EvaluePerformance(controvec, samp_i, fixnums) 
    %load OptimizeFactor.mat %共37列, 其中两列不可控
    %以第一个样本为例
    global BestNetS
    global BestNetXW
    global PS_input
    global PS_output_XW
    global OptimizeFactor;
    %controvec为列向量
    for i = 1:length(fixnums)%插入固定列，还原为完整输入
        fixcol = OptimizeFactor(samp_i,fixnums(i));%为一个值
        controvec = [controvec(1:fixnums(i)-1,1); fixcol; controvec(fixnums(i):end,1)];
    end
    input = mapminmax('apply',controvec,PS_input);%controvec为列向量，每行为一个特征，共1列1个样本
    PredicXW = mapminmax('reverse',BestNetXW(input),PS_output_XW);
    [~,PredicS] = max(BestNetS(input));
    if PredicS == 2
        score = inf; %不会被选中
    else
        score = OptimizeFactor(samp_i,end)-PredicXW; %产品辛烷值损失，越小越好
    end
    Product=[PredicS*3+0.2,PredicXW];   
end