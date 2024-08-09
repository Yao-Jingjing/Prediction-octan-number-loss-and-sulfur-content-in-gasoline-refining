% This function initialize the first population of search agents
function Positions=initialization(SearchAgents_no,dim,ub,lb,dirt)
%  SearchAgents_no 40
%  dim 10
%  ub  1*10 100
%  lb  1*10 100
Boundary_no= size(ub,2); % 运动范围的数量

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    ub_new=ones(1,dim)*ub;
    lb_new=ones(1,dim)*lb;
else
     ub_new=ub;
     lb_new=lb;   
end
%OptimizeFactor(1,3:45)
VecInSp1=1.0e+07 *[0.0002    0.0000    0.0000    0.0000    0.0000    0.0000    0.8380    0.0010    0.0005    0.0000    0.0939    0.1410...
    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000    0.0003   -0.0000    0.0000...
    0.0000    0.0006    3.9609    0.0000   -0.0000    0.0007    0.0000    0.0000    0.1174    0.2434    0.0335    0.0000...
    1.2266    0.0000    0.0000    0.0000    0.0000    0.0000    0.0833];

%Intnum=floor((ub-lb)./dirt);%zfy
% If each variable has a different lb and ub
    for i=1:dim
        ub_i=ub_new(i);
        lb_i=lb_new(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end

Positions=Positions';%after this, dim*SearchAgents_no
