function TargetModel = color_distribution(imPatch, Nbins, weights)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    TargetModel = zeros(1,Nbins);
    binSize = floor(256/Nbins);
    whereToPut = arrayfun(@(x) uint8(floor(x/binSize))+1,imPatch);
    
    for indx=1:Nbins
        TargetModel(indx) = sum(sum( weights .* (whereToPut == indx)));
    end
    
end

