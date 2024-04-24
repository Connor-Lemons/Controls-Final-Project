function stopscope
%======================================================================
%
%  stopscope
%
%  tries to close the com port connection to the telescope
%  this is needed before Matlab can reconnect to the telescope
%
%  inputs
%    none
%
%  outputs
%    none
%
%  modifications
%    2023-06-06 Scott Dahlke Written
%
%======================================================================

%---- set up global connection to telescope

global scope

%---- stop the scopedriver

% t = scope.t; stop(t); delete(t); % <= this works but below gets all timers
try                       %this suppresses the error if no timers are found
  stop(timerfind);
  delete(timerfind);
catch
end

%---- try closing scope connections (if any)
  
try    %suppress errors if no scope is currently connnected

  % reset com port as part of cleanup
  delete(scope.fid);

catch
end

fprintf('Telescope Disconnected\n');

end
