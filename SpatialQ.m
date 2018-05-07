function [QSource,PSource,pns3] = SpatialQ(P,Q,Bn,pns)
      

    Nn = length(Bn);
    
    PSource = zeros(Nn,3);
    QSource = zeros(Nn,1);
    pns2 = zeros(Nn,1);
    
    for i = 1:Nn
        if     Bn(i) == 2 
            QSource(i) = Q(i) ;                                       
        end
    end  
%      PSource = P(Bn==2,:);
     
    for i = 1:Nn
        if     Bn(i) == 2 
            PSource(i,:) = P(i,:) ;
            pns2(i) = pns(i); 
        end
    end 
    
    pns3 = pns2(pns2 ~= 0);
 
    