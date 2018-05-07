function [FaceAreaPDE, FaceCentroidPDE] = FaceGemoetryPDE(h, modelN) 

[p,e,t] = meshToPet(h);

%Predefine size of Face Centroid Data
F = zeros(3,(modelN));
FaceArea = zeros(1,(modelN));

for i = 2:modelN
        A = e.getElementFaces(i);
        sz = size(A);
        len=sz(1)*sz(2);
        if len == 0
            F(:,i) = [0;0;0];
        else
             B = reshape(A,[len,1]);
             tbl = tabulate(B);
             C = find(tbl(:,2)==1);
                if length(C)>=3
                    D = [p(:,C(1)), p(:,C(2)), p(:,C(3))];         
                    E = 1/2*norm(cross(D(:,2)-D(:,1),D(:,3)-D(:,1)));
                    [FaceCenter] = TriFaceCenter(D(:,1),D(:,2),D(:,3),'orthocenter');
                    FaceArea(i) = E; 
                    F(:,i) = FaceCenter;
                elseif length(C) ==2
                    [Fcent] = 0.5*(p(:,C(1))+p(:,C(2)));
                    E1 =[p(:,C(1))';p(:,C(2))'];
                    E2 = pdist(E1,'euclidean');
                    E = 0.5^2 * E2^2;
                    FaceArea(i) = E;
                    F(:,i) = Fcent;
                else
                end
        end
end

FaceAreaPDE = FaceArea;
FaceCentroidPDE = F;