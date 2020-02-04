%% ALL in ONE
T = readtable("Gaming_Video_Quality_dataset.xlsx");
% Task 2
T = bitperpixel(T)
% Task 1
new_T = gameMos(T);

%Task 3
[X_train, Y_train] = linreg(new_T, T)
%Task 4
fitobj1 = fit(new_T.Bitperpixel, new_T.MOS_VF, 'exp1')
fitobj2 = fit(new_T.Bitperpixel, new_T.MOS_VU, 'poly3')
fitobj3 = fit(new_T.Bitperpixel, new_T.MOS_VD, 'exp1')