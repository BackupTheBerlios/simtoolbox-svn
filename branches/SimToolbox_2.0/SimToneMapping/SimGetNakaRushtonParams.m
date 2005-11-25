function x = SimGetNakaRushtonParams(input,output)
% x = SimGetNakaRushtonParams(input,output)
%
% Find the parameters x = [semi n] of the
% NakaRushton function such that
%   0 = SimNakaRushton(x,input,output)
%
% 5/25/04   dhb     Wrote it.

options = optimset;
options = optimset(options,'Diagnostics','off','Display','off','LargeScale','off');x0 = [mean(input) 1];
x = fsolve('SimNakaRushton',x0,options,input,output);