function patch_model = color_distribution(imPatch, Nbins, weights)
    
    patch_model=[];
    od = repmat({':'},1,ndims(imPatch)-1);
    imageDims=size(imPatch,3);
    
    % Histogram is the sum of histograms in each size
    for c=1:imageDims
        chanel_model = zeros(1,Nbins);
        if imageDims == 3
            chanel_image = imPatch(od{:},c);
        else
            chanel_image = imPatch;
        end
        
        whereToPut = histDistMat(chanel_image,Nbins);
        for indx=1:Nbins
            chanel_model(indx) = sum(sum( weights .* (whereToPut == indx)));
        end
        patch_model=[patch_model chanel_model];
    end
    
    % No zeroelements
    patch_model = patch_model + eps;
    
end

