function Kout = BCCExpandCov(Kin,nExpand)% Kout = BCCExpandCov(Kin,nExpand)%% Make a block diagonal covariance matrix out of the input% covariance matrix Kin.%% 11/08/98     pxl		Changed names of functions% Copyright (c) 1999 David Brainard and Philippe Longere.   All rights reserved.[m,null] = size(Kin);Kout = zeros(m*nExpand,m*nExpand);for i = 1:nExpand  Kout((i-1)*m+1:i*m,(i-1)*m+1:i*m) = Kin;end