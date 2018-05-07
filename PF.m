function [PP,FF] = PF(FaceCentroidPDE,PSource)

FF=FaceCentroidPDE';
FF(FF == 0) = NaN;
PSource( all(~PSource,2), : ) = [];
PP=PSource;
PP(PP == 0) = NaN;