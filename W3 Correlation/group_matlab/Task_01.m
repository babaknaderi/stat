T = readtable("..\..\likeability_dimension_ratings.csv");

t_characteristica = T(:,10:end);

emotion1 = [""];
emotion2 = [""];
correlation_pearson = [0];
p_value_pearson = [0];
significant_pearson = [0];
correlation_spearman = [0];
p_value_spearman = [0];
significant_spearman = [0];
correlation_kendall = [0];
p_value_kendall = [0];
significant_kendall = [0];

%cell2Number for NA entries
t_characteristica.herzlich = str2double(t_characteristica.herzlich);

for i=1:width(t_characteristica)-1
    for y=i+1:width(t_characteristica)
        X = (t_characteristica(:,i));
        Y = (t_characteristica(:,y));
        %disp("Comparing '"+X.Properties.VariableNames +"' and '"+Y.Properties.VariableNames+"'");
        [R_pearson,P_pearson] = corr(table2array(X),table2array(Y),'Type','Pearson','Rows','complete');
        [R_spearman,P_spearman] = corr(table2array(X),table2array(Y),'Type','Spearman','Rows','complete');
        [R_kendall,P_kendall] = corr(table2array(X),table2array(Y),'Type','Kendall','Rows','complete');
        %[RR,PP] = corrcoef(table2array(X),table2array(Y))

         emotion1(length(emotion1)+1) = string(X.Properties.VariableNames);
         emotion2(length(emotion2)+1) = string(Y.Properties.VariableNames);
         
         %pearson
         correlation_pearson(length(correlation_pearson)+1) = R_pearson;
         p_value_pearson(length(p_value_pearson)+1)= P_pearson;
         if(P_pearson <= 0.05)
            significant_pearson(length(significant_pearson)+1) = 1;
         else
             significant_pearson(length(significant_pearson)+1) = 0;
         end
         
         %spearman
         correlation_spearman(length(correlation_spearman)+1) = R_spearman;
         p_value_spearman(length(p_value_spearman)+1)= P_spearman;
         if(P_spearman <= 0.05)
            significant_spearman(length(significant_spearman)+1) = 1;
         else
             significant_spearman(length(significant_spearman)+1) = 0;
         end
         
         %kendall
         correlation_kendall(length(correlation_kendall)+1) = R_kendall;
         p_value_kendall(length(p_value_kendall)+1)= P_kendall;
         if(P_kendall <= 0.05)
            significant_kendall(length(significant_kendall)+1) = 1;
         else
             significant_kendall(length(significant_kendall)+1) = 0;
         end
    end
end
emotion1 = emotion1(2:end);
emotion2 = emotion2(2:end);

correlation_pearson = correlation_pearson(2:end);
p_value_pearson = p_value_pearson(2:end);
significant_pearson = significant_pearson(2:end);

correlation_spearman = correlation_spearman(2:end);
p_value_spearman = p_value_spearman(2:end);
significant_spearman = significant_spearman(2:end);

correlation_kendall = correlation_kendall(2:end);
p_value_kendall = p_value_kendall(2:end);
significant_kendall = significant_kendall(2:end);

coef = table(emotion1',emotion2',correlation_pearson',p_value_pearson',significant_pearson',correlation_spearman',p_value_spearman',significant_spearman',correlation_kendall',p_value_kendall',significant_kendall');
coef.Properties.VariableNames{'Var1'} = 'characteristic_1';
coef.Properties.VariableNames{'Var2'} = 'characteristic_2';

coef.Properties.VariableNames{'Var3'} = 'correlation pearson';
coef.Properties.VariableNames{'Var4'} = 'p_value pearson';
coef.Properties.VariableNames{'Var5'} = 'significant pearson';

coef.Properties.VariableNames{'Var6'} = 'correlation spearman';
coef.Properties.VariableNames{'Var7'} = 'p_value spearman';
coef.Properties.VariableNames{'Var8'} = 'significant spearman';

coef.Properties.VariableNames{'Var9'} = 'correlation kendall';
coef.Properties.VariableNames{'Var10'} = 'p_value kendall';
coef.Properties.VariableNames{'Var11'} = 'significant kendall';

disp(coef)


%check if ND, so pearson can be applied
h_ks_values = [0];
column_names = [""];

for i=1:width(t_characteristica)
    z_values = table2array(t_characteristica(:,i));
    h_ks = kstest(z_values);
    %disp(h_ks);
    
    %x-axsis range
    binrng = min(z_values):max(z_values);
    %histogramm data for males
    counts1 = histc(z_values,binrng);
    subplot(12,3,i);
    bar(binrng, counts1, 'r')
    
    hold on
    hold off
    
    h_ks_values(length(h_ks_values)+1) = h_ks;
    column_names(length(column_names)+1) = string(t_characteristica(:,i).Properties.VariableNames);
end
t_nd = table(column_names(2:end)', h_ks_values(2:end)');
t_nd.Properties.VariableNames{'Var1'} = 'characteristic';
t_nd.Properties.VariableNames{'Var2'} = 'H KS-Test Value';
disp(t_nd);

hold on
disp("Because its not normal distributed -> no pearson")
disp("Because its no ordinal scale -> no spearman")
disp("=> kendal")
hold off