df_gamingVQ = readtable("Gaming_Video_Quality_dataset.xlsx");

df_gamingVQ = df_gamingVQ(df_gamingVQ.Condition_params == "480_30_300",:);

game1 = df_gamingVQ(df_gamingVQ.Game == "Game1",:);
game2 = df_gamingVQ(df_gamingVQ.Game == "Game2",:);
game3 = df_gamingVQ(df_gamingVQ.Game == "Game3",:);
game4 = df_gamingVQ(df_gamingVQ.Game == "Game4",:);
game5 = df_gamingVQ(df_gamingVQ.Game == "Game5",:);
game6 = df_gamingVQ(df_gamingVQ.Game == "Game6",:);

games = {game1,game2,game3,game4,game5,game6};

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.35, 0.55]);

for i = 1:6
    subplot(2,3,i)
    boxplot(games{i}.VQ, games{i}.Condition)
    title("Boxplot for Game " + num2str(i))
    xlabel("Condition ID")
    ylabel("Visual Quality")
end





