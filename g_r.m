function [g_filt ,r_filt] = g_r(x, y, dr,rmax)

N = length(x); % number of particles
L = max(x)-min(x); % box size (assume square box)
if nargin < 4
   rmax = L/2;
end
rho = N/L^2; % particle density
rvals = 0:dr:rmax; % r values to compute g(r) for
hw=L/2;


% Compute g(r)
g = zeros(size(rvals));
for i = 1:length(rvals)
    r = rvals(i);
    count = 0;
    for j = 1:N
         xj = x(j);
        yj = y(j);

  %Shift particle j to origin
  xshift = x - xj;
  yshift = y - yj;

  % Apply minimum image convention
  xshift(xshift > hw) = xshift(xshift > hw) - L;
  xshift(xshift < -hw) = xshift(xshift < -hw) + L;
  yshift(yshift > hw) = yshift(yshift > hw) - L; 
  yshift(yshift < -hw) = yshift(yshift < -hw) + L;

  % Compute distances
  d = sqrt(xshift.^2 + yshift.^2);

  % Count particles in shell
  count = count + sum((d > r) & (d < r+dr));
    end
    g(i) = count/(N*2*pi*r*dr*rho); 
end
r = rvals;
% Find Nan indices
nan_ind = isnan(g);

% Find Inf indices
inf_ind = isinf(g); 
            
% Combine indices
filter_ind = nan_ind | inf_ind;
            
% Filter g and r
g_filt = g(~filter_ind);
r_filt = r(~filter_ind);
end
