function imageOut = annotate_frame_vectors(image, vectors,color)    
    imageOut = image;
    for i=1:size(vectors,1)
        v=vectors(i,:);
        imageOut = insertMarker(imageOut,[v(1),v(2)],'x', 'color', color);
    end
end


