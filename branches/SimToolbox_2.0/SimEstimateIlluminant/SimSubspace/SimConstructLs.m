function L = SimConstructLs(s,Bs,Be,R)%% Construct that matrix that maps light weights% to sensor responses, given a surface vector.%% 1/13/94  dhb  Wrote it.% 12/31/98 dhb  Change name.% Copyright (c) 1999 David Brainard and Philippe Longere.   All rights reserved.sur = Bs*s;L = R*diag(sur)*Be;