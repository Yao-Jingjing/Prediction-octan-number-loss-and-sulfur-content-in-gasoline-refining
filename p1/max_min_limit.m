% ȷ��������Χ
function [V_new] = max_min_limit(VarValue, SampleData)      
    for i = 1: size(VarValue,1)   
        for j = 1 : size(VarValue,2)                  
            if VarValue(i,j)< min(SampleData(:,j))
                VarValue(i,j) = nan; %�޳�
            end         
            if VarValue(i,j) > max(SampleData(:,j))
                VarValue(i,j) = nan; %�޳�
            end        
        end 
    end
    V_new = VarValue;
end
