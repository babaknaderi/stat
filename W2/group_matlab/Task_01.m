%% Task_01 Calculate Mean STD and CI95 for each condition
%

T_Cond = readtable("Speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS-per condition");
T_Csfile = readtable("Speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS-per file");

%iterate through every condition
for i = 1:48
    
    % get each condition as a string to work with sheet
    if 10 > i
        cond = strcat("c0", num2str(i));
    else
        cond = strcat("c", num2str(i));
    end
    
    % Get all the data points
    A = table2array(T_Csfile(contains(T_Csfile.files, cond),4:21));
    % Get length of data points without NAN values
    N = length(A(~isnan(A)));
    % Calculate the stuff
    T_Cond.n{i} = N;
    T_Cond.MOS{i} = nanmean(A(:));
    T_Cond.STD{i} = nanstd(A(:));
    
    t_score = tinv([0.025 0.975], N-1);
    B =  nanmean(A(:)) + t_score*(nanstd(A(:))/sqrt(N));
    T_Cond.CI95{i} = diff(B')'/2;
end

% save it in the table
T_Cond
