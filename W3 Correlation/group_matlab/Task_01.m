T = readtable("..\..\likeability_dimension_ratings.csv");

t_test = T(:,10:end);

emotion1 = [""];
emotion2 = [""];
correlation = [0];
p_value = [0];
significant = [0];
%cell2Number for NA entries
t_test.herzlich = str2double(t_test.herzlich);

for i=1:width(t_test)-1
    for y=i+1:width(t_test)
        X = (t_test(:,i));
        Y = (t_test(:,y));
        %disp("Comparing '"+X.Properties.VariableNames +"' and '"+Y.Properties.VariableNames+"'");
        [R,P] = corr(table2array(X),table2array(Y),'Type','Pearson','Rows','complete');
        %[RR,PP] = corrcoef(table2array(X),table2array(Y))

         emotion1(length(emotion1)+1) = string(X.Properties.VariableNames);
         emotion2(length(emotion2)+1) = string(Y.Properties.VariableNames);
         correlation(length(correlation)+1) = R;
         p_value(length(p_value)+1)= P;
         if(P <= 0.05)
            significant(length(significant)+1) = 1;
         else
             significant(length(significant)+1) = 0;
         end
         
    end
end
emotion1 = emotion1(2:end);
emotion2 = emotion2(2:end);
correlation = correlation(2:end);
p_value = p_value(2:end);
significant = significant(2:end);
coef = table(emotion1',emotion2',correlation',p_value',significant');
coef.Properties.VariableNames{'Var1'} = 'characteristic_1';
coef.Properties.VariableNames{'Var2'} = 'characteristic_2';
coef.Properties.VariableNames{'Var3'} = 'correlation';
coef.Properties.VariableNames{'Var4'} = 'p_value';
coef.Properties.VariableNames{'Var5'} = 'significant';