function [S,Mag,Phase]=MagPhase(sys,s)
%
% Evaluates a transfer function at a complex point in the s plane
%
% Usage:  [S, Mag, Phase] = MagPhase(sys,stest)
% inputs
%     sys is the tranfer function
%     stest is the s-plane point at which to evaluate sys
% outputs
%     S is the complex evaluation
%     Mag is the magnitude of S
%     Phase is the phase of S in degrees
%
%  R.J. Lisowski - Feb 2004
%
S=evalfr(sys,s);
Mag=abs(S);
Phase=180/pi*angle(S);