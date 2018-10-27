classdef xRoi
    %xRoi A region of interest
    %   Detailed explanation goes here
    
    properties
        tl, size
    end
    
    properties (Dependent)
        center
    end
    
    properties (Dependent, Hidden)
        area, br
    end
    
    
    methods
        function roi = xRoi(varargin)
            if nargin ==2
                % Create from xRoi[x1,x2],[w,h])
                x1 = round(varargin{1}(1));
                y1 = round(varargin{1}(2));
                w  = round(varargin{2}(1));
                h  = round(varargin{2}(2));                
            elseif nargin ==3
                % Create from xRoi([cx,cy],w,h)
                cx = varargin{1}(1);
                cy = varargin{1}(2);
                w  = varargin{2};
                h  = varargin{3};
                if mod(w,2) == 0
                    x1 = round(cx - w/2)+1;
                else
                    x1 = round(cx - w/2);
                end
                if mod(w,2) == 0
                    y1 = round(cy - h/2)+1;
                else
                    y1 = round(cy - h/2);                    
                end
            elseif nargin ==4
                % Create from xRoi(x1,y1,x2,y2)
                x1 = round(varargin{1});
                y1 = round(varargin{2});
                x2 = round(varargin{3});
                y2 = round(varargin{4});
                w = x2-x1+1;
                h = y2-y1+1;
            end
            roi.tl   = [x1,y1];
            roi.size = [w,h];
            assert ( (roi.size(1) >=0), 'Negative width');
            assert ( (roi.size(2) >=0), 'Negative height');
        end
        
        function center=get.center(self)
            cx= round(self.tl(1) + self.size(1)/2) -1;
            cy= round(self.tl(2) + self.size(2)/2) -1;
            center=[cx,cy];
        end
        
        function br=get.br(self)
            br=[self.tl(1)+self.size(1)-1,self.tl(2)+self.size(2)-1];
        end
        
        function area = get.area(self)
            area = self.size(1) * self.size(2);
        end
        
        function new_roi = scale(self,sx,sy)
            if nargin == 3
                width = self.size(1) *sx;
                height = self.size(2) *sy;
            else
                width = self.size(1) *sx;
                height = self.size(2) *sx;
            end
            new_roi = xRoi(self.center, round(width), round(height));
        end

        
%         
%         function [imPatch,imRoi]=getRoiImage(self, image) 
%             % This function extract an image patch from an image
% 
%             ImWidth = size(image,2);
%             ImHeight = size(image,1);
%             
%             x2 = round( min(ImWidth,  self.x+self.width));
%             y2 = round( min(ImHeight, self.y+self.height)); 
%             
%             imPatch = image(self.y:y2, self.x:x2);
%             
%             imRoi = 0;
%         end
%         
%         function imageOut = annotate(self,image)
%             if  ismatrix(image) && ndims(image) == 2
%                 % Convert frame to RGB
%                 image=cat(3,image);
%             end
%                
%             imageOut = insertMarker(image,[self.cx,self.cy],'x', 'color','red');
%              
%             x1 = self.cx - self.width/2;
%             y1 =  self.y;
%             x2 = round( min(self.width,  x1+self.width+1));
%             y2 = round( min(self.height, y1+self.height+1));
% 
%             
%             imageOut = insertShape(imageOut,'rectangle', ...
%                 [self.x, self.y, x2, y2], ...
%                 'LineWidth', 2, 'Color', 'green');
%         end
%         
%         function roi=intersect(self,image)
%             % This function claculate the intersection roi
% 
%             % Note that it is height,width
%             imageH = size(I,1); imageW = size(I,2);
% 
%             y1 = max(1, floor(self.cy - self.height/2));
%             x1 = max(1, floor(self.cx - self.width/2));
%     
%             y2 = min(imageH, ceil(self.cy + self.height/2));
%             x2 = min(imageW, ceil(self.cx + self.width/2));
%             
%             
% 
%     
% %     r2 = round(min(imageH, y1+h+1));
% %     c2 = round(min(imageW, x+w+1));
% %     r = round(max(y1, 1));
% %     c = round(max(x, 1));
% %     imPatch = I(r:r2, c:c2, :);  
%         end
%         
%         function r=area(self)
%             r = self.width * self.height;
%         end
%         
         
    end
end

