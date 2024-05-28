function qi=cUCB(ri,k,i)
    C=0.5;
    qi=ri+sqrt(C*log(sum(k))/k(i));
end
