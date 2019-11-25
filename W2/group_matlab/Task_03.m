T = readtable("Speech_quality_crowdsourcing_dataset.xlsx","Sheet","CS participants");
this_year = year(datetime('now'));
years = T.BirthYear';
age = [];
 
for i=1 : length(years)
 years(i)= this_year-years(i);
end

ages = years;
%x-axsis range
           % bis 18,  18-25,26-36,36-50  
ranges = [    18,     26,   36,    51 inf];
            % 0     1       2     3      4
[bincounts,ind] = histcounts(ages,ranges)
figure(1)

%label names
binranges_names = []
for i=1: length(ranges)-1
    %define lower and upper ranges [18-25], [25-35] ... 
    str=ranges(i)+"-"+num2str(ranges(i+1)-1)
    binranges_names{i} = str
end

%last lable should not be [50 - inf] but 50>
binranges_names{end}=sprintf('>%d',ranges(end-1));
%problem: histgram only takes concrete values for x-axis, not ranges (if ranges, than the bar
%will be very wide (depends on the range). To have same bar width we only set the middle value) 
centers=ranges(1:(end-1))+diff(ranges(1:2));
centers=[1,2,3,4]
%plote
bar(centers,bincounts)
%set x axis to center values
xticks(centers)

%overwrite the x-axis values to range names
set(gca,'XTickLabels',binranges_names)
%rotate label for nicer view
set(gca,'XTickLabelRotation',60)

