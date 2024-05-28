%已测，正确
%测试前输入
%i=10
%k=rand(1,150)
%ri=13

%   输出qi
%   输入ri的平均值、全部的k、当前迭代次数i

function qi=cUCB(ri,k,i)
    C=0.5;
    qi=ri+sqrt(C*log(sum(k))/k(i));

end