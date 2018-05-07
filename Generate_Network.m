%% GENERATE A SINGLE BRAIN VASCULATURE NETWORK (DVN)
% This function will take morphometric data from http://cng.gmu.edu/brava
% to produce vectors containing the coordinates, lengths and node numbers 
% for each patient.

function [xns,yns,zns,bns,cns] = Generate_Network(Subject)

cns =  Subject(:,2);
xns =  Subject(:,3);
yns =  -Subject(:,4);
zns =  Subject(:,5);
bns =  Subject(:,6); % This data we are taking to be in mm

for i = 1:length(cns)
    if cns(i) == 0
        cns(i) = 1;
    else
    end
end
end