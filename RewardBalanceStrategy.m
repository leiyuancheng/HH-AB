function r=RewardBalanceStrategy(I,t,tmax)
    
    theta=0.75;%0~1
    
    nor_hva=(I(:,1)-max(I(:,1)))/max(I(:,1));
    nor_rca=(I(:,2)-max(I(:,2)))/max(I(:,2));
    
    theta_s=1-theta;
    w_hv=theta_s+(t/tmax)*(theta-theta_s);
    w_rc=theta_s+(1-t/tmax)*(theta-theta_s);

    r=w_hv.*nor_hva+w_rc.*nor_rca;
end
