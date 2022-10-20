runs = 5;
n_range = 10000:1000:10000;
% n_range_alg2 = 1000:1000:1000;
h = 5;
k = 5;
Wden = 0.1;

time_SC = zeros(runs, length(n_range));
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
    
    
    fprintf('-----alg3-----\n');
    fprintf('Current time %s\n', datestr(now,'HH:MM:SS.FFF'));
    tstart = tic;
    clusters3 = alg3(W,D,F,k);
    time_EED(j,i) = toc(tstart);
    end
end


writematrix(time_SC,strcat('alg1-h=',num2str(h),'-k='+num2str(k),'.txt'));
writematrix(time_EED,strcat('alg3-h=',num2str(h),'-k=',num2str(k),'.txt'));