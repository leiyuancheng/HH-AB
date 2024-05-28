function [q,k]=BanditBasedLearning(r,r_average,bestIndex,k,LLH)
    
    r_average(bestIndex)=(k(bestIndex)*r_average(bestIndex)+r(bestIndex))/(k(bestIndex)+1);
    k(bestIndex)=k(bestIndex)+1;

    for i=1:LLH
        q(i)=cUCB(r_average(i),k,i);
    end
end
