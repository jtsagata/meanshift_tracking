function d_matrix = kernelMatrix(m,n,varargin)
    %distancematrix(m,n) Calculate the  epanechnikovMatrix of size MXN
    %    Return an NXM kernel matrix of coefficients
    % or distancematrix(m,n, 'kernel','kernelname')
    %    where kernelname is 'gaussian' or 'epanechnikov' (default)

    % Handling of parameters
    p = inputParser;
    defaultKernel = 'epanechnikov';
    expectedKernels = {'gaussian','epanechnikov'};
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'m', validScalarPosNum);
    addRequired(p,'n', validScalarPosNum);
    addParameter(p,'kernel',defaultKernel,...
                 @(x) any(validatestring(x,expectedKernels)));
    parse(p,m,n,varargin{:});
    kernel=p.Results.kernel;
   
    cm = m/2;
    cn = n/2;
    norm_dist = sqrt( (cm-1)^2 + (cn-1)^2);

    [xx,yy]=meshgrid(1:m,1:n);
    X = sqrt((xx - cm).^2 + (yy - cn).^2) ./norm_dist;

    if strcmp(kernel, 'epanechnikov') 
        d_matrix = 3/1 .* ( ones(n,m) - X.^2 );
    else % Gaussian
        d_matrix = 2/pi .* ( ones(n,m) - X );
    end

    d_matrix = transpose(d_matrix);

end
