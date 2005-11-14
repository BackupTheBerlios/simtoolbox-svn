function output = SimNakaRushton(x,input,constant)
% output = NakaRushton(x,input,[constant])
%
% Compute the modified Naka-Rushton function:
%   output = (input.^n)./(input.^n + semi.^n) - constant;
%
% For compatibility with fsolve, this takes its input
% as a vector x = [semi n].
%
% Constant defaults to 0 if not passed or passed as empty.
%
% 5/21/04   dhb     Wrote it.
% 5/25/04   dhb     Mofify for use with fsolve

if (nargin < 3 | isempty(constant))
    constant = 0;
end
semi = x(1); n = x(2);
temp = input.^n;
output = (temp ./ (temp + (semi.^n)))-constant;
