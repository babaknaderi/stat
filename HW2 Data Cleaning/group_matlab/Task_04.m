T = readtable("..\..\Gaming_Video_Quality_dataset.xlsx");
t_game4_condition26 = T(T.Condition == 26 & T.Game == "Game4" ,:);

%ND
ks_std = std(t_game4_condition26.VQ);
ks_mean = mean(t_game4_condition26.VQ);
z_values = (t_game4_condition26.VQ-ks_mean )/ks_std;
%plot for cumulate distribution
subplot(2,1,1);
cdfplot(z_values)
hold on
x_values = linspace(min(z_values),max(z_values));
%values and color of nd line
plot(x_values,normcdf(x_values,0,1),'r-')
title('Cumulative Distribution Functions');
legend('Empirical CDF','Standard Normal CDF','Location','best');

%Kolmogorov-Smirnov
%if 1 = no normal distribution, if 0 = normal distribution
%significance < 0,05,               significance >= 0,05: 
[h_ks,p_ks_value] = kstest(z_values);
if(h_ks==1)
    fprintf("Video Quality is not normal distributed(Kolmogrov-Smirnov-Test) with significant level:%d\n", p_ks_value)
else
    fprintf("Video Quality is normal distributed(Kolmogrov-Smirnov-Test) with significant level:%d\n",p_ks_value)
end

%Shapiro-Wilk 
% performs the Shapiro-Wilk test to determine if the null hypothesis of composite
% normality is a reasonable assumption of a given distribution. 
%   The Shapiro-Wilk and Shapiro-Francia null hypothesis is: 
%   "X is normal with unspecified mean and variance."
% - pVAlueis the p-value, or the probability of observing the given
%   result by chance given that the null hypothesis is true
% - H
%     H = 0 => Do not reject the null hypothesis at significance level ALPHA.
%     H = 1 => Reject the null hypothesis at significance level ALPHA.
%  if 1 = no normal distribution, if 0 = normal distribution
%  significance < 0,05,               significance >= 0,05: 
[h_sw, p_sw_value, SWstatistic] = swtest(t_game4_condition26.VQ, 0.05);

if(h_sw==1)
    fprintf("Video Quality is not normal distributed(Shapiro-Wilk) with significant level: %d\n", p_sw_value)
else
    fprintf("Video Quality is normal distributed(Shapiro-Wilk) with significant level:%d\n",p_sw_value)
end


%QQ-Plot
subplot(2,1,2);
qqplot(t_game4_condition26.VQ');
title('QQ Plotof Video Quality versus Standard Normal');
