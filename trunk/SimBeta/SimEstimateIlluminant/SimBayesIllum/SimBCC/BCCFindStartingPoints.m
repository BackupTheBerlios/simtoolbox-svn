function [theXs,theuvYs] = BCCFindStartingPoints(xStart0,xStart1,y,colorPriors,sensors,loss)% theXs,theuvYs] = BCCFindStartingPoints(xStart0,xStart1,y,colorPriors,sensors,loss)% % Find good starting points for the numerical search routines.%% 9/2/02  dhb  Pulled out of other routines.% 8/15/03 dhb  Convert xy chromaticity to uv.% Use MonteCarlo to find some valid starting pointsfprintf('\tFinding random starting points\n');maxIter = 2000;nRandom = 4;T_physical0 = BCCCheckXRealizable(xStart0,y,loss.pTol,colorPriors,sensors);if (T_physical0)	uvY = XYZTouvY(colorPriors.light.MToXYZ*xStart0);	[nil,xStart] = BCCEvaluateChromPosterior(uvY(1:2),y,3,30,colorPriors,sensors,loss);	theXs0 = [xStart BCCRandXRealizable(xStart,y,loss.pTol,colorPriors,sensors,loss,maxIter,nRandom)];else	theXs0 = [BCCRandXRealizable(xStart0,y,loss.pTol,colorPriors,sensors,loss,maxIter,nRandom)];endT_physical1 = BCCCheckXRealizable(xStart1,y,loss.pTol,colorPriors,sensors);if (T_physical1)	uvY = XYZTouvY(colorPriors.light.MToXYZ*xStart1);	[nil,xStart] = BCCEvaluateChromPosterior(uvY(1:2),y,3,30,colorPriors,sensors,loss);	theXs1 = [xStart BCCRandXRealizable(xStart,y,loss.pTol,colorPriors,sensors,loss,maxIter,nRandom)];else	theXs1 = [BCCRandXRealizable(xStart1,y,loss.pTol,colorPriors,sensors,loss,maxIter,nRandom)];endtheXs = [theXs0 theXs1];[nil,nXs] = size(theXs);fprintf('\tWill search from %g starting points\n',nXs);theuvYs = XYZTouvY(colorPriors.light.MToXYZ*theXs);		