function a = rlspecs(gp,OS,Tr,BW,Ts,contour)
%Plots root locus of gp adding OS, Tr, Ts and BW regions
% based on Rules of Thumb Approximations
% The actual constant 10-90% Rise Time curve can also be displayed
%
% Original Code   : Annonymous Astro Instructor  Date Uncertain
% OS Scaling Mod  : Dr Ron Lisowski              ??? 2001 
% Scaling & Tr Mod: Dr Ron Lisowski              Feb 2004
% Bandwidth Mod   : Dr Ron Lisowski              May 2004
% Take "yesno" as argument : Lt Col Mike Sobers  Feb 2016
% Added shading of regions : Lt Col Mike Sobers  Feb 2016
%
% Invoke by typing rlspecs(gp, OS, Tr, Ts)
% where gp is the o.l. transfer function
%      OS is %overshoot (e.g 10% OS is 10)
%      Tr is rise time (sec)
%      BW is setting time (rad/sec)
%      Ts is setting time (sec)
%You can leave out the BW & Ts spec if you don't have either
%If you have Ts but not BW, set BW to 0 & include Ts
%
%Possible calls:
%rlspecs(gp,OS,Tr);
%rlspecs(gp,OS,Tr,BW);
%rlspecs(gp,OS,Tr,BW,Ts);
%rlspecs(gp,OS,Tr,0,Ts);
%rlspecs(gp,OS,Tr,0,Ts,'n'); to plot without asking for Tr & Bw contours
%locs=rlspecs(gp,OS,Tr); to return a vector of the calculated 
%    s-plane spec characteristics used to plot

Alpha = 0.25;  % Sets transparency on keep-out regions

if nargin < 6
    disp('Would you like to display the actual');
    yesno=input('  constant Tr & BW contours? y=yes,n=no: ','s');
else
    yesno = contour;
end

zet = -log(OS/100)/sqrt(pi^2+log(OS/100)^2);
sigma = 3.3/Tr;
wd = pi/(2*Tr);
wn=0;

%Some Automatic Axis Scaling Based on RL Plot and Spec Boundaries, RJ Lisowski
if nargin >3, wb = BW; else wb = 0; end;
[r,k]=rlocus(gp);
maxlen=max(norm([r(:,1) ; -sigma+j*wd ; -wb*1.55+j*wb*.72]));
gscale=tf([1 sqrt(2)*maxlen maxlen],[1 sqrt(2)*maxlen maxlen]);
rlocus(gscale,'w',gp,'b');
axis equal;
hold on;


% Overshoot Line (constant zeta)
% Cloned from sgrid to square up and rescale axes, RJ Lisowski
    ax = gca;
    NanMat = NaN;
    limits = 5*[get(ax,'XLim') get(ax,'YLim')];
    [w,z] = meshgrid([0;wn(:);1.0*max(limits(:))]',zet);
        w = w';
        z = z';
    [mcols, nrows] = size(z);
        NanRow = NanMat(ones(1,nrows));
    re = [-w.*z; NanRow];
        re = re(:);
    im = [w.*sqrt(ones(mcols,nrows) -z.*z); NanRow];
        im = im(:);
    plot([re; re],[im; -im],'LineStyle','--','Color','r');
    p = patch([0 re(3) 0 0 0 re(3) 0],[0 -im(3) -im(3) 0 im(3) im(3) 0],'r');
    set(p,'FaceAlpha',Alpha,'EdgeAlpha',0); 
%End of cloning
   
%Rise Time Box
x=[-sigma+0j,-sigma+wd*j];
y=[0+0j,0+wd*j];
z=[0+wd*j,-sigma+wd*j];
hold on
plot(real(x),imag(x),'r--',real(y),imag(y),'r--',real(z),imag(z),'r--')
plot(real(x),-imag(x),'r--',real(y),-imag(y),'r--',real(z),-imag(z),'r--')
a=[acos(zet)*180/pi,sigma,wd];
p = patch([-sigma -sigma 0 0],[-wd wd wd -wd],'r');
set(p,'FaceAlpha',Alpha,'EdgeAlpha',0); 

%Calc and plot "Real" Tr contour, RJ Lisowski
if lower(yesno)=='y'
 [Sig_Wd]=RealTr(Tr);
 plot(Sig_Wd(:,1),Sig_Wd(:,2),'r:');
end

%Bandwidth contour, RJ Lisowski
if nargin > 3

%Bandwidth Box
sigmab=BW*1.55;
wdb=BW*.72;
x=[-sigmab+0j,-sigmab+wdb*j];
y=[0+0j,0+wdb*j];
z=[0+wdb*j,-sigmab+wdb*j];
hold on
plot(real(x),imag(x),'g--',real(y),imag(y),'g--',real(z),imag(z),'g--')
plot(real(x),-imag(x),'g--',real(y),-imag(y),'g--',real(z),-imag(z),'g--')

%Calc and plot "Real" Tr contour, RJ Lisowski
if lower(yesno)=='y'
 [Sig_Wd]=BWCurve(BW);
 plot(Sig_Wd(:,1),Sig_Wd(:,2),'g:');
end
end

%Settling Time Line (4 Time Constants)
if nargin > 4
   sigTs = 4/Ts;
   x=[-sigTs-.9*limits(4)*j,-sigTs+.9*limits(4)*j];
   hold on
   plot(real(x),imag(x),'r--');
   % Shade keep-out regions
   p = patch([real(x) 0 0],[imag(x) -imag(x)],'r');
   set(p,'FaceAlpha',Alpha,'EdgeAlpha',0);
   a=[acos(zet)*180/pi,sigma,wd,sigTs];
end;

%
% Local Functions
%

%Calculate data for Tr curve
function [Sig_Wd]=RealTr(Tr)
z_wn = [  0 1.0/Tr;   ...
         .1 1.104/Tr; ...
         .2 1.203/Tr; ...
         .3 1.321/Tr; ...
         .4 1.463/Tr; ...
         .5 1.638/Tr; ...
         .6 1.854/Tr; ...
         .7 2.126/Tr; ...
         .8 2.467/Tr; ...
        .85 2.675/Tr; ...
         .9 2.883/Tr; ...
       .925 2.988/Tr; ...
        .95 3.092/Tr; ...
       .975 3.196/Tr; ...
      .9875 3.248/Tr; ...
        1.0 3.3/Tr];
for i=1:31,
 if i<17,
  Sig_Wd(i,:) = [-z_wn(i,1)*z_wn(i,2) z_wn(i,2)*sqrt(1-z_wn(i,1)^2)];
 else
  Sig_Wd(i,:) = [-z_wn(32-i,1)*z_wn(32-i,2) -z_wn(32-i,2)*sqrt(1-z_wn(32-i,1)^2)];
 end;
end;

%Calculate data for BW curve
function [Sig_Wd]=BWCurve(BW)
zeta = [  0 .1  .2  .3  .4  .5   .6     .7 ...
         .8 .85 .9 .925 .95 .975 .9875 1.0 ];
for i=1:31
 if i<17,
  z=zeta(i)^2;
  wn = BW/sqrt((1-2*z)+sqrt(4*z^2-4*z+2));
  Sig_Wd(i,:) = [-zeta(i)*wn wn*sqrt(1-zeta(i)^2)];
 else
  z=zeta(32-i)^2;
  wn = BW/sqrt((1-2*z)+sqrt(4*z^2-4*z+2));
  Sig_Wd(i,:) = [-zeta(32-i)*wn -wn*sqrt(1-zeta(32-i)^2)];
 end;
end;


