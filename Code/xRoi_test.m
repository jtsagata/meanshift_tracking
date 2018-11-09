% test xRoI operations
clearvars
close all
imtool close all

%%% Even dimensions

% Create from xRoi([cx,cy],w,h)
r =xRoi([7,7],9,7);
assert(isequal(r.center,[7 7]));
assert(isequal(r.length,  [9 7]));
assert(isequal(r.tl,    [3 4]));
assert(isequal(r.br,    [11 10]));

% Create from xRoi[x1,x2],[w,h])
r =xRoi([3,4],[9,7]);
assert(isequal(r.center,[7 7]));
assert(isequal(r.length,  [9 7]));
assert(isequal(r.tl,    [3 4]));
assert(isequal(r.br,    [11 10]));

% Create from xRoi(x1,x2,y1,y2)
r =xRoi(3,4,11,10);
assert(isequal(r.center,[7 7]));
assert(isequal(r.length,  [9 7]));
assert(isequal(r.tl,    [3 4]));
assert(isequal(r.br,    [11 10]));

%%% Odd dimensions

% Create from xRoi(x1,x2,y1,y2)
r = xRoi(1,1,4,6);
assert(isequal(r.center,[2 3]));
assert(isequal(r.length,  [4 6]));
assert(isequal(r.tl,    [1 1]));
assert(isequal(r.br,    [4 6]));

% Create from xRoi[x1,x2],[w,h])
r = xRoi([1,1],[4,6]);
assert(isequal(r.center,[2 3]));
assert(isequal(r.length,  [4 6]));
assert(isequal(r.tl,    [1 1]));
assert(isequal(r.br,    [4 6]));

% Create from xRoi([cx,cy],w,h)
r = xRoi([2,3],4,6);
assert(isequal(r.length,  [4 6]));
assert(isequal(r.tl,    [1 1]));
assert(isequal(r.br,    [4 6]));
assert(isequal(r.center,[2 3]));
