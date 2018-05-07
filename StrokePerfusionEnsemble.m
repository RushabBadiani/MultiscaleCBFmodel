%% DEFINING THE VALUES OF KEY PARAMETERS
clc

global Q Bn P cns xns yns zns;

kkimport       = xlsread('PERF2.xlsx','Sheet3');
kkfulllist     = kkimport(:,1);

factor = 1;

QPs = zeros(61,6);

%% GENERATE AN ENSEMBLE OF NETWORKS
for i=1
Stroke =1;
    for s = 15
        
        kk        = kkfulllist(s);

        [Subject] = xlsread('Morphometry3(changed).xlsx',num2str(s));

        [xns,yns,zns,bns,cns] = Generate_Network(Subject);  

        [CCn,LL,bb,Bn] = Build_Node_Matrix(xns,yns,zns,bns,cns,Subject);

        [Mu_vivo] = Viscosity(bb,xns);
        
        [bb_sPL,bb_sPR,bb_sML,bb_sMR,bb_sAL,bb_sAR] = strokesimulation(bb,cns,CCn,factor);
        [bb] = choose_stroke(bb_sPL,bb_sPR,bb_sML,bb_sMR,bb_sAL,bb_sAR,Stroke);

        [pns,QQ] = Solve_Flow(CCn,bb,LL,Mu_vivo,Bn);

        [Q] = Volume_Flow(QQ);
 
        [q0,Qt,Qtb,Qtf,Nall,qLP,qRP,qLM,qRM,qLA,qRA] = Total_Flow_Rate(Bn,cns,Q);

        % Note that it has been hard-coded into the equation that Pin = 50 mmHg,
        % Pic = 10 mmHg and Pv = 6 mmHg

            QbA6  = zeros(1,6);
            for k       = 1:6
                myfun   = @(q) (((45 - 6 - (1.88*(Qt/q0(k)))*q) / q)*( ((0.21/(Qt/q0(k))) + (1.435/(Qt/q0(k)))*tanh( ((-2*3)/(1.435)) *(q -(q0(k)))/(q0(k))))*(45 - 2*10 + (1.88*(Qt/q0(k)))*q) + (.21/(Qt/q0(k)))*(2*45-2*10-(q0(k)*5.03)) +2*(12/(Qt/q0(k))))^2 - 4*5.03*(Qt/q0(k))*((12/(Qt/q0(k)))^2));                  % parameter
                fun     = @(q) myfun(q);    % function of x alone
                qA      = fzero(fun,q0(k));
                QbA6(k) = qA;
            end
            QtA6 = sum(QbA6); % Total flow out of Autoregulated model
    P     = [xns, yns, zns];    % x, y, z node coordinates
    [k,V] = boundary(P,kk) ;    % k = Coordinates of triangulated faces
                                % V = Volume bound by surface
    [node, elem, face] = surf2mesh([P(:,3) P(:,1) P(:,2)],k,[0 0 0],[160 160 160],1,10);
    savestl(node,elem,'brain3D.stl')
            
    [vP,u] = velocityPerfusion(QtA6,P,Q,Bn,pns,node,elem,k,V,xns,yns,zns);
    mass = 960*V*1e-9;
    a= mean(vP);
    b= abs(sum(abs(vP))/V);
    aperf = (b)*(0.1/mass)*60;        
%      
%     QPs(s,Stroke) = aperf;
    end
end