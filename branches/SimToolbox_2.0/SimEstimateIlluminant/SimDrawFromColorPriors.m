function [light_rand, sur_rand] = SimDrawFromColorPriors(colorPriors,N_beta)
% [light_rand, sur_rand] = SimDrawFromColorPriors(colorPriors,N_beta)
%
% Generate random draws from illuminant and surface priors with 
% positivity and physical contstraint.  Answer is returned in the
% form of weight vectors with respect to the prior bases.
%
% 8/22/03   bx       Wrote it
% 4/10/04   dhb      Get rid of plots, change name.

% Get light prior type
lightPriorType = colorPriors.light.priorType;

% Allocate space
light_rand = zeros(3,1);
sur_rand  = zeros(3,N_beta);
pTol = 0.2;
nGot = 0;

% Generate positive constrained draws from light priors
T_phys_light = 0;
while (T_phys_light == 0)
     est = MultiNormalDraw(1,colorPriors.light.u,colorPriors.light.K);
     switch (lightPriorType)
         case 'normalChrom',
            uvY = [est(1,:) ; est(2,:) ; 1];
            x = inv(colorPriors.light.MToXYZ)*uvYToXYZ(uvY);
         case  'truncNormalWeights',
            x = est;    
     end
     N_x =size(x,2);
     T_phys_light = BCCComputePosTerm(x,pTol,N_x,colorPriors.light.B); 
end
light_rand(:,1) = x;
     
% Generate positive constrained draws from surface priors
nGot = 0;
while (nGot <= N_beta)
 T_phys_sur = 0;
 while (T_phys_sur == 0)
     est = MultiNormalDraw(1,colorPriors.sur.u,colorPriors.sur.K);
     N_x =size(est,2);
     T_phys_sur = BCCComputePhysTerm(est,pTol,N_x,colorPriors.light.B);
 end  
 nGot = nGot+1;
 sur_rand(:,nGot) = est; 
end 
