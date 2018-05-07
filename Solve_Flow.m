%% CALCULATE THE PRESSURE AT NODES AND THE FLOW-RATE BETWEEN NODES

function [pns,QQ] = Solve_Flow(CCn,bb,LL,Mu_vivo,Bn)
%% PRE-ALLOCATE SIZES OF OUTPUTS

% Obtain number of nodes
Nn = length(CCn);

% Pre-al1ocate size of A, c and QQ
G  = zeros(Nn);
QQ = zeros(Nn);
c  = zeros(Nn,1);

% Set input and output pressures at external nodes
pA = 100*133.32;   % Arterial Pressure (mm Hg)
pC = 45*133.32 ;   % Capillary Pressure (mm Hg)

%% CREATING MATRIX 'G' (CONDUCTANCE) 
% 'G' is a matrix of bracnh conductances

% Avoid issues for LL(i,j) = 0 when i~=j by setting LL(i,j) to 1 and
% bb(i,j) to zero, making the overal1 term zero.
for i = 1:Nn
    for j = 1:Nn
        if i~=j
            if LL(i,j).*Mu_vivo(i,j) == 0
                LL(i,j) = 1;
                Mu_vivo(i,j) =1;
                bb(i,j) = 0;
            end
        end
    end
end



for i = 1:Nn
    for j = 1:Nn
        if i == j
            G(i,j) = sum((pi*bb(i,1:i-1).^4)./(8*Mu_vivo(i,1:i-1).*LL(i,1:i-1))) + sum((pi*bb(i,i+1:Nn).^4)./(8*Mu_vivo(i,i+1:Nn).*LL(i,i+1:Nn)));     
        elseif LL(i,j) == 0 && i ~= j
            G(i,j) = 0;
        else
            G(i,j) = -(pi*bb(i,j).^4)/(8*Mu_vivo(i,j).*LL(i,j));
        end   
    end
end


% Create a dummy matrix Gd - to use for later
Gd = G;

% In order to get a meaningful solution, we must impose boundary
% conditions. This is done in two steps:
% 1. Delete all the rows from G that correspond to the boundary nodes, 
% since these known pressures must be removed from the vector of unknowns.
% 2. In the remaining equations, identify the terms that involve boundary 
% nodes and move these to the right-hand side of the equation—these become 
% part of the vector [c] = [Gext](Pext). Then, delete the corresponding 
% columns from G as well. Set up n for reducing matrix
n = 0;

% Remove rows of A and c that correspond to boundary nodes
for i = 1:Nn
    if Bn(i) == 1
        G(i-n,:) = [];
        c(i-n) = [];
        % Increase n by 1 to accound for reducing size
        n = n + 1;
    elseif Bn(i) == 2
        G(i-n,:) = [];
        c(i-n) = [];
        n = n + 1;
    else
        G(i-n,:) = G(i-n,:);
    end
end

% Find number of rows in c
Nc = length(c);

% Identify terms that involve boundary nodes and move them to c. 
for i = 1:Nc
    for j = 1:Nn
        if Bn(j) == 1
            c(i) = c(i) - G(i,j)*pA;
        elseif Bn(j) == 2
            c(i) = c(i) - G(i,j)*pC;
        end
    end
end

% Reset n
n = 0;

% Remove corresponding columns from A.
for i = 1:Nn
    if Bn(i) == 1
        G(:,i-n) = [];
        % Increase n by 1 to accound for reducing size
        n = n + 1;
    elseif Bn(i) == 2
        G(:,i-n) = [];
        n = n + 1;
    else
        G(:,i-n) = G(:,i-n);
    end
end

% Solve for internal nodes
% pns = abs(G\c);
pns = G\c;
%% CREATE A VECTOR OF PRESSURES AT ALL NODES
% Add boundary nodes to pns

for i = 1:Nn
    if Bn(i) == 1
        pns = [pns(1:i-1) ; pA ; pns(i:end,:)];
    elseif Bn(i) == 2
        pns = [pns(1:i-1) ; pC ; pns(i:end,:)];
    end
end

%% CREATE A MATRIX OF FLOW-RATES BETWEEN NODES
% Find volume flow between nodes

for i = 1:Nn
    for j = 1:Nn
        if i == j
            QQ(i,j) = 0;
        elseif QQ(j,i) ~= 0
            QQ(i,j) = -QQ(j,i);
        else
            QQ(i,j) = -((pi*bb(i,j).^4)*(pns(j)-pns(i)))/(8*Mu_vivo(i,j).*LL(i,j));
        end
    end
end

