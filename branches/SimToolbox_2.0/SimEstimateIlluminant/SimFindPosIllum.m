function [x] = SimFindPosIllum(illum,B_illum)% [x] = SimFindPosIllum(illum,B_illum)%% Find the best fit the the illuminant within the passed linear model,% subject to the constraint that the weights be positive.%% Just use constrained search.%% 4/16/99  dhb  Wrote it.% Copyright (c) 1999 David Brainard and Philippe Longere.   All rights reserved.% Find initial guess through regression.x0 = B_illum\illum;% Use MATLAB's constrained search.options = foptions;options(1) = 0;x = constr('SimFindPosIllumFun',x0,options,[],[],'',illum,B_illum);