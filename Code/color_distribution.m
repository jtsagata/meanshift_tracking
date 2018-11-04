function TargetModel = color_distribution(imPatch, Nbins, weights)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    TargetModel = zeros(1,Nbins);

    whereToPut = histDistMat(imPatch,Nbins);
    for indx=1:Nbins
        TargetModel(indx) = sum(sum( weights .* (whereToPut == indx)));
    end
end

