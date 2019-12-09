
% Importing dataset
T_crowdsourcing = readtable('datasets/DB04_speech_quality_crowdsourcing_dataset.xlsx', 'Sheet', 'CS -Full');
T_lab = readtable('datasets/DB04_speech_quality_crowdsourcing_dataset.xlsx' , 'Sheet', 'Lab-per condition');

% Creating a new column for conditions
T_crowdsourcing.cond = extractBetween(T_crowdsourcing.files, 6,8);

% Unique list of conditions
uniq_conds = convertCharsToStrings(unique(T_crowdsourcing.cond));

% Creating an empty array to store condition values
A = [];

% Collecting condition values in A
% Since every condition has different number of values, filling 'empty' values with 0
for i = 1 : size(uniq_conds,1)
    T_cond = T_crowdsourcing(T_crowdsourcing.cond ==uniq_conds(i),:);
    T_cond = T_cond(:,2:end-1);
    T_cond_array = table2array(T_cond);
    T_cond_array = (T_cond_array(~isnan(T_cond_array)));
    mean_array(i) = mean(T_cond_array);
    T_cond_array = [T_cond_array;zeros(400-size(T_cond_array,1),1)];
    A = [A; T_cond_array'];
end

% Replacing 0 values with the mean of corresponding mean of condition
for i = 1: size(mean_array,2)
    A(i,find(A(i,:) == 0)) = mean_array(i);
end

% ICC for CS Study
[icc_CS,~,~,~,~,~,~] = ICC(A, 'A-1', 0.05, 0)

% Working with Lab data,
% Columns 2 and 3 are MOS and Std
B = T_lab(:,2:3);
B = table2array(B);

% Lab has 192 workers, who have values for every observation(?)
C = zeros(1,192);

% But we only have Stds of first ten conditions. So generating data with respective mean and Std for first 
% 10 conditions from normal distribution
%for i = 1 : size(B,1)
for i = 1 : 10
    temp = B(i,2).*randn(192,1) + B(i,1);
    C= [C;temp'];
end

% Deleting the first dummy row
C = C(2:end,:);

% ICC for lab study
[icc_Lab,~,~,~,~,~,~] = ICC(C, 'A-1', 0.05, 0)


