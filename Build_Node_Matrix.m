%% BUILD A NODE MATRIX, LENGTH MATRIX & APERTURE MATRIX

function [CCn,LL,bb,Bn] = Build_Node_Matrix(xns,yns,zns,bns,cns,Subject)

Nn = length(xns); % This will be the number of nodes present in the Subjects Data

% Pre-allocate CCn size - matrix row i and column j - if node i is
% connected to node j - CCn stores a 1 in the corresponding space, if not 
% then CCn stores 0.

CCn = zeros(Nn);

    for i = 2:Nn
        A = Subject(i,7);   
        CCn(i,A) = 1;
    end

CCn = CCn+CCn.';

CCn(1,1) = 0;

%% BUILDING BOUNDARY NODE VECTOR

% Identify boundary nodes -  Make a new matrix fil1ed with 1 and 2's for Bn
Bn = zeros(Nn,1);
for i = 1:Nn
    if CCn(i,i) == -1
        Bn(i) = 1;
    elseif sum(abs(CCn(i,:))) == 1
        Bn(i) = 2;
    end
end

apertureends = zeros(Nn,1);
apertureICAsandBA = zeros(Nn,1);

    for i = 1:Nn
        if cns(i) == 1 && Bn(i) == 2
        apertureends(i) = yns(i); 
        end
    end
    
[temp,originalpos] = sort( apertureends, 'descend' );
apertureICAsandBA = temp(1:3);
indexofICAsandBA = originalpos(1:3);

    
for i = 1:Nn
    if Bn(i) == 2 && i == indexofICAsandBA(1)
        Bn(i) = 1;       
        CCn(i,i) = -1;
    elseif  Bn(i) == 2 && i == indexofICAsandBA(2)
        Bn(i) = 1;       
        CCn(i,i) = -1;
    elseif  Bn(i) == 2 && i == indexofICAsandBA(3)
        Bn(i) = 1;       
        CCn(i,i) = -1;
    end
end


%% BUILDING THE FRACTURE LENGTH MATRIX

    for i = 1:Nn
        for j = 1:Nn
            L = [xns(i)-xns(j) ; abs(yns(i)) - abs(yns(j)); zns(i) - zns(j)];   % Find link length
            LL(i,j) = norm(L,2);                                      % norm(X,2) returns the 2-norm of X.
        end
    end

%% BUILDING THE APERTURE MATRIX

bb = zeros(Nn);

    for i = 1:Nn
        for j = 1:Nn
            % Find aperture of link for fractures only
            if CCn(i,j) == 1
                bb(i,j) = 0.5*(bns(i)+bns(j));
            elseif CCn(i,j) == -1                
                  bb(i,j) = bns(i);
            end
        end
    end
