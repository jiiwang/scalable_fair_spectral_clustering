function fractions = computeFraction(labels,gmale)
    unilb = unique(labels);
    k = length(unilb);
    fractions = zeros(k,1);
    for i = 1:k
        i
        idx = labels == unilb(i);
        ci = sum(idx)
        vfandci = sum(gmale(idx))
        fractions(i) = vfandci/sum(idx);
    end
end

