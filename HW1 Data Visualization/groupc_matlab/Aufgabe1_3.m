T = readtable("speech_quality_ratings.xlsx");
max_age = max(T.Age);
min_age = min(T.Age);
%age range
dim = max_age-min_age;
 
single_participants = unique(T(:,[1:3]));

%here the ages of each gender will be stored as the following:
%e.g for males and age 20-25 ages: 0x20, 1x21 , 2x22, 2x23 0x24, 4x25
% males = [21, 22, 22 ,23 ,23 ,25, 25, 25 ,25]
male_ages = [];
female_ages = [];

% for each possible age in range
for i = min_age: max_age
    %get the amount of particitpants with age = i and sperated by male and
    %female
    t_agei_m = single_participants(single_participants.Gender == "m" & single_participants.Age == i,:);
    t_agei_f = single_participants(single_participants.Gender == "w" & single_participants.Age == i,:);
    
    %put the age number as often in the array as we counted before
    male_ages = [male_ages; repmat(i,height(t_agei_m),1)];
    female_ages = [female_ages; repmat(i,height(t_agei_f),1)];
end

%x-axsis range
binrng = min_age:max_age;
%histogramm data for males
counts1 = histc(male_ages, binrng);
%histogramm data for females
counts2 = histc(female_ages, binrng);
%histogramm data both counted
counts3 = counts1 + counts2; 
figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.2, 0.4]);
bar(binrng, counts3, 'r')
hold on
bar(binrng, counts1, 'b')
hold off
legend('female', 'male')