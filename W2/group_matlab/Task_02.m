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

    
    for x = 1: length(Z)
        if(Z(x)>=3.29 || Z(x) < -3.29)
            %"outlier"
            %T_cond(:,21).Properties.VariableNames
            or = find(table2array(T_cond) == T_cond_array(x));
            for y = 1:length(or)
                t1 = mod(or(y),size(T_cond,1));
                t2 = floor(or(y)/size(T_cond,1));
                t2 = t2 +1;
                %"berk"
                participants_Z(counter) = convertCharsToStrings(T_cond(t1,t2).Properties.VariableNames);
                counter = counter +1;
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

%T_cond = T_Full(T_Full.cond ==uniq_conds(3),:);
%T_cond_array = table2array(T_cond(:,2:end-1));
%T_cond_array = (T_cond_array(~isnan(T_cond_array)));

%Z = zscore(T_cond_array)

%length(Z)

participants_Z

participants_IQR

[a,b]=hist(categorical(participants_Z),unique(categorical(participants_Z)));

[c,d]=hist(categorical(participants_IQR),unique(categorical(participants_IQR)));

T_Full2 = removevars(T_Full,[string(b(a>1)) string(d(c>1))]);

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
    CI_array(i) = diff(CI);
end

mean_array

std_array

CI_array


