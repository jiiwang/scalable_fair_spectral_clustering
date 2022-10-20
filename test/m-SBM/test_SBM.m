close all; clear;

anz_runs = 25;
n_range = 1000:1000:10000;
n_range_alg2 = 1000:1000:4000;

k = 5;                                                                                                          
h = 2;

af=10;
bf=7;
cf=4;
df=1;

time_SC = zeros(anz_runs,length(n_range));
time_Fair_SC_NULL = zeros(anz_runs,length(n_range_alg2));
time_Fair_SC_EED = zeros(anz_runs,length(n_range));

error_SC=zeros(anz_runs,length(n_range));
error_Fair_SC_NULL = zeros(anz_runs,length(n_range_alg2));
error_Fair_SC_EED = zeros(anz_runs,length(n_range));


for mmm = 1:length(n_range)
    
    n = n_range(mmm);
    
    a = af*(log(n)/n)^(2/3);
    b = bf*(log(n)/n)^(2/3);
    c = cf*(log(n)/n)^(2/3);
    d = df*(log(n)/n)^(2/3);
        
    fprintf('-----------------n = %d --------------------------------\n', n);
    
    block_sizes = (n/(k*h))*ones(1,k*h);
       
    sensitive = zeros(n,1);
    labels = zeros(n,1);
    for yyy = 1:k
        for zzz = 1:h
            sensitive(((n/k)*(yyy-1)+(n/(k*h))*(zzz-1)+1):((n/k)*(yyy-1)+(n/(k*h))*zzz)) = zzz;
            labels(((n/k)*(yyy-1)+(n/(k*h))*(zzz-1)+1):((n/k)*(yyy-1)+(n/(k*h))*zzz)) = yyy;
        end
    end
    
    for ell = 1:anz_runs
        
        fprintf('-----------------run = %d --------------------------------\n', ell);
        
        [W, D, F] = generate_SBM(n,a,b,c,d,k,h,block_sizes,sensitive);
            
%         nnzadja = nnz(W)/(n*n)

        tstart1 = tic;
        labelsalg1 = alg1(W, D, k);
        time_SC(ell,mmm) = toc(tstart1);
        error_SC(ell,mmm)=clustering_accuracy(labels,labelsalg1);
        
        if mmm<=length(n_range_alg2)
            tstart2 = tic;
            labelsalg2 = alg2(W, D, F, k);
            time_Fair_SC_NULL(ell,mmm) = toc(tstart2);
            error_Fair_SC_NULL(ell,mmm)=clustering_accuracy(labels,labelsalg2);
        end
        
        tstart3 = tic;
        labelsalg3 = alg3(W, D, F, k);
        time_Fair_SC_EED(ell,mmm) = toc(tstart3);
        error_Fair_SC_EED(ell,mmm)=clustering_accuracy(labels,labelsalg3);
    end
end

writematrix(time_SC,'alg1-h=2-k=5-SBM.txt');
writematrix(time_Fair_SC_NULL,'alg2-h=2-k=5-SBM.txt');
writematrix(time_Fair_SC_EED,'alg3-h=2-k=5-SBM.txt');
writematrix(error_SC,'alg1-h=2-k=5-SBM-err.txt');
writematrix(error_Fair_SC_NULL,'alg2-h=2-k=5-SBM-err.txt');
writematrix(error_Fair_SC_EED,'alg3-h=2-k=5-SBM-err.txt');
       
% set default sizes for figures:
ulesfontsize = 16;
set(0, 'DefaultAxesFontSize', ulesfontsize);
set(0, 'DefaultTextFontSize', ulesfontsize);
set(0, 'DefaultUIControlFontSize', ulesfontsize);
set(0,'DefaultLineMarkerSize',ulesfontsize);
set(0,'DefaultLineLineWidth',2.5) 
set(gcf, 'PaperPosition', [0 0 10 7.5])
set(gcf, 'PaperSize', [10 7.5]);

figure;clf;
plot(n_range, median(error_SC,1),'gs-.',...
    n_range_alg2, median(error_Fair_SC_NULL,1),'ro--',...
    n_range,median(error_Fair_SC_EED,1),'bx-')
legend({'SC', 'FairSC', 's-FairSC'}, 'Location','northwest', 'FontSize',9)
xlabel('n')
ylabel('Error')
ylim([0,1])
title(strcat('h=',num2str(h),', k=',num2str(k),' --- a,b,c,d ~ (log(n)/n)\^(',num2str(2),'/',num2str(3),')', ' --- SBM'),'FontWeight','normal')

figure;clf;
plot(n_range, mean(time_SC,1), 'gs-.',...
    n_range_alg2, mean(time_Fair_SC_NULL,1), 'ro--',...
    n_range,mean(time_Fair_SC_EED,1),'bx-',...
    n_range_alg2,1.2*(time_Fair_SC_NULL(1)/(n_range_alg2(1)^3))*n_range_alg2.^3,'m-','MarkerSize', 12)
legend({'SC', 'FairSC', 's-FairSC', '~ n^3'}, 'Location','northwest', 'FontSize',9)
xlabel('n')
ylabel('Running time (s)')
title(strcat('h=',num2str(h),', k=',num2str(k),' --- a,b,c,d ~ (log(n)/n)\^(',num2str(2),'/',num2str(3),')', ' --- SBM'),'FontWeight','normal')




