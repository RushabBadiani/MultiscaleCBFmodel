function [pnsP,fP] = feedbackPressureBound3(Bn,QtA6,pns,P,k)

c = [4.26e-4;4.31e-4;4.27e-4];    % mm^3 s kg^-1
a = 0; 
f = QtA6*1e-3;                   % mm^3 / s

model = createpde(); importGeometry(model,'brain3D.stl'); 
specifyCoefficients(model,'m',0,'d',0,'c',c,'a',a,'f',f);
h = generateMesh(model,'GeometricOrder','linear'); 
modelN = model.Geometry.NumFaces;
 
     PSource = P; PSource = PSource(Bn==2,:);
     pns2    = pns(Bn==2,:);
     pns3    = pns2(pns2 ~= 0);
     
[FaceAreaPDE, FaceCentroidPDE] = FaceGemoetryPDE(h, modelN);
for i = 1:length(FaceAreaPDE)
    if FaceAreaPDE(i) == 0
        FaceAreaPDE(i) = 300;
    else
    end
end
[PP,FF] = PF(FaceCentroidPDE,PSource);

[BCP] = BoundaryPressurePair(PP,FF,pns3);

% BCP = abs(BCP./FaceAreaPDE');

applyBoundaryCondition(model,'dirichlet','Face',1:model.Geometry.NumFaces,'u',10*133.32);
for i = 1:length(BCP)
applyBoundaryCondition(model,'dirichlet','Face',1:model.Geometry.NumFaces,'u',BCP(i));
end

result = solvepde(model);
u = result.NodalSolution;

fP = u;
fPLocation = result.Mesh.Nodes';

xns = P(:,1); yns = P(:,2); zns = P(:,3);

[new_pns] = InterpolateScattered(fP,fPLocation,xns,yns,zns,pns);
 
Nn = length(pns);
pnsP = pns;

for i = 1:Nn
    if Bn(i) == 2
        pnsP(i) = new_pns(i);
    end
end

% 
% figure(6)
% axis equal
% grid on
% % pdegplot3D(model,'ColorMapData',u)
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
%     set(gca,'Zdir','reverse','Xdir','reverse')
%     view([-30 10])   
% % figure(7)
% % PlanesofPlot(node,elem,k,xns,yns,zns)
% figure(8)
% PlanesofPDE(result,k,xns,yns,zns)



