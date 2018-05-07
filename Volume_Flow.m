function [Q] = Volume_Flow(QQ)

% Obtain Nn
Nn = length(QQ);

% Pre-allocate size of Q
Q = zeros(Nn,1);

% TASK 4B
% Sum row i of QQ to get total flow into node i. Task 4(B)
    for i = 1:Nn
        Q(i) = sum(QQ(i,:));
    end
    
     
 