function[new_T] = gameMos(T)

new_T = table

%Initialising values for plotting

counter = 1;

%get every single bitrate/fps pair
for i = 1:6 
    switch i
        case 1
            current_game = 'Game1';
        case 2
            current_game = 'Game2';
        case 3
            current_game = 'Game3';
        case 4
            current_game = 'Game4';
        case 5
            current_game = 'Game5';
        case 6
            current_game = 'Game6';
    end
    
    %get the corresponding bitpair/fps from the table
    T_Game = T(contains(T.Game, current_game),:);
    T_emp = table;
    ascension = 1;
    
    for j = 1:length(unique(T_Game.Condition))
        val = T_Game{ascension,3};
        T_emp = T_Game(T_Game.Condition == val,:);
        ascension = ascension + height(T_emp);
        
        new_T.Game(counter) = T_emp.Game(1);
        new_T.COND(counter) = T_emp.Condition(1);
        new_T.MOS_VQ(counter) = mean(T_emp.VQ);
        new_T.MOS_VF(counter) = mean(T_emp.VF);
        new_T.MOS_VU(counter) = mean(T_emp.VU);
        new_T.MOS_VD(counter) = mean(T_emp.VD);
        new_T.Bitperpixel(counter) = T_emp.Bitperpixel(1);

        counter = counter + 1;

    end

end
