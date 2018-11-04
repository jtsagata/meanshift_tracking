function Z = meanshift_vector(imPatch, weights)   

    imageDims=size(imPatch,3);
    od = repmat({':'},1,ndims(imPatch)-1);
    Z=zeros(imageDims,2);
    
    for c=1:imageDims
        if imageDims == 3
            chanel_image = imPatch(od{:},c);
            weights_image = weights(od{:},c);
        else
            chanel_image = imPatch;
            weights_image = weights;
        end
        Z(c,:)=meanshift_vector_2D(chanel_image,weights_image);
    end
    
    if imageDims == 3
        Z = mean(Z);
    end
end


function Z = meanshift_vector_2D(imPatch, weights)   
    % All X coords
    ix=1:size(imPatch,1);
    SXW = sum(sum(ix * weights ));
    
    % All Y coords
    iy=1:size(imPatch,2);
    SYW = sum(sum(weights * transpose(iy) ));
    
    % Mean Location
    SW = sum(weights(:));
    
    % TODO: Check this
    Z = ceil([SXW/SW, SYW/SW]);
end

