
T_Full = readtable("Speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS -Full");

T_Full.cond = extractBetween(T_Full.files, 6,8);
uniq_conds = convertCharsToStrings(unique(T_Full.cond));

counter = 1;
for i = 1 : size(uniq_conds,1)
    T_cond = T_Full(T_Full.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    Z = zscore(T_cond_array);
    
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
                participants(counter) = convertCharsToStrings(T_cond(t1,t2).Properties.VariableNames);
                counter = counter +1;
            end
        end
    end
end

%T_cond = T_Full(T_Full.cond ==uniq_conds(3),:);
%T_cond_array = table2array(T_cond(:,2:end-1));
%T_cond_array = (T_cond_array(~isnan(T_cond_array)));

%Z = zscore(T_cond_array)

%length(Z)

participants


