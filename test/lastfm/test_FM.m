addpath('./src/')
close all;clear;

edges = readmatrix('lastfm_clean_edges.csv');
m = max(edges,[],'all') + 1;
A = zeros(m,m);
for k = 1:size(edges,1)
    i = edges(k,1) + 1;
    j = edges(k,2) + 1;
    A(i,j) = 1;
end
A = (A + A')/2;

G = graph(A);
%
% largest connected component of graph G
%
[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
SG = subgraph(G, idx);

%
% W matrix
%
W = adjacency(SG);
n = size(W, 1);

%
% D matrix
%
D = diag(W*ones(n,1));

% labels1 = alg1(W, D, 3);
% [C,ia,ic] = unique(labels1);
% a_counts = accumarray(ic,1);
% value_counts = [C, a_counts]

%
% construct F matrix
%
countries_raw = readmatrix('lastfm_clean_countries.csv');
% delete vertices not in the largest connected component
countries = countries_raw(idx,:);
f = countries(:,2);
uniquef = unique(f);
h = length(uniquef);

F = zeros(n, h-2);
G = zeros(n, h-1);

for i = 1:h-1
    idx = f == uniquef(i);
    count = sum(idx);
    fprintf("size of group # %d\n", count);
    if i < h-1
        F(:,i) = idx - count/n;
    end
    G(:,i) = idx;
end

% F = zeros(n, h-3);
% G = zeros(n, h-2);

% combine country 3, 6 and 14.
% idx1 = f == uniquef(1);
% % count1 = sum(idx1);
% G(:,1) = idx1;
% 
% idx4 = f == uniquef(4);
% count4 = sum(idx4);
% F(:,1) = idx4 - count4/n;
% G(:,2) = idx4;
% 
% idx6 = f == uniquef(6);
% count6 = sum(idx6);
% F(:,2) = idx6 - count6/n;
% G(:,3) = idx6;
% 
% idx2 = f == uniquef(2);
% count2 = sum(idx2);
% idx3 = f == uniquef(3);
% count3 = sum(idx3);
% idx5 = f == uniquef(5);
% count5 = sum(idx5);
% F(:,3) = idx2 + idx3 + idx5 - (count2 + count3 + count5)/n;
% G(:,4) = idx2 + idx3 + idx5;

%
% running time testing
%

% runs = 5;
% krange = 2:1:10;
% 
% time_SC = zeros(runs,length(krange));
% time_FairSC = zeros(runs,length(krange));
% time_S_FairSC = zeros(runs,length(krange));
% 
% for j = 1:runs
%     fprintf("--------run %d--------\n", j);
%     for i = 1:length(krange)
%         k = krange(i);
%         fprintf("---k = %d---\n", k);
% 
%         tstart1 = tic;
%         labels1 = alg1(W, D, k);
%         time_SC(j,i) = toc(tstart1);
%         
%         tstart2 = tic;
%         labels2 = alg2(W, D, F, k);
%         time_FairSC(j,i) = toc(tstart2);
%         
%         tstart3 = tic;
%         labels3 = alg3(W, D, F, k);
%         time_S_FairSC(j,i) = toc(tstart3);
%     end
% end

%
% balance testing
%
% krange = 2:1:10; 
% 
% balance1 = zeros(length(krange),1);
% balance2 = zeros(length(krange),1);
% balance3 = zeros(length(krange),1);
% 
% for i = 1:length(krange)
%     k = krange(i);
%     
%     fprintf('----------SC------------\n');
%     labels1 = alg1(W, D, k);
%     balance1(i) = computeBalance(labels1, G, k);
% 
%     fprintf('----------FairSC------------\n');
%     labels2 = alg2(W, D, F, k);
%     balance2(i) = computeBalance(labels2, G, k); 
% 
%     fprintf('----------s-FairSC------------\n');
%     labels3 = alg3(W, D, F, k);
%     balance3(i) = computeBalance(labels3, G, k);    
% end


% calculate fractions for k = 2

k = 2;
fprintf('----------SC------------\n');
labels1 = alg1(W, D, k);
fractions1 = computeFraction(labels1, G);

fprintf('----------FairSC------------\n');
labels2 = alg2(W, D, F, k);
fractions2 = computeFraction(labels2, G);

fprintf('----------s-FairSC------------\n');
labels3 = alg3(W, D, F, k);
fractions3 = computeFraction(labels3, G);

% set default sizes for figures:
% ulesfontsize = 16;
% set(0, 'DefaultAxesFontSize', ulesfontsize);
% set(0, 'DefaultTextFontSize', ulesfontsize);
% set(0, 'DefaultUIControlFontSize', ulesfontsize);
% set(0,'DefaultLineMarkerSize',ulesfontsize);
% set(0,'DefaultLineLineWidth',2.5) 
% set(gcf, 'PaperPosition', [0 0 10 7.5])
% set(gcf, 'PaperSize', [10 7.5]);
% 
% figure(1);clf;
% yyaxis left
% plot(krange, balance1,'-',krange, balance2,'--', krange, balance3, '');
% ylim([0 1]);
% ylabel('Average balance');
% hold on;
% yyaxis right;
% plot(krange, tr1,'-',krange, tr2,'--');
% legend({'SC (Alg. 1)', 'FAIR SC (EED, Alg. 3)', 'SC (Alg. 1)', 'FAIR SC (EED, Alg. 3)'}, 'Location','north');
% xlabel('k');
% ylabel('Ncut');
% title(strcat('FacebookNet --- n=',num2str(n),' h=2 (gender)'),'FontWeight','normal')