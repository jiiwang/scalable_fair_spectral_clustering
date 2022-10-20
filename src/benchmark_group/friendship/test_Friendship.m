addpath('../')
close all;clear;
%
% script to clean group data
% gender of some students are unknown
%
% for i = 1:320
%     if table2array(metadata2013(i,2)) == 'F'
%         group(i,2) = 0
%     elseif table2array(metadata2013(i,2)) == 'M'
%         group(i,2) = 1
%     end   
% end

%
% script to clean friendship data
% gender of some students are unknown
%
% friendship = readmatrix('Facebook-known-pairs_data_2013.csv');
% idx = any((friendship == 34) | (friendship ==41 ),2);
% friendship = friendship(idx,:);
% friendship(idx,:) = [];

% load facebook friendship data
group = readmatrix('group_clean.csv');
friendship = readmatrix('friendship_clean.csv');

nall = size(group, 1);
A = zeros(nall, nall);
for m = 1:size(friendship,1)
    i = find(group(:,1) == friendship(m,1));
    j = find(group(:,1) == friendship(m,2));
    if friendship(m,3) == 1
        A(i,j) = 1;
        A(j,i) = 1;
    end
end

% A = A(1:20,1:20);

G = graph(A);
%
% find the largest connected component of graph G
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

%
% construct F matrix
%
g = group(idx,:);
gmale = g(:,2);
gfemale = double(~gmale);

% F = zeros(n,2);
% F = gmale - sum(gmale)/n;
% F(:,1) = gmale - sum(gmale)/n;
F = gfemale - sum(gfemale)/n;
% F(:,2) = gfemale - sum(gfemale)/n;


krange = 2:1:2;
% tr1 = zeros(length(krange),1);
% tr2 = zeros(length(krange),1);
% tr3 = zeros(length(krange),1);
balance1 = zeros(length(krange),1);
balance2 = zeros(length(krange),1);
balance3 = zeros(length(krange),1);

for i = 1:length(krange)
    k = krange(i);
    labels1 = alg1(W, D, k);
    labels2 = alg2(W, D, F, k);
    labels3 = alg3(W, D, F, k);
% H2(1:5,:)
% H3(1:5,:)
% resH = norm(H3 - H2,1)/n

    fprintf('----------algorithm 1------------\n');
    fractions1 = computeFraction(labels1, gmale);
    fprintf('----------algorithm 2------------\n');
    fractions2 = computeFraction(labels2, gmale);
    fprintf('----------algorithm 3------------\n');
    fractions3 = computeFraction(labels3, gmale);
    
    balance1(i) = computeBalance(labels1, gmale, k);
    balance2(i) = computeBalance(labels2, gmale, k);
    balance3(i) = computeBalance(labels3, gmale, k);
end

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