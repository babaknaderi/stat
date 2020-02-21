 T = readtable("Gaming_Video_Quality_dataset.xlsx");
   
    plotgamebar('480', T, 1)
    plotgamebar('720',T, 2)
    plotgamebar('1080',T, 3)       
 
    %%
    %
    % Below is the content of the function plotgamebar used to plot the
    % bars.
    % 
    % <include>plotgamebar.m</include>
    %