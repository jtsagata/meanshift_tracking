function imageOut = annotate_frame(image,center,width,height,frameNo)

    % Insert rectangle
    x = round(center(1)-width/2);
    y = round(center(2)-height/2);
    imageOut =insertShape(image,'rectangle',[x,y,width,height],'LineWidth', 2, 'Color', 'red');
 
    % Insert marker
    imageOut = insertMarker(imageOut,center,'x', 'color','red');
    
    % Insert frame Number
    text_str = ['Frame: ' num2str(frameNo,'%4d') ];
    imageOut = insertText(imageOut, [5,25], text_str, 'AnchorPoint','LeftBottom','TextColor','red');    
    
end


