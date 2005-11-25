% TestReSample%% Test the resampling code by making sure that varying% various parameters has the expected effect.%% The current script tests a number of configurations% for which the correct answer is pretty clear.  More% situations could probably be added, but this did a% pretty good job of beating out bugs in SimReSample.%% To speed this us, you could replace the call% to SimSimulateCamera with one call to the% routine which weights the hyperspectral image% and then a series of calls to SimReSample.  Although% that would be faster, I'm not sure it would be as% useful as an example.%% No balancing or rendering is done.%% 1/4/98  dhb  Wrote it from earlier scripts.% 1/18/99 dhb  Make it work with various new conventions.% Copyright (c) 1999 David Brainard and Philippe Longere.   All rights reserved.% Clear outclear allclose all% Define namestheImageName = 'BFGG_128';theIllumName = 'BFGG';theCameraName = 'KodakDCS200_50mm';exposureDuration = 0.5;fStop = 5.6;% Define paths to find data[imagesRootDir,dirSep] = SimDefineImagePath;inputImageFile = [imagesRootDir theImageName dirSep theImageName '.Simg'];theCameraFile = [theCameraName '.Scam'];% Read the base information, which we will muck% with for various test conditions.rawInputImage = SimReadImage(inputImageFile); rawInputCamera = SimReadCamera(rawInputImage.cameraFile);rawOutputCamera = SimReadCamera(theCameraFile);% Set input and output resolution the same.% Should get same image size back as we put in.theImage = rawInputImage;theInputCamera = rawInputCamera;theOutputCamera = rawOutputCamera;theOutputCamera.height = rawInputImage.height;theOutputCamera.width = rawInputImage.width;theOutputCamera.angularResolution = theInputCamera.angularResolution;theImage.cameraFile = theInputCamera;cameraDistance = rawInputImage.inputCameraDistance;simulatedImage  = SimSimulateCamera(theImage,theOutputCamera,cameraDistance,exposureDuration,fStop);demosaicImage = SimQuickInterp(simulatedImage);figure(1);[temp,scaleMin,scaleMax] = SimScale(demosaicImage.images(:,:,1:3));imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3),scaleMin,scaleMax)));title('Matched to input');drawnow;% Halve the distance to simulated camera.theImage = rawInputImage;theInputCamera = rawInputCamera;theOutputCamera = rawOutputCamera;theOutputCamera.height = rawInputImage.height;theOutputCamera.width = rawInputImage.width;theOutputCamera.angularResolution = theInputCamera.angularResolution;theImage.cameraFile = theInputCamera;cameraDistance = rawInputImage.inputCameraDistance/2;simulatedImage  = SimSimulateCamera(theImage,theOutputCamera,cameraDistance,exposureDuration,fStop);demosaicImage = SimQuickInterp(simulatedImage);figure(2);imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3),scaleMin,scaleMax)));title('Half distance');drawnow;% Double the distance to simulated camera.theImage = rawInputImage;theInputCamera = rawInputCamera;theOutputCamera = rawOutputCamera;theOutputCamera.height = rawInputImage.height;theOutputCamera.width = rawInputImage.width;theOutputCamera.angularResolution = theInputCamera.angularResolution;theImage.cameraFile = theInputCamera;cameraDistance = rawInputImage.inputCameraDistance*2;simulatedImage  = SimSimulateCamera(theImage,theOutputCamera,cameraDistance,exposureDuration,fStop);demosaicImage = SimQuickInterp(simulatedImage);figure(3);imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3),scaleMin,scaleMax)));title('Double distance');drawnow;% Asymmetric pixels, starting with half distancetheImage = rawInputImage;theInputCamera = rawInputCamera;theOutputCamera = rawOutputCamera;theOutputCamera.height = rawInputImage.height;theOutputCamera.width = rawInputImage.width*2;theOutputCamera.angularResolution = theInputCamera.angularResolution;theImage.cameraFile = theInputCamera;cameraDistance = rawInputImage.inputCameraDistance/2;simulatedImage  = SimSimulateCamera(theImage,theOutputCamera,cameraDistance,exposureDuration,fStop);demosaicImage = SimQuickInterp(simulatedImage);figure(4);imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3),scaleMin,scaleMax)));title('Asymmetric, half distance');drawnow;% Asymmetric pixels, full distance.% Comes out square, because width is% truncated on output camera.  This% is counterintuitive but correct.theImage = rawInputImage;theInputCamera = rawInputCamera;theOutputCamera = rawOutputCamera;theOutputCamera.height = rawInputImage.height;theOutputCamera.width = rawInputImage.width*2;theOutputCamera.angularResolution = theInputCamera.angularResolution;theImage.cameraFile = theInputCamera;cameraDistance = rawInputImage.inputCameraDistance;simulatedImage  = SimSimulateCamera(theImage,theOutputCamera,cameraDistance,exposureDuration,fStop);demosaicImage = SimQuickInterp(simulatedImage);figure(5);imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3),scaleMin,scaleMax)));title('Asymmetric');drawnow;% Asymmetric pixels, double angular resolutiontheImage = rawInputImage;theInputCamera = rawInputCamera;theOutputCamera = rawOutputCamera;theOutputCamera.height = rawInputImage.height;theOutputCamera.width = rawInputImage.width*2;theOutputCamera.angularResolution.x = theInputCamera.angularResolution.x*2;theOutputCamera.angularResolution.y = theInputCamera.angularResolution.y*2;theImage.cameraFile = theInputCamera;cameraDistance = rawInputImage.inputCameraDistance;simulatedImage  = SimSimulateCamera(theImage,theOutputCamera,cameraDistance,exposureDuration,fStop);demosaicImage = SimQuickInterp(simulatedImage);figure(6);imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3),scaleMin,scaleMax)));title('Asymmetric, double angular resolution');drawnow;