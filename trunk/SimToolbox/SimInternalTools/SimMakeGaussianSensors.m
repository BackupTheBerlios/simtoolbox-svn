function R = SimMakeGaussianSensors(params,S)% R = SimMakeGaussianSensors(params,S)%% Make up a set of sensors with Gaussian% spectral sensitivities.%% Sensors are parametersized by an N by 2 % matrix.  First column gives mean, second% gives standard deviations.%% S gives the wavelength sampling.%% 10/16/98  dhb  Wrote it.nSensors = size(params,1);wls = MakeItWls(S);R = zeros(nSensors,size(wls,1));for i = 1:nSensors	R(i,:) = normpdf(wls,params(i,1),params(i,2))';end