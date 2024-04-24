function bodespecs(gp,OS,Tr,BW,Mp)
%Plots Bode plot of gp adding OS, Tr, BW & Mp regions.
%Uses 2nd order approximations and Rules of Thumb
%invoke by typing bodespecs(G, OS, Tr, BW, Mp)
%where gp is the o.l. transfer function
%      OS is %overshoot (e.g 10% OS is 10)
%      Tr is rise time (sec)
%      BW is Bandwidth (rad/sec)
%      Mp is Resonant Peak (db)
%You can leave out the Mp spec if you don't have one or
%You can leave out both the Bw and Mp spec if you don't have them
%
%modified: Scott Dahlke 20224-01-20 (improved %OS freq estimate)
%
%Possible calls:
%bodespecs(gp,OS,Tr)
%bodespecs(gp,OS,Tr,BW)
%bodespecs(gp,OS,Tr,BW,Mp)

%Get Bode Data
[m,p,w] = bode(gp);

%Rule of Thumb for Rise Time
W1Tr = 1.3/Tr; 
fprintf(1,'Crossover freq must be > %5.2f rad/sec to meet Rise Time spec\n',W1Tr);
   
% Equations for % Overshoot
zet = -log(OS/100)/sqrt(pi^2+log(OS/100)^2);
PhMar = atan(2*zet/sqrt(-2*zet^2+sqrt(1+4*zet^4)))*180/pi;
ph = PhMar - 180;
if p(length(w)) > ph
   wPM = w(length(w));
else
   j = 1;
   while ph < p(j)
         j = j + 1;
   end
   wPM = interp1([p(j-1),p(j)], [w(j-1),w(j)],ph);
end
fprintf(1,'Crossover freq must be < %5.2f rad/sec to meet %% Overshoot spec\n',wPM);

%Rule of Thumb for BW
if nargin > 3
   W1BW = BW / 1.54;
fprintf(1,'Crossover freq must be > %5.2f rad/sec to meet BW spec\n',W1BW);
end;   

%Rule of Thumb & Equations for Resonant Peak
if nargin > 4
ResPk = 10^(Mp/20);
PhMar = asin(1/ResPk)*180/pi;
ph = PhMar - 180;
if p(length(w)) > ph
   wMP = w(length(w));
else
   j = 1;
   while ph < p(j)
         j = j + 1;
   end
   wMP = w(j);
end
fprintf(1,'Crossover freq must be < %5.2f rad/sec to meet Resonant Peak spec\n',wMP);
end   


%Now start Plotting
bode(gp);

%Get handles for subplot objects
handl=get(gcf);

% Child 3 is the Mag Plot, Child 1 is the Phase Plot

%Plot Tr Specs
for i=2:3
%   subplot(handl(i));
  subplot(handl.Children(i));
  ax = gca;
  yTr = get(ax,'YLim')-1;
  xTr = [W1Tr W1Tr];
  hold on;
  grid on;
  semilogx (xTr,yTr,'->r','LineWidth',2);
end
    
%Plot PO Specs
for i=2:3
%   subplot(handl(i));
  subplot(handl.Children(i));
  ax = gca;
  yPM = get(ax,'YLim')-1;
  xPM = [wPM wPM];
  hold on;
  semilogx (xPM,yPM,'-<g','LineWidth',2);
end

%Plot BW Specs
if nargin > 3
for i=2:3
%   subplot(handl(i));
  subplot(handl.Children(i));
  ax = gca;
  yBW = get(ax,'YLim')-1;
  xBW = [W1BW W1BW];
  hold on;
  semilogx (xBW,yBW,'->m','LineWidth',2);
end
end

%Plot Mp Specs
if nargin > 4
for i=2:3
%   subplot(handl(i));
  subplot(handl.Children(i));
  ax = gca;
  yMP = get(ax,'YLim')-1;
  xMP = [wMP wMP];
  hold on;
  semilogx (xMP,yMP,'-<b','LineWidth',2);
end
end   

