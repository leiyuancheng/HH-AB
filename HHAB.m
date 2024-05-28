close all
clear
clc
 cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));

H={
    @SPEA2SDE;
    @MOEADD;
    @hpaEA;
};

%%
LLH=3;%number of LLH
t=1;
tmax=5;

q=rand(LLH,1);%quality
k=zeros(LLH,1);

r=zeros(LLH,1);%reward

I=zeros(LLH,2);%hva and rca


%%
for i=1:LLH
    %problem=WFG3('M',3,'D',10);
    %problem=WFG4('M',8);
    problem=WFG5('M',3);
    %u can solve other problems, provided you import it in Probelms

    ha=H{i}();
  
    PN{i} =platemo(ha,problem);
      
    I(i,1)=HV(PN{i}.PF,PN{i}.optimum);
    I(i,2)=rca(PN{i}.PF);
    
end

r=RewardBalanceStrategy(I,t,tmax);
r_average=r;

for i=1:LLH

  k(i)=1;
    q(i)=r(i);

end
[maxValue, bestIndex] = max(q); %bestIndex
Pt=PN{bestIndex};


%% 
for t=1:tmax
    %ha = MultistageSelection(Q)
    [maxValue, bestIndex] = max(q);  

    [maxValue, bestIndex] = max(q); 

    ha = H{bestIndex}();

    
    %Pt_new = ApplyLLH (ha, Pt);
    Pt_new=platemo(ha,Pt);
    
    %Ia = CalculateIndicatorValues (Pt_new);
    I(bestIndex,1)=HV(Pt_new.PF,Pt_new.optimum);%hva
    I(bestIndex,2)=rca(Pt_new.PF);%rca

    %r = RewardBalanceStrategy(I);
    r=RewardBalanceStrategy(I,t,tmax);
    r_average=(r_average*(t-1)+r)/t;
    
    %Q = BanditBasedLearning(ha, r);
    [q,k]=BanditBasedLearning(r,r_average,bestIndex,k,LLH);%update quality
    
    %Pt_new = SolutionSetAcceptance(Pt_new, Pt);
    Pt=solution_select(Pt_new,Pt);

    %Multistage Selection Strategy
    if t>=tmax/2
        [minValue, worstIndex] = min(k);
        q(worstIndex)=0;
    end

%Count the survey times of the three algorithms
    ki(t,1)=k(1);
    ki(t,2)=k(2);
    ki(t,3)=k(3);
end

figure
for t=1:tmax
    plot(t,ki(t,1),'.',t,ki(t,2),'o',t,ki(t,3),'*')
    hold on
end

%If 3 object, then you can output PF using this
%{
x=Pt.PF(:,1);
y=Pt.PF(:,2);
z=Pt.PF(:,3);
plot3(x,y,z,'o')
%}

