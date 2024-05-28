function rca=rca(P)

    refpoint=max(P);%reference point --max
    
    %Manhattan distance
    n = size(P, 1);  
    
    rca= 0;  
      
    for i = 1:n 
        current_solution = P(i, :);  
          
        manhattan_distance=sum(abs(current_solution-refpoint));  
          
        rca=rca+ manhattan_distance;  
    end  
    
end
