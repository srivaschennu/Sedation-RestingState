load bpower16;
bpow16 = bpower;
load bpower17;
bpow17 = bpower;

mean16 = mean(bpow16);
mean17 = mean(bpow17);

stddev16 = std(bpow16);
stddev17 = std(bpow17);

percents16 = (bpow16-mean16) / stddev16;
percents17 = (bpow17-mean17) / stddev17;

figure;
plot(1:length(bpow16), percents16, 1:length(bpow17), percents17);
legend('night 1', 'night 2');
