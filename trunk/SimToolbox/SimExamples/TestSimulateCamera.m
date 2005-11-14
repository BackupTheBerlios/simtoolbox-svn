% TestSimulateCamera%% Computes a simulated image, de-mosaices it, color-balances it, and renders it% Used to test the whole simulation process, can be modified to use as a batch% called function.%% 11/21/98  pxl  Wrote it.% 12/28/98  dhb  Changed name.  Cosmetic modifications.  Added comments.% 1/18/99   dhb  Make it work with various new conventions.% Copyright (c) 1999 David Brainard and Philippe Longere.   All rights reserved.% Clear outclear allclose allDISPLAY_IMAGES = 1;BALANCE_WITH_KNOWN = 1;% Define names.  Need to be careful to define% a reasonable camera for each image, otherwise% the resampling can produce strange looking % results.imageKey = 'bfgg';switch (imageKey)	case 'bfgg'		theImageName = 'BFGG_128';		theIllumName = 'BFGG';		theCameraName = 'kodakdcs200_50mm';		cameraDistance = 3;		exposureDuration = 0.5;		fStop = 5.6;	case 'bfgb',		theImageName = 'BFGB_128';		theIllumName = 'BFGB';		theCameraName =  'kodakdcs200_50mm';		cameraDistance = 3;		exposureDuration = 0.5;		fStop = 5.6;	case 'cacaphony',		theImageName = 'Cacaphony256';		theIllumName = 'cacaphony';		theCameraName = 'kodakdcs200_50mm_256';		cameraDistance = 2;		exposureDuration = 0.05;		fStop = 8;	case 'quantal',		theImageName = 'BFGG_128';		theIllumName = 'BFGG';		theCameraName =  'quantal_50mm';		cameraDistance = 3;		exposureDuration = 0.5;		fStop = 5.6;end% Define monitor.theMonitorName = 'Apple20in';% Define paths to find data.  If you create a new% folder with a unique name and put it on MATLAB's% path, then you can replace SimDefineImagePath% below with SimDefineImagePath(yourFolderName)% and things should work tranparently.[imagesRootDir,dirSep] = SimDefineImagePath;inputImageFile = [imagesRootDir theImageName dirSep theImageName '.Simg'];theCameraFile = [theCameraName '.Scam'];theMonitorFile = [theMonitorName '.Smon'];% Run basic simulation.  The displayed image shows the mosaic pattern% for the first three sensors.simulatedImage  = SimSimulateCamera(inputImageFile,theCameraFile,cameraDistance,exposureDuration,fStop);if (DISPLAY_IMAGES)	figure(1);	subplot(2,2,1);	imshow(Trunc(SimScale(simulatedImage.images(:,:,1:3))));	title('Simulated');	drawnow;end% Quick and dirty demosaic.  See TestDemosaic.m for% a more thorough example of demosaicing.  The displayed% image here maps the first three camera sensors into% display RGB, so it may look pretty funny.demosaicImage = SimFastLinearInterp(simulatedImage);if (DISPLAY_IMAGES)	figure(1);	subplot(2,2,2);	imshow(Trunc(SimScale(demosaicImage.images(:,:,1:3))));	title('Demosaiced');	drawnow;end% Color balancingeval(['load spd_' theIllumName]);eval(['theIllumSpd = spd_' theIllumName ';']);eval(['theIllumS = S_' theIllumName ';']);if (BALANCE_WITH_KNOWN)	estimatedImage = demosaicImage;	estimatedImage.estimatedIlluminant.spd = theIllumSpd;	estimatedImage.estimatedIlluminant.S = theIllumS;else	% Use GrayWorld to estimate the illuminant.  The plotting code	% depends on knowing that the wavelength sampling is [380 5 81],	% and should be generalized.  The plot in green shows the true	% illuminant, the red +'s the estimated.  The blue line shows the	% best fit of the true illuminant to the estimated, after scaling	% the true illuminant.  This free scale factor is related to the	% fact that our illuminant estimation algorithms don't take 	% exposure duration and fStop into account.	estimatedImage = SimGrayWorld(demosaicImage,'colorPriors');	if (DISPLAY_IMAGES)		figure(2);		plot(SToWls([380 5 81]),estimatedImage.estimatedIlluminant,'r+');		hold on	  plot(SToWls([380 5 81]),theIllumSpd,'g');		plot(SToWls([380 5 81]),theIllumSpd*(theIllumSpd\estimatedImage.estimatedIlluminant),'b');		hold off	endend% Re-render the image under D65 and for the human eye.  This is done% using standard linear model techniques.  You can override the surface% linear model used or the destination color space by passing more% arguments.  The displayed image here is pretty meaningless, since% XYZ tristimulus coordinates are just mapped into display RGB.load spd_D65Render;renderedImage = SimBalancing(estimatedImage,...	estimatedImage.estimatedIlluminant.S,estimatedImage.estimatedIlluminant.spd,...	S_D65Render,spd_D65Render);if (DISPLAY_IMAGES)	figure(1);	subplot(2,2,3);	imshow(Trunc(SimScale(renderedImage.images)));	title('Balanced');	drawnow;end% Render balanced image on monitor.  Algorithm is to produce an% image on the monitor that is metameric to the passed camera% image.monitorImage = SimRenderOnMonitor(renderedImage,theMonitorFile);if (DISPLAY_IMAGES)	figure(1);	subplot(2,2,4);	imshow(Trunc(SimScale(monitorImage.images)));	title('Monitor');	drawnow;end