function PathPoints = WayPoints_To_Path(p,METHOD,sizeX,sizeY,fss)

nP = size(p,1);
PathPoints = [interp1(1:nP,p(:,1),linspace(1,nP,fss)',METHOD,'extrap') interp1(1:nP,p(:,2),linspace(1,nP,fss)',METHOD,'extrap')];
PathPoints(:,1) = min(PathPoints(:,1),sizeX);
PathPoints(:,1) = max(PathPoints(:,1),0);
PathPoints(:,2) = min(PathPoints(:,2),sizeY);
PathPoints(:,2) = max(PathPoints(:,2),0);
