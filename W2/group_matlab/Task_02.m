
T_Full = readtable("datasets/DB04_speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS -Full");

T_Full.cond = extractBetween(T_Full.files, 6,8);
uniq_conds = convertCharsToStrings(unique(T_Full.cond));

counter = 1;
counter1 = 1;

for i = 1 : size(uniq_conds,1)
    T_cond = T_Full(T_Full.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    Z = zscore(T_cond_array);
    IQR = iqr(T_cond_array);
    quantiles = quantile(T_cond_array,[0.25,0.75]);
    q1 = quantiles(1);
    q3 = quantiles(2);
    IQRleft = q1 -(1.5*IQR);
    IQRright = q3 + (1.5*IQR);
    T_cond_Z = T_cond;
    T_zscore = table(T_cond_array, zscore(T_cond_array));

    
    for x = 1: size(T_zscore,1)
        if(table2array(T_zscore(x,2))>3.29 || table2array(T_zscore(x,2)) < -3.29)
            %"outlier"
            [t1,t2] = find(table2array(T_cond_Z) == table2array(T_zscore(x,1)));
         
                for p = 1:length(t1)
                    participants_Z(counter) = convertCharsToStrings(T_cond_Z(t1(p),t2(p)).Properties.VariableNames);
                    T_cond_Z = removevars(T_cond_Z, participants_Z(counter));
                    counter = counter + 1;
                    
                end

        end
    end

    [t1,t2] = find(table2array(T_cond) > IQRright);
    [t3,t4] = find(table2array(T_cond) < IQRleft);
    for x = 1:length(t1)
        participants_IQR(counter1) = convertCharsToStrings(T_cond(t1(x),t2(x)).Properties.VariableNames);
        counter1 = counter1 + 1;
    end
    
    for x = 1:length(t3)
        participants_IQR(counter1) = convertCharsToStrings(T_cond(t3(x),t4(x)).Properties.VariableNames);
        counter1 = counter1 + 1;
    end
    
end

table(participants_Z')

table(participants_IQR')

[a,b]=hist(categorical(participants_Z),unique(categorical(participants_Z)));
t_z = table(b', a');
t_z.Properties.VariableNames = {'Worker' , 'Count'}

[c,d]=hist(categorical(participants_IQR),unique(categorical(participants_IQR)));
t_iqr = table(d',c');
t_iqr.Properties.VariableNames = {'Worker' , 'Count'}

t_z2 = table((b(a>1))',(a(a>1))');
t_z2.Properties.VariableNames = {'Worker' , 'Count'}

t_iqr2 = table((d(c>1))',(c(c>1))');
t_iqr2.Properties.VariableNames = {'Worker' , 'Count'}

all_in = [t_z2;t_iqr2]

deleted = unique(all_in.Worker)

T_Full2 = removevars(T_Full,deleted);
size(T_Full2)

size(T_Full)

% Mean,STD, 95% CI

for i = 1 : size(uniq_conds,1)
    T_cond = T_Full(T_Full.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    mean_array(i) = mean(T_cond_array);
    std_array(i) = std(T_cond_array);
    SEM = std(T_cond_array)/sqrt(length(T_cond_array));              
    ts = tinv([0.025  0.975],length(T_cond_array)-1);
    CI = mean(T_cond_array) + ts*SEM; 
    CI_array(i) = diff(CI) /2;
end

old_table = table(uniq_conds,mean_array');
old_table.Std = std_array';
old_table.CI = CI_array';
old_table.Properties.VariableNames = {'Condition', 'Mean', 'Std', ' CI 95%'}

for i = 1 : size(uniq_conds,1)
    T_cond = T_Full2(T_Full2.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    mean_array(i) = mean(T_cond_array);
    std_array(i) = std(T_cond_array);
    SEM = std(T_cond_array)/sqrt(length(T_cond_array));              
    ts = tinv([0.025  0.975],length(T_cond_array)-1);
    CI = mean(T_cond_array) + ts*SEM; 
    CI_array(i) = diff(CI) /2;
end

final_table = table(uniq_conds,mean_array');
final_table.Std = std_array';
final_table.CI = CI_array';
final_table.Properties.VariableNames = {'Condition', 'Mean', 'Std', ' CI 95%'}


