% this code calculates the Average Psi 6
tic;
%% Initialize variables
bias_voltage = [103 110 120 130 140];
% Radial cutoffs for nearest neighbors at each voltage found from g(r)
r = {0.255511,0.267535,0.288577,0.300601,0.318637,0.342685};
workspaces = {'103V','110V','120V','130V','140V'};
% Preallocate arrays to store PSI6 mean and std for each workspace
Psi6_mean = zeros(1,length(workspaces)); 
Psi6_std = zeros(1,length(workspaces));
% Create Directories to store Data and Figures
 mainFigDir = '';%your path here
 mainDataDir = '';%your path here
%% Loop through each workspace
for v = 1:length(workspaces) 
    % Load data for this workspace
    load(strcat(workspaces{v},'.mat'))
    Nf = length(Data);
    % Preallocate PSI6 array
    psiframe=zeros(Nf,1);
    ws = workspaces{v};
    Preallocate PSI6 array
    wsDir = fullfile(mainFigDir, ws, 'PSI6');
    if ~exist(wsDir, 'dir')
        mkdir(wsDir);
    end
    %Loop through frames
    for t = 1:Nf
        positions=Data(t).XY;
        [Np,d] = size(positions);
        psi6 = zeros(Np,Nf);
        p6 = zeros(Np,Nf);
        g6 = zeros(Np,1);
        B = [positions(:,1) positions(:,2)];
        mdl = KDTreeSearcher(B);
        idx = rangesearch(mdl,B,r{v});
        %loop through particles
        for i = 1:Np   
            pj_sum = 0;
            nj = 0;
            %if particle has neighbor
            if length(idx{i})>1
                tRef=0;
                dx = B(idx{i}(2),1)-B(i,1);
                dy = B(idx{i}(2),2)-B(i,2);
                theta0 = atan2(dy,dx);
    
                for k = 2:length(idx{i})
                    dx1 = B(idx{i}(k),1)-B(i,1);
                    dy1 = B(idx{i}(k),2)-B(i,2);
                    theta = atan2(dy1,dx1);
                    theta = theta0-theta;    % dtheta
                    pj = cos(6*(theta));
                    pj_sum = pj_sum +(pj);
                    nj = nj +1;
                end
                psi6(i,t) = abs(pj_sum/nj);
                
            end
        end
        x=B(:,1);
        y=B(:,2);
        psi=psi6(:,t);
        data=[x y psi];
        psiframe(t) = mean(psi6(:,t));
        %Write frame psi6 data to CSV
        filename = strcat(workspaces{v}, '_psi_',num2str(t),'.csv');
        fullpath = fullfile(mainDataDir, filename);
        writematrix(data,fullpath);
        particleFig = figure;
        scatter(B(:,1),B(:,2),50,psi6(:,t),"filled",'o')   % visualise particle level psi6
        xlabel('X')
        ylabel('Y')
        axis square;
        axis tight;
        colorbar();
        % Save figure
        fileName = sprintf('particle_%d.png', t);
        fullPath = fullfile(wsDir, fileName); 
        saveas(particleFig, fullPath);
        close(particleFig);
    end
    Psi6_mean(v) = mean(psiframe);
    Psi6_std(v) = std(psiframe);
end
%% Plot Ѱ6 vs Bias Voltage
subplot(2,2,1)
errorbar(bias_voltage, Psi6_mean, Psi6_std,'b', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'CapSize', 5, 'LineStyle', '-.','LineWidth',1); 
set(gca,'Fontsize',12,'Fontweight','bold')
xlabel('Bias Voltage(V)');
ylabel('\Psi_6');
ylim([0.35,0.7])
yline(0.55,'--', 'LineWidth', 1, 'Color', 'k')
time = toc; % Stop timer
fprintf('Total time: %f seconds\n', time);
