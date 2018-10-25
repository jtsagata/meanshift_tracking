function whereToPut = histDistMatrix(imPatch,Nbins)
%whereToPut Summary of this function goes here
%   Detailed explanation goes here

    binSize = floor(256/Nbins);
    whereToPut = arrayfun(@(x) uint8(floor(x/binSize))+1,imPatch);

end

