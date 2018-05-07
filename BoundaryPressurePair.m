function [BCP] = BoundaryPressurePair(PP,FF,pns3)
[Dk, Ik] = knnsearch(FF,PP);
LengthFF = max(size(FF));

% FrequencyTable  = tabulate(Dk);
% MaxPointsToFace = max(FrequencyTable(:,2));

IndividualBCQS  = zeros(LengthFF,1); 

    for i = 1:length(Dk)
        FaceID = Dk(i);
             if IndividualBCQS(FaceID) == 0
                IndividualBCQS(FaceID) = pns3(i);
             else IndividualBCQS(FaceID) = (IndividualBCQS(FaceID) + pns3(i))./2;
             end
    end
    
BCQPressure = IndividualBCQS;

BCQPressure2 = BCQPressure(BCQPressure ~= 0);
a = mean(BCQPressure2);

% for i = 1:length(BCQPressure)
%     if isnan(i)
%         BCQPressure(i) = a;
%     elseif BCQPressure(i) ==0
%         BCQPressure(i) = a;
%     else
%     end
% end

for i = 1:length(BCQPressure)
    if isnan(i)
        BCQPressure(i) = 10*133.32;
    elseif BCQPressure(i) ==0
        BCQPressure(i) = 10*133.32;
    else
    end
end

BCP = BCQPressure;

