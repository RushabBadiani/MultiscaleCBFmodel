function [bb] = choose_stroke(bb_sPL,bb_sPR,bb_sML,bb_sMR,bb_sAL,bb_sAR,Stroke)

if Stroke == 1
    bb = bb_sPL;
    elseif Stroke == 2 
    bb = bb_sPR;
    elseif Stroke == 3 
    bb = bb_sML;
    elseif Stroke == 4 
    bb = bb_sMR;
    elseif Stroke == 5 
    bb = bb_sAL;
    elseif Stroke == 6 
    bb = bb_sAR;
end