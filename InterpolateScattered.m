function [new_pns] = InterpolateScattered(fP,fPLocation,xns,yns,zns,pns2)

x = fPLocation(:,1); 
y = fPLocation(:,2); 
z = fPLocation(:,3);

v = fP;
 
xq = xns;
yq = yns;
zq = zns;

% vq = abs(griddata(x,y,z,v,xq,yq,zq,'nearest'));
p = [x,y,z];
q = [xq,yq,zq];
vq = griddatan(p,v,q);

vq2 = pns2.*isnan(vq);
vq(isnan(vq))=0;

new_pns = vq+vq2;