function weights = mean_shift_weights(imPatch, TargetModel, ColorModel, Nbins)
    
    % Avoid zero elements
    weights = ones(size(imPatch))*eps;
    whereToPut = histDistMatrix(imPatch,Nbins);

    for i=1:Nbins
        weights = weights + ( whereToPut == i) .*  sqrt(TargetModel(i)/ColorModel(i));
    end
    
end