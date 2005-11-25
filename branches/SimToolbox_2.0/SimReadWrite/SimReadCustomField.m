function [theStruct,buf] = SimReadCustomField(file,theStruct,buf)% [theStruct,buf] = SimReadCustomField(file,theStruct,[buf])%% Read a single field of simulator data.%% 1/18/99  dhb  Pulled it out of the loop in SimReadCustom%               so it can be used more generically.% 2/17/00  pxl  Added more precise error messages for debugging monitor files.  % Load buffer if not passed.if (nargin < 3)  buf = SimGetl(file);end% Syntax checkif (~strncmp(buf,'#Sim',4) & ~strncmp(buf,'##Sim',5))  error(sprintf(['ReadCustom: Are you sure your custom data are right?' ...		 '\n(got %s when expecting #SimEnd)'],buf));end% Either we are reading an algorithm to be used in the simulation,% or we are reading data.  Algorithms are signaled by the flag% #Sim#Alg, while anything else is data.% Algorithm.  We store the algorithm name in a list of algorithms% to be called by the simulator.if (strncmp(buf,'#Sim#Alg',8))  theStruct.numberAlgorithms = theStruct.numberAlgorithms+1;    theStruct.algorithms{theStruct.numberAlgorithms}=buf(10:end);  buf = SimGetl(file);% Table.  This has a scripted format and doesn't% need an end.elseif (strncmp(buf,'#Sim#',5))  field = SimOneDown(buf(6:end));  % Note that a table as at most 2 dimensions  x = fscanf(file,'%d',1);  y = fscanf(file,'%d',1);  for k=1:x    for l =1:y      % Note that tables are always read as double      % ['theStruct.'field '(k,l) = fscanf(file,''%e'',1);']      eval(['theStruct.' field '(k,l) = fscanf(file,''%e'',1);']);    end  end  buf=SimGetl(file); % Data structure.  The syntax ## indicates that we will read in a structure,% rather than simple numbers.elseif (strncmp(buf,'##Sim',5))  field = SimOneDown(buf(6:end));  buf=SimGetl(file);  while (strncmp(buf,'##Sim',5))    field2 = SimOneDown(buf(6:end));    fieldstring = [];    buf = SimGetl(file);    while (buf(1) ~= '#')      if (isempty(fieldstring))	fieldstring = buf;      else	fieldstring = [fieldstring ' ' buf];      end      buf = SimGetl(file);    end    eval(['theStruct.' field '.' field2 ' = SimImageStringToNumbers(fieldstring);']);    if (strncmp(buf,'##SimEnd',8))      buf = SimGetl(file);      break;    end  end  % Single fieldelse  field = SimOneDown(buf(5:end));  fieldstring = [];  buf = SimGetl(file);  while (buf(1) ~= '#')    if (isempty(fieldstring))      fieldstring = buf;    else      fieldstring = [fieldstring ' ' buf];    end    buf = SimGetl(file);  end  eval(['theStruct.' field ' = SimImageStringToNumbers(fieldstring);']);  if (strncmp(buf,'#SimEnd',7))    buf = SimGetl(file);  else    error(sprintf(['ReadCustomField: Are you sure your custom data are' ...		   ' right ? \n(got %s when expecting #SimEnd)'],buf));  endend