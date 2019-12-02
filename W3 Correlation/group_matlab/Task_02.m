%% Task 02 Speaker Likeability regarding age difference and attractivity
%
T = readtable("likeability_dimension_ratings.csv");

tmp = [T.listener_age T.speaker_age];

% Get the age difference if only the age gap matters therefore
% if speaker young or older doesnt matter, no negative values.
T.Age_diff_abs = abs(diff(tmp')');

% Get the age difference if it matters if speaker is younger or older.
T.Age_diff = diff(tmp')';


x = [];
y = [];
%% If we calculate for the difference in age regarding if the speaker is younger or older
%
for i = 1:max(T.Age_diff)+abs(min(T.Age_diff))+1
    tmpx = [];
    for j = 1:length(T.Age_diff)
        if T.Age_diff(j) == i - abs(min(T.Age_diff)) -1
            tmpx = [tmpx T.attraktiv(j)];
            x(i) =  T.Age_diff(j);
        end
    end
    y(i) =  mean(tmpx);
end
z = corr(x',y')

x_abs = [];
y_abs = [];
%% If we calculate for the difference in age regardless if older or younger
%
for i = 1:max(T.Age_diff_abs)+1
    tmpx2 = [];
    for j = 1:length(T.Age_diff_abs)
        if T.Age_diff_abs(j) == i - 1
            tmpx2 = [tmpx2 T.attraktiv(j)];
            x_abs(i) =  T.Age_diff_abs(j);
        end
    end
    y_abs(i) =  mean(tmpx2);
    
end

% Its a pearson correlation as we are working with 2 normally distributed
% variab-les

z_abs = corr(x_abs',y_abs','type','Pearson')
