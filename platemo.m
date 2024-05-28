function Problem = platemo(Algorithm,Problem)

    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
  
    Algorithm.Solve(Problem);
   
    P = Algorithm.result{end};
    Problem.PF = P.objs;
    
end
