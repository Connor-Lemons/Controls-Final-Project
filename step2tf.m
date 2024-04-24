function [G,z,p,k]=step2tf(time,input,output,np,nz,plt)
%======================================================================
%  
%  [G,z,p,k]=step2tf(time,input,output,np,nz,plt)
%
%  given a step response with equally spaced times, this will estimate the
%  poles, zeros and gain
%
%  needs system identification toolbox (it will notify the user if it is
%  absent)
%
%  inputs
%    time   - an array of times
%    input  - an array of input values
%    output - an array of ouput values
%    np     - number of poles the system has
%    nz     - number of zeros the system has
%    plt    - 0 = don't plot the results; 1 = cplot the results vs data
%
%  outputs
%    G - resulting transfer function
%    z - estimated zeros
%    p - estimated poles
%    k - estimated gain
%
%  modifications
%    2023-06-06 Scott Dahlke Written
%
%======================================================================

% format the time, input and output arrays into iddata object
%   the 3rd element is sampling time
data=iddata(output,input,time(2)-time(1));

% estimate the transfer function
warning('off','Ident:estimation:transientDataCorrection');
G=tfest(data,np,nz);

% extract the zeros, poles and gain
[z,p,k]=tf2zp(G.Numerator,G.Denominator);

% if requested, plot the data and the tf
if plt == 1
  step(G);
  hold on
  plot(time,output./input,'r');
  hold off
end

end