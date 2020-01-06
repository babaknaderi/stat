%% Get all data
% First we get all the important data (VQ - VD)
T = readtable("..\..\Gaming_video_quality_dataset.xlsx");
t_parameter=T(:,8:11);
t_parameter.Properties.VariableNames

%% Calculation
% Now we have to calculate the CronbachAlpha value for each possible
% combination to see which observations build a same general construct.
% The calculation function is not native to matlab. But in the File
% Exachange community the formula for the CronbachAlpha value has
% already be implemented.
% see https://de.mathworks.com/matlabcentral/fileexchange/7829-cronbach-s-alpha
entries =[];
for i=1:width(t_parameter)-1
    for(range=0:width(t_parameter)-i-1)
        for(x=i+1:width(t_parameter)-range)
        t = table(table2array(t_parameter(:,i:i)),table2array(t_parameter(:,x:x+range)));
        params = [ t_parameter(:,i:i).Properties.VariableNames' ; t_parameter(:,x:x+range).Properties.VariableNames' ]';
        
        [us,s] = CronbachAlpha(table2array(t));
        
        entry.parameter =  strjoin(string(params));
        entry.standardized = s;
        entry.regular = us;
        entries = [entries, entry];
        end
    end
end

%% Descripton
% The function mentioned above can calculate the regular Cronbach's alpha
% value and a standardized Cronbach's alpha value. The regular value is
% based on covariances while the standardized one is based on correlations.
% The standardization is important if the tests have different scales (one
% 1-10 and the other 1-100) . Then the standardized value should be used.
% In our case the regular value can be used.
% Different values reflecting different constitencies:

alpha = [">=0.9", ">=0.8", ">=0.7", ">=0.6", ">=0.5", "0.5>"];
internal_consistency = ["excellent", "good", "acceptable", "questionable", "poor", "unacceptable"];
ta = table(alpha', internal_consistency')
ta.Properties.VariableNames{'Var1'} = 'aplha';
ta.Properties.VariableNames{'Var2'} = 'internal_consitency';


%% Result
% As you can see, the best value can be reached if only {VQ & VU} (alpha = 0.85456) are used.
% In general it could be said, that the without the VD observation, a
% higher value can be archieved.
final = struct2table(entries,'AsArray',true)