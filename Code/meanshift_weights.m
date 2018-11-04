function weights = meanshift_weights(imPatch, TargetModel, ColorModel, Nbins)
    
    % Avoid zero elements
    weights = ones(size(imPatch))*eps;
    whereToPut = histDistMat(imPatch,Nbins);

    for i=1:Nbins
        multiplier = sqrt(TargetModel(i)/ColorModel(i));
        weights = weights + ( whereToPut == i) .*  multiplier;
    end
    
    assert(all(weights(:) >=0));
end