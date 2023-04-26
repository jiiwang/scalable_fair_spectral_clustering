function balance = computeBalance(labels, G, k)
%     gfemale = double(~gmale);
    b = zeros(k, 1);
    c = zeros(k, 1);
    for i = 1:k
%         fprintf("----cluster #: %d\n----", i);
        idx = labels == i;
        c(i) = sum(idx);
%         fprintf("size of cluster # %d: %d\n", i, c(i));
        min = length(labels);
        max = 0;
        for j = 1:size(G,2)
%             fprintf("--group #: %d\n--", j);
            g = G(:,j);
            tmp = sum(g(idx));
            if tmp < min
                min = tmp;
            end
            if tmp > max
                max = tmp;
            end
        end
        b(i) = min/max;
    end
    balance = mean(b);
end

