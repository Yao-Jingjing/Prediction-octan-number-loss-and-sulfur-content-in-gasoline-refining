clear;
% 1. ����ѵ�����Ͳ��Լ�����
load OptimizeFactor.mat %��47�У�ǰ������ԭ������ֵ�ͱ��������м�43������Ҫ�ٿر�����������3���޷��ģ���������ǲ�Ʒ��Ͳ�Ʒ����ֵ
OptimizeFactor([142,191,287,301,307,325],:)=[];
datSet=OptimizeFactor;%ǰ����ԭ�Ϻ͵�����3���䲻�ɿأ�����ȻΪ��ģ��Ҫ����

% 2. ����ѵ�����Ͳ��Լ�
[ndata, D] = size(datSet);
rng(0); 
random_index = randperm(ndata);         %1��ndata��Щ��������ҵõ���һ���������������Ϊ����
test_dataNumber = int32(0.2*ndata);  %ѡȡ���ݼ��İٷ�֮��ʮ��Ϊ���Լ���