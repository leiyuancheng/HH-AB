function P=solution_select(Pt_new,Pt)
    
    hv_new=HV(Pt_new.PF,Pt_new.optimum);
    rc_new=rca(Pt_new.PF);

   
    hv=HV(Pt.PF,Pt.optimum);
    rc=rca(Pt.PF);

    
    %normalization
    hv=hv/max(hv,hv_new);
    hv_new=hv_new/max(hv,hv_new);

    rc=rc/max(rc,rc_new);
    rc_new=rc_new/max(rc,rc_new);

    q=hv+rc;
    q_new=hv_new+rc_new;


    if q<q_new
        P=Pt_new;
    else
        P=Pt;
    end

end
