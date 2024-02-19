function TravelTime = getFromPath(PathPoints,W_x,W_y,Sp,sizeX,sizeY,METHOD)

if isvector(PathPoints)
    PathPoints = [0 sizeY/2; reshape(PathPoints,2,[])'; sizeX sizeY/2];
    PathPoints = WayPoints_To_Path(PathPoints,METHOD,sizeX,sizeY,101);
end

dP = diff(PathPoints);
V_wind = [interp2(W_x,PathPoints(1:end-1,1)+1,PathPoints(1:end-1,2)+1,'linear') interp2(W_y,PathPoints(1:end-1,1)+1,PathPoints(1:end-1,2)+1,'*linear')];
V_add = (sum(V_wind.*dP,2))./sqrt(sum(dP.^2,2));
dx = sqrt(sum(dP.^2,2))*100; %dx is the length of each subinterval in PathPoints
dt = dx./(Sp+V_add);  %dT = dP/dV
TravelTime = sum(dt);