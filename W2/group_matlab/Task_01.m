T_Cond = readtable("Speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS-per condition");
T_Csfile = readtable("Speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS-per file");

for i = 1:48
    if 10 > i
        cond = strcat("c0", num2str(i));
    else
        cond = strcat("c", num2str(i));
    end
    
    A = table2array(T_Csfile(contains(T_Csfile.files, cond),4:21));
    N = length(A(~isnan(A)));
    T_Cond.n{i} = N;
    T_Cond.MOS{i} = nanmean(A(:));
    T_Cond.STD{i} = nanstd(A(:));
    
    t_score = tinv([0.025 0.975], N-1);
    B =  nanmean(A(:)) + t_score*(nanstd(A(:))/sqrt(N));
    T_Cond.CI95{i} = diff(B')'/2;
end

T_Cond
