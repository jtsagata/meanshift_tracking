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
                    
    end
end

