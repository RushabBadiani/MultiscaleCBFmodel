%% MULTI-SCALE BRAIN VASCULATURE NETWORK - GLOBAL SCRIPT

global Q Bn P cns xns yns zns;

%% DEFINING THE VALUES OF KEY PARAMETERS
SF        = 0.3;     % Shrink factor of control volume around large arterial network
s         = 5;       % This is the subject number and will range from 1 to 61.
Stroke    = 2;       % Stroke can be between 1 to 6 where 1 = LPCA, 2 = RPCA, 
                     % 3 = LMCA, 4 = RMCA, 5 = LACA, 6 = RACA 

% Import the x, y, z coordinate data alongside aperture and color data                     
[Subject] = xlsread('Morphometry3(changed).xlsx',num2str(s));                     

%% GENERATE A NETWORK (DVN)

[xns,yns,zns,bns,cns] = Generate_Network(Subject);

%% BUILD A NODE MATRIX

[CCn,LL,bb,Bn] = Build_Node_Matrix(xns,yns,zns,bns,cns,Subject);

%% SIMULATE A STROKE
 
[bb_sPL,bb_sPR,bb_sML,bb_sMR,bb_sAL,bb_sAR] = strokesimulation(bb,cns,CCn);
[bb] = choose_stroke(bb_sPL,bb_sPR,bb_sML,bb_sMR,bb_sAL,bb_sAR,Stroke);

%% BUILD A CONDUCTANCE MATRIX & SOLVE FOR INTERNAL PRESSURES AND FLOW

[Mu_vivo] = Viscosity(bb,xns);
[pns,QQ]  = Solve_Flow(CCn,bb,LL,Mu_vivo,Bn);
[Q]       = Volume_Flow(QQ);

%% STUDY THE FLOW THROUGH THE NETWORK

[q0,Qt,Qtb,Qtf,Nall,qLP,qRP,qLM,qRM,qLA,qRA] = Total_Flow_Rate(Bn,cns,Q);

%% COUPLE THE NETWORK WIYH MCCONNELL'S STEADY STATE AUTOREGULATION MODEL 

[QbA6,QfA6,QtA6]       = Autoregulate6(q0,Qt)                            ; % FOR EACH TERRITORY 
[QbAall,QfAall,QtAall] = AutoregulateALL(Qt,Nall,qLP,qRP,qLM,qRM,qLA,qRA); %FOR ALL VESSELS

% Plot a 3D large arterial network color-coded by flow rate (mm^3/s)
figure(1)
Plot_Flow(xns,yns,zns,CCn,QQ,pns)
hold off
%% CREATE CONTROL VOLUME BOUNDARY FOR EL-BOURIS'S MICROCIRCULATION MODEL 
P     = [xns, yns, zns];    % x, y, z node coordinates     

[k,V] = boundary(P,SF)  ;   % k = Coordinates of triangulated faces
                            % V = Volume bound by surface

% surf2mesh and savestl are two functions taken from the iso2mesh toolbox
% full details can be found at http://iso2mesh.sourceforge.net/cgi-bin/index.cgi
[node, elem, face] = surf2mesh([P(:,3) P(:,1) P(:,2)],k,[0 0 0],[160 160 160],1,10);
savestl(node,elem,'brain3D.stl')

% Plot the control volume boundary around large arterial network as a closed 
% surface made up of triangles in 3D space.
figure(2)
whitebg([1 1 1])
trisurf(k,P(:,3),P(:,1),P(:,2),'Facecolor','white','Edgecolor','Black','FaceAlpha',1)
axis equal
    xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca,'Zdir','reverse','Xdir','reverse')
    view([-30 10])

% Visualize the resulting mesh
figure(3)
plotmesh([node(:,1) node(:,2) node(:,3)],face(:,1:3),'facecolor','r');
axis equal
    grid on
    xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca,'Zdir','reverse','Xdir','reverse')
    view([-30 10])
 

 
%% RE-CREATE EL-BOURI'S PERFUSION MODEL THROUGH THE CAPILLARY BEDS USING MATLAB'S PDEPE TOOLBOX
 
[pnsP,fP] = feedbackPressureBound3(Bn,QtA6,pns,P,k);
[vP,u]    = velocityPerfusion(QtA6,P,Q,Bn,pns,node,elem,k,V,xns,yns,zns);
mass      = 960*V*1e-9;

