function PlanesofPlot(node,elem,k,xns,yns,zns)
z0=mean(node(:,3));

plane=[min(node(:,1)) min(node(:,2)) z0
       min(node(:,1)) max(node(:,2)) z0
       max(node(:,1)) min(node(:,2)) z0];

[cutpos,cutvalue,facedata]=qmeshcut(elem(:,1:4),node,node(:,1),plane);

figure(6);
trisurf(k,zns,xns,yns, 'Facecolor','magenta','FaceAlpha',0.1); axis equal;
% hsurf=trimesh(face(:,1:3),node(:,1),node(:,2),node(:,3),'facecolor','none','edgecolor','none');
hold on;
if(isoctavemesh)
  hcut1=patch('Faces',facedata,'Vertices',cutpos);
else
  hcut1=patch('Faces',facedata,'Vertices',cutpos,'FaceVertexCData',cutvalue,'facecolor','red','edgecolor','none');
end

hold on;
y0=mean(node(:,2));

plane=[min(node(:,1)) y0 max(node(:,3)) 
       min(node(:,1)) y0 min(node(:,3)) 
       max(node(:,1)) y0 min(node(:,3)) ];

[cutpos,cutvalue,facedata]=qmeshcut(elem(:,1:4),node,node(:,1),plane);

hold on;
if(isoctavemesh)
  hcut2=patch('Faces',facedata,'Vertices',cutpos);
else
  hcut2=patch('Faces',facedata,'Vertices',cutpos,'FaceVertexCData',cutvalue,'facecolor','green','edgecolor','none');
end
 
hold on;
x0=mean(node(:,1));

plane=[x0 min(node(:,2)) max(node(:,3)) 
       x0 max(node(:,2)) min(node(:,3)) 
       x0 min(node(:,2)) min(node(:,3)) ];
 
[cutpos,cutvalue,facedata]=qmeshcut(elem(:,1:4),node,node(:,1),plane);

hold on;
if(isoctavemesh)
  hcut3=patch('Faces',facedata,'Vertices',cutpos);
else
  hcut3=patch('Faces',facedata,'Vertices',cutpos,'FaceVertexCData',cutvalue,'facecolor','blue','edgecolor','none');
end
 
axis equal;
grid on
    xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca,'Zdir','reverse','Xdir','reverse')
    view([-30 10]) 
legend([hcut1 hcut2 hcut3],'Transverse Plane','Sagittal Plane','Coronal Plane')