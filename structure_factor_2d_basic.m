% load data give x and y
tic; % Start timer

sigma={0.182764,0.193463,0.20958,0.222093,0.239105,0.253353};%Interparticle distance calculated from g(r)
workspaces = {'103V','110V','120V','130V','140V','150V'}; %my files are named as 103V.mat and so on
for v =1: length(workspaces)
    load(strcat(workspaces{v},'.mat'))
    %% construct kvec
    dk = 2*pi/(20);  %smallest q in the system, step length
    disp(dk);
    kmax = dk*200;  % upto what q you want to calculate, calculate until it saturates to 1.
    disp(kmax);
    disp((2*kmax)/dk)
    Nk = floor(2*kmax/dk) + 1;   % make sure sqrt(kx**2+ky**2) is not out of range
    disp(Nk);
    ky = 0.15:dk:kmax;   %  a range of q bins
    kx = 0.15:dk:kmax;
    Nkx = length(kx);
    disp(Nkx);
    
    % all possible combis of [kx ky] 
    Nkx2 = Nkx*Nkx;
    K1 = zeros(Nk,1);
    
    
    % this is done to take all possible combinations of [kx ky]
    kx1=meshgrid(kx,ky);                    
    ky1=meshgrid(kx,ky)';
    
    kxvec= reshape(kx1,[Nkx2,1]);
    kyvec= reshape(ky1,[Nkx2,1]);
    kvec=[kxvec kyvec];                     % all combinations in 1D vector form
    
    
    %% Compute structure factor
    Nt = length(Data);%No. of frames for averaging
    AvgSF = zeros(Nk,2);
    Kmax = 0;
    kvmax=0;
    Ks=zeros(Nkx2,1);
    for t = 1 : Nt                         
        x=Data(t).XY(:,1)/sigma{4};%divide by sigma to non-dimensionalize
        y=Data(t).XY(:,2)/sigma{4};
        SF = zeros(Nk,2);
        fprintf('(ws,Nt)=%d\n',v,t);
        for kn = 1 : Nkx2 
            %All combinations of k values
            
            kx = kvec(kn,1);
            ky = kvec(kn,2);
            k = sqrt(kx*kx+ky*ky);
            kInd = floor((k-0.2121)/dk) + 1; 
            
            if(kInd < 0)
             fprintf('kInd=%d k=%f\t K1=%f\n',kInd,k,K1(kInd,1));
            end 
           % pause(1);
            
                   
            cosa = 0;
            sina = 0;
          
            for i = 1:length(x)
             cosa = cosa + cos(kx*x(i)+ ky*y(i)) ;
             sina = sina + sin(kx*x(i)+ ky*y(i)) ;
            end
    
            
            
            SF(kInd,1) = SF(kInd,1) + 1;   %adding the same k values
            SF(kInd,2) = SF(kInd,2) + cosa*cosa + sina*sina ;
          
        end
        
    
        SF(:,2) = SF(:,2)./SF(:,1);
        
        SF(:,2) = SF(:,2)./length(x);
       
        AvgSF(:,2) = AvgSF(:,2) + SF(:,2);
       
        
    end
    
    for kn =1:Nkx2
       kx = kvec(kn,1);
       ky = kvec(kn,2);
            
       k = sqrt(kx*kx+ky*ky);
       kInd = floor((k-0.2121)/dk)+1;
               
       K1(kInd,1)= k ;
    end 
    
    AvgSF(:,1)=K1;
    AvgSF(:,2) = AvgSF(:,2)/Nt;
    
    writematrix(AvgSF, strcat('ssf_v=',workspaces{v},'.txt'))
    figure;
    plot(AvgSF(:,1),AvgSF(:,2),'or-');
    ylabel('S(q)')
    xlabel('q')
    xlim([2,35])
    yline(1)

end
time = toc; % Stop timer
fprintf('Total time: %f seconds\n', time);
