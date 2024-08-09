function [Best_score,Best_pos,cg_curve,BestNet]=DA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,Train_input,train_output,Test_input,test_datSet_output,PS_output)
%All_output= zeros(1,size(Train_input,2)+size(Test_input,2));%����BPNN��õ���ȫ�����
predict_allIters = cell(Max_iteration,1);
predict_allOneIter = cell(Max_iteration,SearchAgents_no);

display('DA is optimizing your problem');
cg_curve=zeros(1,Max_iteration);

if size(ub,2)==1
    ub=ones(1,dim)*ub;
    lb=ones(1,dim)*lb;
end

%��ʼ����������뾶
Delta_max=(ub-lb)/10;% 1*10 20

Food_fitness=inf;%������
Food_pos=zeros(dim,1);%10*1 

Enemy_fitness=-inf;%������
Enemy_pos=zeros(dim,1);%10*1 
%���������SearchAgents_no����
X=initialization(SearchAgents_no,dim,ub,lb);%10*40
X = round(X); %zfy ֻ��ȡ��
Fitness=zeros(1,SearchAgents_no); 

DeltaX=initialization(SearchAgents_no,dim,ub,lb);%10*40 


for iter=1:Max_iteration
    iter%��ʾ��ǰѭ����
    
    r=(ub-lb)/4+((ub-lb)*(iter/Max_iteration)*2);%��������Խ�󡣰뾶Խ���ʼ1*10 50.8
    
    w=0.9-iter*((0.9-0.4)/Max_iteration);%���ϼ�С1*1  0.899
       
    my_c=0.1-iter*((5-0)/(Max_iteration/2));% ���ϼ�С 1*1 0.0996��zfy��(0.1-0)��Ϊ5-0
    if my_c<0
        my_c=0;
    end
    s=2*randperm(5,1)*my_c; % ����� 0.0013
    a=2*randperm(5,1)*my_c; %  ����� 0.1884
    c=2*randperm(5,1)*my_c; %�ھ۶� 0.1791
    f=2*randperm(5,1);      % ʳ�������� 0.8826
    e=10*my_c;        %���ų��� 0.0996
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�ҵ�ʳ������
    for i=1:SearchAgents_no %���ȼ�������Ŀ��ֵ
        [predict_all,Fitness(1,i),tmpNet]=fobj(Train_input,train_output,Test_input,test_datSet_output,PS_output,X(:,i));
        predict_allOneIter{iter,i} = predict_all;        
        if Fitness(1,i)<Food_fitness %Ѱ��ÿ�ε�������Сֵ
            Food_fitness=Fitness(1,i);%1.2728*10^4
            Food_predict_all=predict_all;
            BestNet = tmpNet;
            Food_pos=X(:,i);
        end
        
        if Fitness(1,i)>Enemy_fitness %Ѱ��ÿ�ε��������ֵ
            if all(X(:,i)<ub') && all( X(:,i)>lb') 
                Enemy_fitness=Fitness(1,i);%5.6813*10^4
                Enemy_pos=X(:,i);
            end
        end
    end
    predict_allIters{iter} = Food_predict_all;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�ҵ�ÿֻ���ѵ��ھ�
    for i=1:SearchAgents_no
        index=0;
        neighbours_no=0;
        
        clear Neighbours_DeltaX
        clear Neighbours_X
        %�ҵ������ھ�
        for j=1:SearchAgents_no
            Dist2Enemy=distance(X(:,i),X(:,j));%����ŷ�Ͼ���
            if (all(Dist2Enemy<=r) && all(Dist2Enemy~=0))
                index=index+1;%�ھ����
                neighbours_no=neighbours_no+1;%�ھ�����
                Neighbours_DeltaX(:,index)=DeltaX(:,j);
                Neighbours_X(:,index)=X(:,j);
            end
        end
        
        % ���� - ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.1)
        S=zeros(dim,1);
        if neighbours_no>1
            for k=1:neighbours_no
                S=S+(Neighbours_X(:,k)-X(:,i));
            end
            S=-S;
        else
            S=zeros(dim,1);
        end
        
        % ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.2)
        if neighbours_no>1
            A=(sum(Neighbours_DeltaX')')/neighbours_no;
        else
            A=DeltaX(:,i);
        end
        
        % �ھ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.3)
        if neighbours_no>1
            C_temp=(sum(Neighbours_X')')/neighbours_no;
        else
            C_temp=X(:,i);
        end
        
        C=C_temp-X(:,i);
        
        % ����ʳ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.4)
        Dist2Food=distance(X(:,i),Food_pos(:,1));
        if all(Dist2Food<=r)
            F=Food_pos-X(:,i);
        else
            F=0;
        end
        
        % Զ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Eq. (3.5)
        Dist2Enemy=distance(X(:,i),Enemy_pos(:,1));
        if all(Dist2Enemy<=r)
            Enemy=Enemy_pos+X(:,i);
        else
            Enemy=zeros(dim,1);
        end
        
        for tt=1:dim
            if X(tt,i)>ub(tt)%��������
                X(tt,i)=lb(tt);
                DeltaX(tt,i)=rand;
            end
            if X(tt,i)<lb(tt)
                X(tt,i)=ub(tt);
                DeltaX(tt,i)=rand;
            end
        end
        
        if any(Dist2Food>r) %���ʳ��λ�ò�����������λ��
            %%���и�������� i ����ʱ
            if neighbours_no>1
                for j=1:dim
                    DeltaX(j,i)=w*DeltaX(j,i)+rand*A(j,1)+rand*C(j,1)+rand*S(j,1);
                    if DeltaX(j,i)>Delta_max(j)
                        DeltaX(j,i)=Delta_max(j);
                    end
                    if DeltaX(j,i)<-Delta_max(j)
                        DeltaX(j,i)=-Delta_max(j);
                    end
                    X(j,i)=X(j,i)+DeltaX(j,i);
                end
            else
                % Eq. (3.8)
                %��û���κθ�������� i ����ʱ
                X(:,i)=X(:,i)+Levy(dim)'.*X(:,i);
                DeltaX(:,i)=0;
            end
        else
            for j=1:dim
                % Eq. (3.6)
                DeltaX(j,i)=(a*A(j,1)+c*C(j,1)+s*S(j,1)+f*F(j,1)+e*Enemy(j,1)) + w*DeltaX(j,i);
                if DeltaX(j,i)>Delta_max(j)
                    DeltaX(j,i)=Delta_max(j);
                end
                if DeltaX(j,i)<-Delta_max(j)
                    DeltaX(j,i)=-Delta_max(j);
                end
                X(j,i)=X(j,i)+DeltaX(j,i);
            end 
        end
        
        Flag4ub=X(:,i)>ub';
        Flag4lb=X(:,i)<lb';
        %��Χ����������ȡ����
        %��ΧС��������ȡ���ޣ�
        %���򲻱�
        X(:,i)=(X(:,i).*(~(Flag4ub+Flag4lb)))+ub'.*Flag4ub+lb'.*Flag4lb; 
        X = round(X);%zfy��XΪ����
    end
    
    Best_score=Food_fitness
    Best_pos=Food_pos
    
    cg_curve(iter)=Best_score;   
end
save predict_allOneIter.mat predict_allOneIter
save predict_allIters.mat predict_allIters



