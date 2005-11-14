function x = BCCFindXGrayWorldPos(y,colorPriors,sensors)% x = BCCFindXGrayWorldPos(y,colorPriors,sensors)%% Find the gray world illuminant estimate, constrained% to be all positive in spectral domain.%% 8/12/02  dhb  Wrote it.% 8/18/03  dhb, bx  Convert to new optimization toolbox routines.% Find mean sensor responseu_y = mean(y,2);u_surface_spd = colorPriors.sur.B*colorPriors.sur.u;RS = sensors.R*diag(u_surface_spd);% Set it up as a constrained least squares problemA = (RS*colorPriors.light.B);b = u_y;C = -colorPriors.light.B;d = zeros(size(colorPriors.light.B,1),1);options = optimset;options = optimset(options,'Diagnostics','off','Display','off');options = optimset(options,'LargeScale','off');x = lsqlin(A,b,C,d,[],[],[],[],[],options);