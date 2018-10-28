function TargetModel = color_distribution(imPatch, Nbins, weights)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    TargetModel = zeros(1,Nbins);

    whereToPut = histDistMat(imPatch,Nbins);
    for indx=1:Nbins
        TargetModel(indx) = sum(sum( weights .* (whereToPut == indx)));
        TargetModel(indx) = sum(sum( (whereToPut == indx)));
    end

    function whereToPut = histDistMat(image,n)
        %whereToPut Summary of this function goes here
        %   Detailed explanation goes here

        binSize = 1.0/n;
        whereToPut = arrayfun(@(x) uint8(floor(x/binSize))+1,image);
    end
    
end

