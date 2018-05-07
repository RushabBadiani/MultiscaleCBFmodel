function [bb_sPL,bb_sPR,bb_sML,bb_sMR,bb_sAL,bb_sAR] = strokesimulation(bb,cns,CCn,factor)
 
% Pre-allocating size of bb matrices
Nn = length(cns);

bb1 = bb;
bb2 = bb;
bb3 = bb;
bb4 = bb;
bb5 = bb;
bb6 = bb;


bb_sPL = bb1;
bb_sPR = bb2;
bb_sML = bb3;
bb_sMR = bb4;
bb_sAL = bb5;
bb_sAR = bb6;

%% Stroke in the LPCA

    for i = 1:Nn
        if cns(i) == 1     % is it black
            row = CCn(i,:);
            for j = 1:Nn
                if (row(j)==1) && (cns(j)==5)
                   bb_sPL(i,j) = factor*bb1(i,j);
                   bb_sPL(j,i) = factor*bb1(j,i);
                else
                end
             end            
        end 
    end
    
%% Stroke in the RPCA

    for i = 1:Nn
        if cns(i) == 1     % is it black
            row = CCn(i,:);
            for j = 1:Nn
                if (row(j)==1) && (cns(j)==2)
                   bb_sPR(i,j) = factor*bb2(i,j);
                   bb_sPR(j,i) = factor*bb2(j,i);
                else
                end
             end            
        end 
    end
    
    %% Stroke in the LMCA

    for i = 1:Nn
        if cns(i) == 1     % is it black
            row = CCn(i,:);
            for j = 1:Nn
                if (row(j)==1) && (cns(j)==4)
                   bb_sML(i,j) = factor*bb3(i,j);
                   bb_sML(j,i) = factor*bb3(j,i);
                else
                end
             end            
        end 
    end
    
%% Stroke in the RMCA

    for i = 1:Nn
        if cns(i) == 1     % is it black
            row = CCn(i,:);
            for j = 1:Nn
                if (row(j)==1) && (cns(j)==3)
                   bb_sMR(i,j) = factor*bb4(i,j);
                   bb_sMR(j,i) = factor*bb4(j,i);
                else
                end
             end            
        end 
    end
    
%% Stroke in the LACA

    for i = 1:Nn
        if cns(i) == 1     % is it black
            row = CCn(i,:);
            for j = 1:Nn
                if (row(j)==1) && (cns(j)==7)
                   bb_sAL(i,j) = factor*bb5(i,j);
                   bb_sAL(j,i) = factor*bb5(j,i);
                else
                end
             end            
        end 
    end
    
%% Stroke in the RACA

    for i = 1:Nn
        if cns(i) == 1     % is it black
            row = CCn(i,:);
            for j = 1:Nn
                if (row(j)==1) && (cns(j)==6)
                   bb_sAR(i,j) = factor*bb6(i,j);
                   bb_sAR(j,i) = factor*bb6(j,i);
                else
                end
             end            
        end 
    end
%     Nn = length(cns);
%     x = ones(Nn);
%     xs = x;
%     for i = 1:Nn
%         
%         if cns(i) == 1
%             row = CCn(i,:);
%             
%             for j = 1:Nn
%                 
%                 if (row(j)==1) && (cns(j)==2)
%                    xs(i,j)=0.3*x(i,j);
%                    xs(j,i)=0.3*x(j,i);
%                    else
%                 end
%                 
%             end 
%             
%         end
%         
%     end
