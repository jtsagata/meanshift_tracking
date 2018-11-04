classdef xRoi
    %xRoi A region of interest
    %   Constructors
    %     r = xRoi(image);
    %     r = xRoi([x1,x2],[w,h]);
    %     r = xRoi([cx,cy],w,h);
    %     r = xRoi(x1,y1,x2,y2));
    %   Methods
    %     r=roi.intersect(other)
    %       get intersection with some other roi
    %     new_roi = roi.scale(sx[,sy])
    %       scale by a factors around center
    %     imPatch=roi.getRoiImage(image)
    %       trim the image with the roi
    %     model=roi.color_model(image,nbins)
    %       get a histogram model as pdf estimator
    %     imageOut = roi.annotate(image [,color])
    %       draw roi over image
    
    properties
        tl, length
    end
    
    properties (Dependent)
        center
    end
    
    properties (Dependent, Hidden)
        area, br, width, height
    end
    
    
    methods
        function roi = xRoi(varargin)
            if nargin ==1
                % Create from image
                img = varargin{1};
                h = size(img,1); w = size(img,2);
                x1 = 1;
                y1 = 1;
                
            elseif nargin ==2
                % Create from xRoi([x1,x2],[w,h])
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
            roi.length = [w,h];
            assert ( (roi.length(1) >=0), 'Negative width');
            assert ( (roi.length(2) >=0), 'Negative height');
        end
        
        function center=get.center(self)
            cx= round(self.tl(1) + self.length(1)/2) -1;
            cy= round(self.tl(2) + self.length(2)/2) -1;
            center=[cx,cy];
        end
        
        function br=get.br(self)
            br=[self.tl(1)+self.length(1)-1,self.tl(2)+self.length(2)-1];
        end
        
        function width = get.width(self) 
            width = self.length(1);
        end
        
        function height = get.height(self)
            height = self.length(2);
        end

        
        function area = get.area(self)
            area = self.length(1) * self.length(2);
        end
        
        function new_roi = scale(self,sx,sy)
            if nargin == 3
                width = self.length(1) *sx;
                height = self.length(2) *sy;
            else
                width = self.length(1) *sx;
                height = self.length(2) *sx;
            end
            new_roi = xRoi(self.center, round(width), round(height));
        end

        function roi=intersect(self, other)
            x1 = max(self.tl(1),other.tl(1));
            y1 = max(self.tl(2),other.tl(2));

            x2 = min(self.br(1),other.br(1));
            y2 = min(self.br(2),other.br(2));
            
            roi = xRoi(x1,y1, x2,y2);
        end 
        
        function imPatch=getRoiImage(self, image)
            % imPatch=roi(image) Trim an image with the ROI get the sub image
            frameROI = xRoi(image);
            inter = frameROI.intersect(self);  
            % ImPatch is work on all type of images
            imPatch = imcrop(image, [inter.tl(1),inter.tl(2),inter.length(1),inter.length(2)]);
        end
        
        function model=color_model(self,image,varargin)
            % Handling of parameters
            p = inputParser;
            defaultKernel = 'epanechnikov';
            expectedKernels = {'gaussian','epanechnikov'};
            validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
            addParameter(p,'nbins', 8, validScalarPosNum);
            addParameter(p,'kernel',defaultKernel,...
                 @(x) any(validatestring(x,expectedKernels)));
            parse(p,varargin{:});
            kernel=p.Results.kernel;
            nbins=p.Results.nbins;
            
            imgRoi = xRoi(image);
            imPatch  = getRoiImage(self, image);
            weights = kernelMatrix(imgRoi.length(2),imgRoi.length(1),'kernel',kernel);
            
            model = color_distribution(imPatch, nbins, weights);
        end
        
        function imageOut = annotate(self,image,color)
            if nargin == 2
                color = 'red';
            end
            if  ismatrix(image) && ndims(image) == 2
                % Convert frame to RGB
                image=cat(3,image);
            end
            
            if (isfinite(self.center))
                imageOut = insertMarker(image,[self.center(1),self.center(2)],'x', 'color', color);
            else
                imageOut = image;
            end
            
            if (isfinite(self.tl))
                imageOut = insertShape(imageOut,'rectangle', ...
                    [self.tl(1), self.tl(2), self.length(1), self.length(2)], ...
                    'LineWidth', 2, 'Color', color);
            end
        end
        
    end
end

