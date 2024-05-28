function rca=rca(P)
    
    %参考点,同hva
    refpoint=max(P);%文章也没说参考点是啥，暂时取max
    
    %曼哈顿距离
    n = size(P, 1);  
      
    % 初始化RC为0  
    rca= 0;  
      
    % 遍历P中的每个解（每一行）  
    for i = 1:n 
        current_solution = P(i, :);  
          
        % 计算当前解到参考点的曼哈顿距离  
        manhattan_distance=sum(abs(current_solution-refpoint));  
          
        % 将当前解的曼哈顿距离累加到RC中  
        rca=rca+ manhattan_distance;  
    end  
    
end