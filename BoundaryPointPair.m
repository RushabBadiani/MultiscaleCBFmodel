function [BCQ] = BoundaryPointPair(PP,FF,QS)
[Dk, Ik] = knnsearch(FF,PP);
LengthFF = max(size(FF));

% FrequencyTable  = tabulate(Dk);
% MaxPointsToFace = max(FrequencyTable(:,2));

IndividualBCQS  = zeros(LengthFF,1); 

    for i = 1:length(Dk)
        FaceID = Dk(i);
             if IndividualBCQS(FaceID) == 0
                IndividualBCQS(FaceID) = QS(i);
             else IndividualBCQS(FaceID) = IndividualBCQS(FaceID) + QS(i);
             end
    end
    
BCQ = IndividualBCQS;

