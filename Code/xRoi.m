classdef xRoi
    %UNTITLED12 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cx
        cy
        width
        height
    end
    
    methods
        function obj = xRoi(cx,cy,width,height)
            %UNTITLED12 Construct an instance of this class
            %   Detailed explanation goes here
            obj.cx = round(cx);
            obj.cy = round(cy);
            obj.width = round(width);
            obj.height = round(height);
            
        end
        
        function new_roi = scale(self,k)
            new_width = round(self.width);
            new_height = round(self.height);
            new_roi = xRoi(self.cx,self.cy,new_width*k,new_height*k);
        end
        
        function r=x(self) 
            r = round(max(1, self.cx - self.width/2));
        end
        
        function r=y(self)
            r = round(max(1, self.cy - self.height/2));
        end
        
        function imPatch=getRoiImage(self, image) 
            % This function extract an image patch from an image

            ImWidth = size(image,2);
            ImHeight = size(image,1);
            
            x2 = round( min(ImWidth,  self.x+self.width));
            y2 = round( min(ImHeight, self.y+self.height)); 
            
            imPatch = image(self.y:y2, self.x:x2); 
        end
        
        function imageOut = annotate(self,image)
            if  ismatrix(image) && ndims(image) == 2
                % Convert frame to RGB
                image=cat(3,image);
            end
               
            imageOut = insertMarker(image,[self.cx,self.cy],'x', 'color','red');
             
            x1 = self.cx - self.width/2;
            y1 =  self.y;
            x2 = round( min(self.width,  x1+self.width+1));
            y2 = round( min(self.height, y1+self.height+1));

            
            imageOut = insertShape(imageOut,'rectangle', ...
                [self.x, self.y, x2, y2], ...
                'LineWidth', 2, 'Color', 'green');
        end
        
        function r=area(self)
            r = self.width * self.height;
        end
        
         
    end
end

