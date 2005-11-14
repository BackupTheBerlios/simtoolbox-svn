function theCamera = SimMakeConesCamera(T_cones,S_cones)
% theCamera = SimMakeConesCamera(T_cones,S_cones)
%
% Create description of human eye as a camera. Useful
% for crunching a hyperspectral image into an LMS image.
%
% 5/27/04   dhb, bx     Pulled out of RenderToolbox code.

% Dummy up a camera file for reducing hyperspectral
% image to a cone image.
theCamera.numberAlgorithms = 1;
theCamera.manufacturer = 'WhoKnows';
theCamera.name = 'HumanCones';
theCamera.numberSensors = 3;
theCamera.wavelengthSampling.start = S_cones(1);
theCamera.wavelengthSampling.step = S_cones(2);
theCamera.wavelengthSampling.numberSamples = S_cones(3);
theCamera.spectralSensitivity = T_cones;
theCamera.unit = 'Watts';
theCamera.calFStop = 5.6000;
theCamera.calExposureTime = 1;
theCamera.spatialLayout.dims = 3;
theCamera.spatialLayout.mosaic = zeros(1,1,3);
theCamera.spatialLayout.mosaic(:,:,1) = 1;
theCamera.spatialLayout.mosaic(:,:,1) = 2;
theCamera.spatialLayout.mosaic(:,:,1) = 3;
theCamera.height = 3000;
theCamera.width = 3000;
theCamera.algorithms = {'SimWeightRawImages'};
theCamera.comments = 'Dummy human cones camera';