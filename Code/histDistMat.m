function whereToPut = histDistMat(image,n)
    %whereToPut Summary of this function goes here
    %   Detailed explanation goes here

    binSize = 1.0/n;
    whereToPut = arrayfun(@(x) uint8(floor(x/binSize))+1,image);
end

