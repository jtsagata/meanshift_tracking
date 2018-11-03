function imageOut = annotate_frame(image, frame_number)    
    % Insert frame Number
    text_str = ['Frame: ' num2str(frame_number,'%4d') ];
    imageOut = insertText(image, [5,25], text_str, 'AnchorPoint','LeftBottom','TextColor','red');    
end


