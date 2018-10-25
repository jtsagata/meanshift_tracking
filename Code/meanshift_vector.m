function Z = meanshift_vector(imPatch, weights)   
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

