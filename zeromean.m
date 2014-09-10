function cohmat = zeromean(cohmat)

nzloc = (cohmat > 0);
submat = zeros(size(cohmat));
submat(nzloc) = mean(nonzeros(cohmat))-0.5;
cohmat = cohmat - submat;
cohmat(nzloc) = zscore(nonzeros(cohmat));