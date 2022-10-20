runs = 5;
n_range = 10000:1000:10000;
% n_range_alg2 = 1000:1000:1000;
h = 5;
k = 5;
Wden = 0.1;

time_SC = zeros(runs, length(n_range));
% time_Kalg = zeros(runs, length(n_range_alg2));
time_EED = zeros(runs,length(n_range));

for i = 1:length(n_range)
    n = n_range(i);

    fprintf('----------n = %d----------\n', n);

    for j = 1:runs
    fprintf('--------run = %d---------\n',j);

    % Testing on random Graph Laplacian
    W = sprand(n,n,Wden); 
    W = tril(W,-1);
    W = (W+W')/2;
    W = W.*~eye(size(W));
    D = diag(W*ones(n,1));
    F = rand(n,h-1);
    
    fprintf('-----alg1-----\n');
    fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
    tstart = tic;
    clusters1 = alg1(W,D,k);
    time_SC(j,i) = toc(tstart);
    
%     if i <= length(n_range_alg2)
%         fprintf('-----alg2-----\n');
%         tstart = tic;
%         clusters2 = alg2(W,D,F,k);
%         time_Kalg(j,i) = toc(tstart);
%     end
    
    fprintf('-----alg3-----\n');
    fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
    tstart = tic;
    clusters3 = alg3(W,D,F,k);
    time_EED(j,i) = toc(tstart);
    end
end


% writematrix(time_SC,strcat('alg1-h=',num2str(h),'-k='+num2str(k),'.txt'));
% writematrix(time_EED,strcat('alg3-h=',num2str(h),'-k=',num2str(k),'.txt'));

% figure(1);clf;
% plot(e1, 'bo', 'MarkerSize', 1);
% legend('Random Laplacian');
% xlabel('eig index'); 
% ylabel('eigval');
% title('eigs of L_n')
% 
% figure(2);clf;
% plot(e2, 'go', 'MarkerSize', 1);
% legend('Random Laplacian');
% xlabel('eig index'); 
% ylabel('eigval');
% title('eigs of L_n^{\sigma}')

% figure(1);clf;
% plot(n_range,mean(time_SC,1),'mo-.',n_range,mean(time_EED,1),'bx-')
% legend('SC (Alg. 1)','FAIR SC (EED, Alg. 3)', 'location', 'northwest')
% xlabel('n')
% ylabel('Running time [s]')
% title(strcat('k=',num2str(k),', h=',num2str(h), ', W density=',num2str(Wden), ' Random Graph Laplacian'), 'FontWeight','normal')

% figure(1);clf;
% plot(n_range,mean(time_SC,1),'mo-.',n_range,mean(time_SC2,1),'bx-', 'LineWidth', 3, 'MarkerSize', 12)
% legend('SC (Direct, Alg. 1)','SC (Afun, Alg. 1)', 'location', 'northwest')
% xlabel('n')
% ylabel('Running time [s]')
% title(strcat('h=',num2str(h),', k=',num2str(k), ', W density=',num2str(Wden), ' Random Graph Laplacian'), 'FontWeight','normal')