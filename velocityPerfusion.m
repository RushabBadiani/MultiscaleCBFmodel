function [vP,u] = velocityPerfusion(QtA6,P,Q,Bn,pns,node,elem,k,V,xns,yns,zns)

c = 1;
a = 0;
f = -QtA6;

figure(4)
model = createpde();
importGeometry(model,'brain3D.stl');
% pdegplot(model,'Facelabels','on','EdgeLabels','off','FaceAlpha',1)
% grid on
% axis equal
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
%     set(gca,'Zdir','reverse','Xdir','reverse')
%     view([-30 10]) 
specifyCoefficients(model,'m',0,'d',0,'c',c,'a',a,'f',f);

h = generateMesh(model,'GeometricOrder','linear');
modelN = model.Geometry.NumFaces;

[QSource,PSource,pns2] = SpatialQ(P,Q,Bn,pns);
QS = QSource(QSource ~= 0);


[FaceAreaPDE, FaceCentroidPDE] = FaceGemoetryPDE(h, modelN);
FF=FaceCentroidPDE';
FF(FF == 0) = NaN;
PSource( all(~PSource,2), : ) = [];
PP=PSource;
PP(PP == 0) = NaN;


[BCQ] = BoundaryPointPair(PP,FF,QS);

BoundaryConditionQ = abs(BCQ./FaceAreaPDE');
BoundaryConditionQ(isnan(BoundaryConditionQ))=0;

for i = 1:length(BoundaryConditionQ)
    if isnan(i)
        BoundaryConditionQ(i) = 0;
    else
    end
end

applyBoundaryCondition(model,'dirichlet','Face',1:model.Geometry.NumFaces,'u',0);
for i = 2:length(BoundaryConditionQ)
applyBoundaryCondition(model,'dirichlet','Face',i,'u',-BoundaryConditionQ(i));
end


result = solvepde(model);
u = result.NodalSolution;

vP=u;

figure(6)
axis equal
grid on
pdeplot3D(model,'ColorMapData',result.NodalSolution)
xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca,'Zdir','reverse','Xdir','reverse')
    view([-30 10])   
% figure(7)
% PlanesofPlot(node,elem,k,xns,yns,zns)
% figure(8)
% PlanesofPDE(result,k,xns,yns,zns)
