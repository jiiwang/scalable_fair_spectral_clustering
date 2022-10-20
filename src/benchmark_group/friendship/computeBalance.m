function balance = computeBalance(labels, gmale, k)
%     gfemale = double(~gmale);
    b = zeros(k, 1);
    c = zeros(k, 1);
    for i = 1:k
        idx = find(labels == i);
        c(i) = length(idx);
        count = 0;
        for j =1:length(idx)
            if gmale(idx(j)) == 1
                count = count + 1;
            end
        end
        b(i) = min(count/(c(i)-count),(c(i)-count)/count);
    end
    balance = mean(b);
end

