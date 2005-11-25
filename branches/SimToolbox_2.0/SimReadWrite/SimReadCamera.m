function [camera] = SimReadCamera(fileName)% [camera] = SimReadCamera(fileName)%% Reads a camera from the description file and fill the structure.% See documentation on camera specification strategy and sytle.%% Passed filename can be a file handle, to allow reading of% camera information from inside image file.%% 08/07/98	pxl	 Wrote it from the ancient version, making it more flexible.% 10/29/98  dhb  Added some comments, minor tidying.%           dhb  Replace isEqualN by strncmp.% 12/29/98  dhb  When data are expressed in Watts, read calibration exposure/fStop.% 1/13/99   dhb  Rewrite to parse more elegantly, at cost of imposing a little%                more structure on the camera field.%					  dhb  Handle trailing spaces on some key field specifications.% 1/19/99   dhb  Allow passed arg to be a file handle.%           dhb  Eliminate previously required header.%           dhb  Use generic reader.% 8/31/02   dhb  Handle case where fileName is already the camera structure.% 8/15/03   dhb  If S is specified as a S vector, make sure it is a row%                   vector.% Argument checkif (nargin < 1)	   error('ReadCamera: requires a filename.\n');end% Check for passed structureif (isstruct(fileName))	camera = fileName;	return;end% Open the fileif (isstr(fileName))	file = fopen(fileName,'r');	if (isequal(file,-1))		   error(sprintf('SimReadCamera: file %s not found.\n',fileName));	endelse	file = fileName;end% Read the file.camera = SimReadCustom(file,[]);  % Close the fileif (isstr(fileName))	fclose(file);end% Check that we got all mandatory fields.listOfRequired = strvcat('manufacturer','name',...	'numberSensors','wavelengthSampling','spectralSensitivity','unit',...  'height','width','lens','angularResolution');missing = SimCheckRequiredFields(camera,listOfRequired);if (~isempty(missing))	error(sprintf('ReadCamera: a mandatory field (%s) is not present',missing));end	% Make sure S vector is a row vector, if it is a vector at allif (~isstruct(camera.wavelengthSampling))    if (size(camera.wavelengthSampling,1) == 3 & size(camera.wavelengthSampling,2) == 1)        camera.wavelengthSampling = camera.wavelengthSampling';    endend% Reshape mosaic specification.  This code depends on knowing% the scan order of MATLAB matrices and also the order in which% strings are scanned by our reader/writer.  You probably don't want% to know, unless your mosaic is showing up wrong when you% go to use it.  In this case, here would be a good place to% look for an error.  See also matched code in the reader.if (camera.numberSensors > 1)	if (~isfield(camera,'spatialLayout'))		error('SimReadCamera: no spatial layout information present');	end	dims = camera.spatialLayout.dims;	camera.spatialLayout.mosaic = reshape(camera.spatialLayout.mosaic,dims(2),dims(1),dims(3));	temp = [];	for i1 = 1:dims(3)		temp(:,:,i1) = camera.spatialLayout.mosaic(:,:,i1)';	end	camera.spatialLayout.mosaic = temp;end% Handle unit specific informationswitch (camera.unit)	case 'Watts',		% Check for fields we need for these units		listOfRequired = strvcat('calFStop','calExposureTime');		missing = SimCheckRequiredFields(camera,listOfRequired);		if (~isempty(missing))			error(sprintf('ReadCamera: a mandatory field (%s) is not present',missing));		end		case 'Quanta',		% Check for fields we need for these units		listOfRequired = strvcat('pixelHeight','pixelWidth');		missing = SimCheckRequiredFields(camera,listOfRequired);		if (~isempty(missing))			error(sprintf('ReadCamera: a mandatory field (%s) is not present',missing));		end		otherwise,end