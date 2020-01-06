%% Get Data
% First we must extract all relevant rows from the dataset (where testStimulus = "haus_m_700_normAsl_-26")
T = readtable("..\..\DB03_speech_quality_repetition_dataset.xlsx");
t_stimuli = T(T.testStimulus == "maus_m_700_normAsl_-26" ,:);

%% Calculate correlations
% For each repetition we will calculate the pearson value for the rating
% value. 
entries = [];
for i=1:max(t_stimuli.repetition)-1
    % get stimuli rating values for repetition i and i+1
    t_stimuli_in_T = t_stimuli(t_stimuli.repetition == i,:);
    t_stimuli_in_T_plus_one = t_stimuli(t_stimuli.repetition == i+1,:);
    
    %calculate
    [R_pearson,P_pearson] = corr(t_stimuli_in_T.rating,t_stimuli_in_T_plus_one.rating,'Type','Pearson');
    
    %store for later usage
    entry.comparison = i+"-" + string(i+1);
    entry.r_pearson = R_pearson;
    entry.p_value = P_pearson;
    entries = [entries, entry];
end

%% Result
% As can be seen in the following table all p_values are above 0.05 and
% therefore significant. The correlation in the first comparison is quiet
% high but for the other repetitions the correlation value gets lower.
% Therefore it seems, that the raters are not highly consistent over time.
struct2table(entries,'AsArray',true)
