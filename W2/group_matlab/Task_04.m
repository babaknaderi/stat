T = readtable("Gaming_Video_Quality_dataset.xlsx");
t_game4_condition26 = T(T.Condition == 26 & T.Game == "Game4" ,:);

%QQ-Plot
figure
qqplot(t_game4_condition26.VQ');
title('QQ Plot of Video Quality versus Standard Normal');
ylabel('VQ');

%Kolmogorov-Smirnov
ks_std = std(t_game4_condition26.VQ)
ks_mean = mean(t_game4_condition26.VQ)
z_values = (t_game4_condition26.VQ-ks_mean )/ks_std
%if 1 = no normal distribution, if 0 = normal distribution
h = kstest(z_values)
%plot for Kolmogorov-Smirnov
cdfplot(z_values)
hold on
x_values = linspace(min(z_values),max(z_values));
%values and color of nd line
plot(x_values,normcdf(x_values,0,1),'r-')
title('Cumulative Distribution Functions')
legend('Empirical CDF','Standard Normal CDF','Location','best')


%Shapiro-Wilk 
[H, pValue, SWstatistic] = swtest(t_game4_condition26.VQ, 0.05)
