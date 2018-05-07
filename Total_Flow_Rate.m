%% CALCUALTE TOTAL FLOW RATE

function [q0,Qt,Qtb,Qtf,Nall,qLP,qRP,qLM,qRM,qLA,qRA] = Total_Flow_Rate(Bn,cns,Q)

Nn = length(Q);

q_LPCA1 = ones(Nn,1);
q_RPCA1 = ones(Nn,1);
q_LMCA1 = ones(Nn,1);
q_RMCA1 = ones(Nn,1);
q_LACA1 = ones(Nn,1);
q_RACA1 = ones(Nn,1); 

    for i = 1:Nn
        if     Bn(i) == 2 && cns(i) == 5
            q_LPCA1(i) = Q(i);            
        elseif Bn(i) == 2 && cns(i) == 2
            q_RPCA1(i) = Q(i);            
        elseif Bn(i) == 2 && cns(i) == 4
            q_LMCA1(i) = Q(i);            
        elseif Bn(i) == 2 && cns(i) == 3
            q_RMCA1(i) = Q(i);            
        elseif Bn(i) == 2 && cns(i) == 7
            q_LACA1(i) = Q(i);            
        elseif Bn(i) == 2 && cns(i) == 6
            q_RACA1(i) = Q(i);                            
        end
    end    

        q_LPCA2 = q_LPCA1(q_LPCA1~=1);
        q_RPCA2 = q_RPCA1(q_RPCA1~=1);
        q_LMCA2 = q_LMCA1(q_LMCA1~=1);
        q_RMCA2 = q_RMCA1(q_RMCA1~=1);
        q_LACA2 = q_LACA1(q_LACA1~=1);
        q_RACA2 = q_RACA1(q_RACA1~=1);
  
        q_LPCA3 = abs(sum(q_LPCA2));
        q_RPCA3 = abs(sum(q_RPCA2));
        q_LMCA3 = abs(sum(q_LMCA2));
        q_RMCA3 = abs(sum(q_RMCA2));
        q_LACA3 = abs(sum(q_LACA2));
        q_RACA3 = abs(sum(q_RACA2));
        
    nPL = length(q_LPCA2);
    nPR = length(q_RPCA2);
    nML = length(q_LMCA2);
    nMR = length(q_RMCA2);
    nAL = length(q_LACA2);
    nAR = length(q_RACA2);
    
    qLP = -q_LPCA2./1000;
    qRP = -q_RPCA2./1000;
    qLM = -q_LMCA2./1000;
    qRM = -q_RMCA2./1000;
    qLA = -q_LACA2./1000;
    qRA = -q_RACA2./1000;
    
    Nall = [nPL,nPR,nML,nMR,nAL,nAR];
    
q0 = [q_LPCA3;q_RPCA3;q_LMCA3;q_RMCA3;q_LACA3;q_RACA3]./1000; % Total flow leaving each region

Qtb = q0           ;  % Total flow leaving each region (mL/s)             
Qt = sum(Qtb)      ;  % Total flow of all regions combined (mL/s)
Qtf = Qtb .* (1/Qt);  % Normalised flow leaving each region (dimensionless)

end


