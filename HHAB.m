close all
clear
clc
 cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
%%
%要解决的问题

H={
    @SPEA2SDE;
    @MOEADD;
    @hpaEA;
};


%%


LLH=3;%LLH的数量
t=1;
tmax=5;%最大迭代次数

q=rand(LLH,1);%为每个LLH创建其质量
k=zeros(LLH,1);%初始调用次数全为0

r=zeros(LLH,1);%初始奖励值均为

I=zeros(LLH,2);%指标，包括hva--1,rca--2


%%
for i=1:LLH%每个启发式对解集都进行一次初始运算，分别得到自己的解集
    %problem=WFG3('M',3,'D',10);%问题的参数在这里给
    %problem=WFG4('M',8);
    problem=WFG5('M',3);


    %这里利用了platemo每次初始化问题都是一个模型（完全相同），不然我的plaemo函数导致的problem发生改变就有点难办

    ha=H{i}();
  
    PN{i} =platemo(ha,problem);
      
    I(i,1)=HV(PN{i}.PF,PN{i}.optimum);
    I(i,2)=rca(PN{i}.PF);%rca函数另外定义
    
end

r=RewardBalanceStrategy(I,t,tmax);%同下面更新r的函数
r_average=r;%初始的r的平均值

for i=1:LLH

  k(i)=1;%初始调用次数设置为1
    q(i)=r(i);%初始质量为ri,因为log里面为0嘛，其实相当于这里调用一次cUCB函数

end
[maxValue, bestIndex] = max(q); %最优索引
Pt=PN{bestIndex};%后面就是用Pt了


%% 

for t=1:tmax
    %找到质量最大的LLH的索引      ha = MultistageSelection(Q)
   [maxValue, bestIndex] = max(q);  

  %尝试改变一下
    %   [maxValue, bestIndex] = min(q); 

    ha = H{bestIndex}();

    
    %用得到的ha更新Pt     Pt_new = ApplyLLH (ha, Pt);
   
    Pt_new=platemo(ha,Pt);
    
  
    %更新ha对应的指标，根据hva和rca来       Ia = CalculateIndicatorValues (Pt_new);
    I(bestIndex,1)=HV(Pt_new.PF,Pt_new.optimum);%hva
    I(bestIndex,2)=rca(Pt_new.PF);%rca函数另外定义

    %根据I更新r     r = RewardBalanceStrategy(I);
    r=RewardBalanceStrategy(I,t,tmax);%奖励平衡函数另外定义,这是一个输入矩阵，输出矩阵的函数
    r_average=(r_average*(t-1)+r)/t;
    %质量更新       Q = BanditBasedLearning(ha, r);
    [q,k]=BanditBasedLearning(r,r_average,bestIndex,k,LLH);%根据奖励值更新此LLH对应的质量
    
    %决策选择       Pt_new = SolutionSetAcceptance(Pt_new, Pt);
    Pt=solution_select(Pt_new,Pt);
    
    

    %Multistage Selection Strategy
    if t>=tmax/2

        [minValue, worstIndex] = min(k);
        q(worstIndex)=0;
    
    end

    %k
   
    ki(t,1)=k(1);
    ki(t,2)=k(2);
    ki(t,3)=k(3);
end


figure
for t=1:tmax
    plot(t,ki(t,1),'.',t,ki(t,2),'o',t,ki(t,3),'*')
    hold on
end


%{
x=Pt.PF(:,1);
y=Pt.PF(:,2);
z=Pt.PF(:,3);
plot3(x,y,z,'o')
%}

