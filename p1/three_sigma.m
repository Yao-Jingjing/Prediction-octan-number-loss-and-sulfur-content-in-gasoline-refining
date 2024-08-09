% È¥³ı´Ö´óÎó²îÖµ
function [V_new] = three_sigma(V)
    V_new = V;
    for j = 1: size(V,2)    
        a = V(:,j);
        notNanValues=a(~isnan(a));
        meanValue=sum(notNanValues)./length(notNanValues);    
        delta = notNanValues - meanValue;
        sigma = sqrt(sum(delta.^2)/(length(notNanValues)-1));
        for i = 1: size(V,1)
            if ~isnan(a(i))
                if abs(a(i)-meanValue) > 3*sigma                    
                    disp(num2str(3*sigma))                    
                    V_new(i,j) = nan;
                end
            end
        end    
    end    
end
        