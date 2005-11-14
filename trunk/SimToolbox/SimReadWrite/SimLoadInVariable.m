function [what] = SimLoadInVariable(fileName)
% [what] = SimLoadInVariable(fileName)
%
% Load in the variable saved in a .mat file.
% This routine was kicking around and is needed
% by SimWeightRawImages.  We didn't ask too many
% questions.
%
% 8/8/03  dhb  Put it into the SimToolbox.
%         dhb  Force conversion to double after load.s

load(fileName);
variables = who;
for (k=1:size(variables,1))
  if (~isequal(variables{k},'fileName'))
    eval(['what = double(' variables{k} ');']);
  end
end