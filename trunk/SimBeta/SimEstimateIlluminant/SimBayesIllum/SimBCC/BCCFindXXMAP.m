function x = FindXXMap(xStart0,xStart1,y,colorPriors,sensors,loss)% x = FindXXMap(xStart0,xStart1,y,colorPriors,sensors,loss)%% Find the maximum of the marginal posterior on x.%% 1/16/94		dhb		Added this comment.% 11/7/94		dhb		Changed name. % 11/9/94		dhb		Try two starting guesses.% 11/10/94	dhb		    Return dim flat illuminant when no feasible%									solution is found.% 11/11/94	dhb		    Search unconstrained first to improve chances of%									finding a solution.% 12/14/94	dhb		    Assume that a feasible solution is passed.  This%										gets found in FindXPOS.% 12/29/94	dhb		    Unpack problem parameters.% 1/2/95		dhb		Re-wrote after FindXJMAP.% 1/3/95		dhb		Relax termination criteria to avoid infinite cycling.% 7/28/02   dhb         Changed input args to match modern FindXLM. % 9/2/02    dhb         Update call to BCCRandXPOS.% 8/15/03   dhb         Convert xy to uv.fprintf('BCCFindXXMAP:\n');% Find starting points[theXs,theuvYs] = BCCFindStartingPoints(xStart0,xStart1,y,colorPriors,sensors,loss);nXs = size(theXs,2);% Search options.  Set options(1) to 1 for printout.% Search options.  Set options(1) to 1 for printout.options = foptions;options(1) = 0;%options(2) = 5e-2;%options(3) = 5e-2;%options(4) = loss.pTol/10;%options(14) = 300;x0 = BCCLinearToPolarCC(theXs(:,1));[f0,g0] = BCCFindXXMAPFun(x0,y,colorPriors,sensors,loss);fprintf('\tStarting from uv = %g, %g\n',theuvYs(1,1),theuvYs(2,1));fprintf('\tInitial loss 1, f = %g, g = %g\n',f0,MatMax(g0));	x1 = constr('BCCFindXXMAPFun',x0,options,[],[],[],y,colorPriors,sensors,loss);[f1,g1] = BCCFindXXMAPFun(x1,y,colorPriors,sensors,loss);fprintf('\tAfter search, f = %g, g = %g\n\n',f1,MatMax(g1));	x = BCCPolarToLinearCC(x1);f = f1;g = MatMax(g1);% Now loop through and see if we can do better from somewhere else.	for i = 2:nXs	x0 = BCCLinearToPolarCC(theXs(:,i));	[f0,g0] = BCCFindXXMAPFun(x0,y,colorPriors,sensors,loss);	fprintf('\tStarting from uv = %g, %g\n',theuvYs(1,i),theuvYs(2,i));	fprintf('\tInitial loss %d, f = %g, g = %g\n',i,f0,MatMax(g0));		x1 = constr('BCCFindXXMAPFun',x0,options,[],[],[],y,colorPriors,sensors,loss);	[f1,g1] = BCCFindXXMAPFun(x1,y,colorPriors,sensors,loss);	fprintf('\tAfter search, f = %g, g = %g\n',f1,MatMax(g1));		if (f1 < f & MatMax(g1) < loss.pTol)		x = BCCPolarToLinearCC(x1);		f = f1;		g = MatMax(g1);		end	fprintf('\tBest loss so far, f = %g, g = %g\n\n',f,g);end