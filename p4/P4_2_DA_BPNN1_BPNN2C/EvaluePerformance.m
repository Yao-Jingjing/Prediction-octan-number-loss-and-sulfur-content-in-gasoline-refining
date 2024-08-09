function [score,Product] = EvaluePerformance(controvec, samp_i, fixnums) 
    %load OptimizeFactor.mat %��37��, �������в��ɿ�
    %�Ե�һ������Ϊ��
    global BestNetS
    global BestNetXW
    global PS_input
    global PS_output_XW
    global OptimizeFactor;
    %controvecΪ������
    for i = 1:length(fixnums)%����̶��У���ԭΪ��������
        fixcol = OptimizeFactor(samp_i,fixnums(i));%Ϊһ��ֵ
        controvec = [controvec(1:fixnums(i)-1,1); fixcol; controvec(fixnums(i):end,1)];
    end
    input = mapminmax('apply',controvec,PS_input);%controvecΪ��������ÿ��Ϊһ����������1��1������
    PredicXW = mapminmax('reverse',BestNetXW(input),PS_output_XW);
    [~,PredicS] = max(BestNetS(input));
    if PredicS == 2
        score = inf; %���ᱻѡ��
    else
        score = OptimizeFactor(samp_i,end)-PredicXW; %��Ʒ����ֵ��ʧ��ԽСԽ��
    end
    Product=[PredicS*3+0.2,PredicXW];   
end