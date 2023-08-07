% This code computes the average Pair correlation function and plots the
% ... Interparticle distance vs voltage in
clear variables; close all

%% initialize Variables
ravg = [];
rstd = [];
bias_voltage = [103 110 120 130 140];
% List of workspace names
workspaces = {'103V','110V','120V','130V','140V'}; 
Rmax=330;%limit for peak
%% Loop over workspaces
for v = 1:length(workspaces)
    % Load data 
    load(strcat(workspaces{v},'.mat'))
    r_max = [];%Initialize array for storing Inter))particle distance
    %Get number of frames
    numFrames = length(Data);
    % Extract positions from each frame
    Scale= 1000/40;
    dr = 0.5*Scale;
    % Set maximum r distance
    rmax = 1500; 
    num_interp = 500;
    % Interpolation points
    r_interp = linspace(0, rmax, num_interp);
    g_avg = zeros(size(r_interp));
        for i = 1:numFrames
            
            fprintf('(ws,Nt)=%d\n',v,i);
            positions=Data(i).XY*1000;
            % Calculate g(r)
            [g, r] = g_r(positions(:,1), positions(:,2), dr,rmax);
            r_limit = r(r <= Rmax); 
            g_limit = g(r <= Rmax);
            if std(r_max)/mean(r_max) > 0.05
                warning('g(r) max may not have converged'); 
            end
            
            % Find max
            [~,ind] = max(g_limit);
            r_max_peak = r_limit(ind);
            g_peak = g_limit(ind);
            %%  find peaks
            % Fit Gaussian to the peak
            gaussFit = fit(r_limit(:), g_limit(:), 'gauss1'); 

            % Extract Gaussian parameters
            peakMean = gaussFit.b1;
            peakStdDev = gaussFit.c1 / sqrt(2);

            % Compute interparticle distance using the mean of the fitted Gaussian
            r_max(end+1) = peakMean;
            % Interpolate  
            g_interp = interp1(r, g, r_interp,'spline'); 
            
            % Accumulate average
            g_avg = g_avg + g_interp;
        
        end
    % Compute stats
    ravg(end+1) = mean(r_max);
    rstd(end+1) = std(r_max);
    g_avg = g_avg / numFrames;

  % Save averaged g(r)
  g_avg_list{v} = g_avg;

end
%% Save G_avg
for v=1:length(workspaces)
    filename = strcat(workspaces{v}, '_gavg_.csv');
    writematrix(g_avg_list{v}, filename);
end
%% Create figure with subplots
figure;
numPlots = length(workspaces);
for i = 1:numPlots-1
    subplot(5,1,i)
    
    % Get current workspace
    ws = workspaces{i};
    
    % Get g_avg and r_interp for current workspace
    g_avg = g_avg_list{i}; 
    r_interp = linspace(0, rmax, num_interp);
    % Plot g_avg vs r_interp
    plot(r_interp, g_avg,'LineWidth',1,'Color','b') 
    ylim([0,7]);
    yline(1,'LineWidth',1,'Color','k')
    % Label subplot
    title(ws,'Position',[1420 4 0])
    xlabel('r(μm)')
    ylabel('g(r)')
    set(gca,'XTick',[],'XColor','none','Fontsize', 12, 'Fontweight', 'bold') % Hide x-axis
end
subplot(5,1,5)
g_avg = g_avg_list{5}; 
r_interp = linspace(0, rmax, num_interp);
% Plot g_avg vs r_interp
plot(r_interp, g_avg,'LineWidth',1,'Color','b') 
ylim([0,7]);
yline(1,'LineWidth',1,'Color','k')
% Label subplot
title('140V','Position',[1420 4 0])
xlabel('r(μm)')
ylabel('g(r)')
set(gca,'Fontsize', 12, 'Fontweight', 'bold')
linkaxes([subplot(5,1,1) subplot(5,1,2) subplot(5,1,3) subplot(5,1,4) subplot(5,1,5)],'x');
%% Plotting Interparticle Distance (D) vs Bias Voltage 
figure;
subplot(2,2,1)
errorbar(bias_voltage, ravg, rstd,'b', 'MarkerSize', 2, 'MarkerFaceColor', 'b', 'CapSize', 10, 'LineStyle', '-.','LineWidth',1); 

set(gca,'fontsize',12,'Fontweight','bold')
xlabel('Bias Voltage(V)');
ylabel('D(μm)');
title('Interparticle distance vs Voltage')