
df = readtable("datasets/DB04_speech_quality_crowdsourcing_dataset.xlsx", "Sheet","CS -Full");

df.cond = extractBetween(df.files, 6,8);
uniq_conds = convertCharsToStrings(unique(df.cond));

for i = 1 : size(uniq_conds,1)
    T_cond = df(df.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    mean_array(i) = mean(T_cond_array);
    std_array(i) = std(T_cond_array);
    SEM = std(T_cond_array)/sqrt(length(T_cond_array));              
    ts = tinv([0.025  0.975],length(T_cond_array)-1);
    CI = mean(T_cond_array) + ts*SEM; 
    CI_array(i) = diff(CI) /2;
    size_array(i) = size(T_cond_array,1);
end

cs_per_condition = table(uniq_conds,mean_array', std_array', CI_array', size_array');
cs_per_condition.Properties.VariableNames = {'Condition', 'MOS', 'Std', ' CI 95%', 'n'};

cs_per_lab = readtable("datasets/DB04_speech_quality_crowdsourcing_dataset.xlsx", "Sheet","Lab-per condition");

scatter(cs_per_condition.MOS, cs_per_lab.MOS,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
title('Data Distribution')
xlabel('CS - per condition')
ylabel('Lab - per condition')

pearson_corr =corr(cs_per_condition.MOS, cs_per_lab.MOS, 'Type', 'Pearson')

spearman_corr = corr(cs_per_condition.MOS, cs_per_lab.MOS, 'Type', 'Spearman')

kendall_corr = corr(cs_per_condition.MOS, cs_per_lab.MOS, 'Type', 'Kendall')


