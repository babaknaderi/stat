T_Full = readtable("datasets/DB04_speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS -Full");

% Creating a new column for conditions
T_Full.cond = extractBetween(T_Full.files, 6,8);

% Unique list of conditions
uniq_conds = convertCharsToStrings(unique(T_Full.cond));

% Counter for Z-Scores
counter = 1;

% Counter for IQR-Evaluations
counter1 = 1;

% Loop over all conditions
for i = 1 : size(uniq_conds,1)
    % Creating a new table containing only data from condition i
    T_cond = T_Full(T_Full.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    
    % Converting table into array and removing empty(NaN) values
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    
    % Calculation of Z-Score
    Z = zscore(T_cond_array);
    
    % Calculating the IQR
    IQR = iqr(T_cond_array);
    
    % Calculating the respective quantiles and then the limits for outliers
    quantiles = quantile(T_cond_array,[0.25,0.75]);
    q1 = quantiles(1);
    q3 = quantiles(2);
    IQRleft = q1 -(1.5*IQR);
    IQRright = q3 + (1.5*IQR);
    
    T_cond_Z = T_cond;
    
    % Creating a table for the MOS values and Z-Scores that belong to MOS values
    T_zscore = table(T_cond_array, zscore(T_cond_array));

    % Loops over that table
    for x = 1: size(T_zscore,1)
        % If Z-Score represents an outlier
        if(table2array(T_zscore(x,2))>3.29 || table2array(T_zscore(x,2)) < -3.29)
            %"outlier"
            % Find function finds all occurances of that value in the table and returns the 
            % row postions as t1 and column positions as t2 (vectors)
            [t1,t2] = find(table2array(T_cond_Z) == table2array(T_zscore(x,1)));
                
                % We loop over that vectors
                for p = 1:length(t1)
                    % Find the positions in the table, retrieve the column name and add it into the list of Z-Score outliers
                    participants_Z(counter) = convertCharsToStrings(T_cond_Z(t1(p),t2(p)).Properties.VariableNames);
                    %T_cond_Z = removevars(T_cond_Z, participants_Z(counter));
                    counter = counter + 1;
                    
                end

        end
    end
    
    % We find the values that are above the upper bound and below the lower bound for outlier detection
    [t1,t2] = find(table2array(T_cond) > IQRright);
    [t3,t4] = find(table2array(T_cond) < IQRleft);
    
    % We add them into the list for IQR outliers
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

% We count the occurances of each worker in the Z-Score list
[a,b]=hist(categorical(participants_Z),unique(categorical(participants_Z)));
t_z = table(b', a');
t_z.Properties.VariableNames = {'Worker' , 'Count'}

% We count the occurances of each worker in the IQR list
[c,d]=hist(categorical(participants_IQR),unique(categorical(participants_IQR)));
t_iqr = table(d',c');
t_iqr.Properties.VariableNames = {'Worker' , 'Count'}

% Workers are to be deleted according the Z-Score
t_z2 = table((b(a>2))',(a(a>2))');
t_z2.Properties.VariableNames = {'Worker' , 'Count'}

% Workers are to be deleted according the IQR-Evaluation
t_iqr2 = table((d(c>2))',(c(c>2))');
t_iqr2.Properties.VariableNames = {'Worker' , 'Count'}

% All workers to be deleted in a table
all_in = [t_z2;t_iqr2]
deleted = unique(all_in.Worker)

% We remove the workers
T_Full2 = removevars(T_Full,deleted);
size(T_Full2)

size(T_Full)

% Mean,STD, 95% CI Calculation for original table

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
    n_array(i) = length(T_cond_array)
end

old_table = table(uniq_conds,mean_array', std_array', CI_array', n_array');
old_table.Properties.VariableNames = {'Condition', 'MOS', 'Std', ' CI 95%', 'n'}

% Mean,STD, 95% CI Calculation for new table

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
    n_array(i) = length(T_cond_array)
end

final_table = table(uniq_conds,mean_array', std_array', CI_array', n_array');
final_table.Properties.VariableNames = {'Condition', 'MOS', 'Std', ' CI 95%', 'n'}


