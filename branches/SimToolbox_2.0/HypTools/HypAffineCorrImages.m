function  HypAffineCorrImages(rawImageDir,imageRoot,corrImageDir,S_hyperspectral,width,height,type,originalPlatform,mccs,mccLocs)% HypAffineCorrImages(rawImageDir,imageRoot,corrImageDir,S_hyperspectral,width,height,type,originalPlatform,mccs,mccLocs)%% Use MCC data to correct images for veiling light.%% 10/28/97 dhb, jmk  Wrote it% 11/7/97  dhb, jmk  DO_AFFINE option passed% 01/28/00 pxl       Modified for more flexibility% 02/16/00 pxl       Added saving of the set of slpoe parameters%                    Added the possibility of reading a slope set%                    that is used instead of computed (useful if there is%                    no McBeth in the image. Deleted DO_AFFINE flag and%                    added COMPUTE_AFFINE instead.% 05/19/00 pxl       Deleted unused parts of the code%                    Changed some parameters  COMPUTE_AFFINE = 1;% Set range of squares to usemccSize = 6;refSize = 6;% Store current directoryprevDir = pwd;if (COMPUTE_AFFINE)  if (~isempty(mccs))    fprintf(1,'Loading MCC calibration data from %s directory\n',rawImageDir);    load mccRel  end  nMCC = max(size(mccs));  lineParams = zeros(S_hyperspectral(3),2);  mccRaw = zeros(S_hyperspectral(3),nMCC);  mccCorr = zeros(S_hyperspectral(3),nMCC);else  cd(rawImageDir);  load slopes  cd(prevDir);end% Loop over all the imagesfor i = 1:S_hyperspectral(3)  cd(rawImageDir);  theImage = SimReadRawImage([imageRoot num2str(S_hyperspectral(1)+(i-1)*S_hyperspectral(2))],width,height,type,originalPlatform);  cd(prevDir);  % Pull MCC data out of image  if (COMPUTE_AFFINE)    if (~isempty(mccs))      %    fprintf(1,'Get MCC data out of image\n');      mccImage = zeros(size(mccRel(1,mccs)'));      for k = 1:nMCCsave data	xCenter = mccLocs(k,1);	yCenter = mccLocs(k,2);	mccImage(k) = mean(mean(theImage(yCenter-mccSize/2:yCenter+mccSize/2,...					 xCenter-mccSize/2:xCenter+mccSize/2)));      end    end  end  if (size(mccs,2)~=0)    % Pull out reference data for this wavelength    %    fprintf(1,'Get reference MCC data\n');    mccRef = mccRel(i,mccs)';        % Fit best affine line to data    slopeInter = [mccRef ones(size(mccRef))]\mccImage;    fitMCC = [mccRef ones(size(mccRef))]*slopeInter;    lineParams(i,1) = slopeInter(1);    lineParams(i,2) = slopeInter(2);    % fprintf(1,'Slope = %g, intercept = %g \n',slopeInter(1),slopeInter(2));    % Correct image data with constant    corrMCC = mccImage - slopeInter(2);        % Compute corrected image    slopes(i) = round(slopeInter(2));    corrImage = theImage - round(slopes(i));    %    clear theImage    index = find(corrImage < 0);    corrImage(index) = zeros(size(index));    %    clear index  else    corrImage = theImage;  end  % Pull MCC data out of image  %    fprintf(1,'Get corrected MCC data\n');  if (COMPUTE_AFFINE)    mccImage = zeros(nMCC,1);    for k = 1:size(mccs,2)      xCenter = mccLocs(k,1);      yCenter = mccLocs(k,2);      mccImage(k) = mean(mean(corrImage(yCenter-mccSize/2:yCenter+mccSize/2,...					xCenter-mccSize/2:xCenter+mccSize/2)));    end    mccCorr(i,:) = mccImage';  end  % Write out the image  %    fprintf(1,'Write the image\n');  cd(corrImageDir);  SimWriteRawImage([imageRoot num2str(S_hyperspectral(1)+(i-1)*S_hyperspectral(2))],corrImage,type,originalPlatform);    cd(prevDir);  clear corrImageendif (COMPUTE_AFFINE)  % Save the fit parameters  fprintf(1,'Saving Stuff ...\n');  cd(corrImageDir);  save LineParams lineParams  if (~isempty(mccs))    mccData = mccCorr;    save mccData mccData    save mccLocs mccLocs mccSize    save slopes slopes  end  cd(prevDir);end