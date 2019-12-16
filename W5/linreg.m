function [X_train, y_train] = linreg(new_T, T)

scatter(new_T.MOS_VF, new_T.MOS_VQ)
xlabel('MOS - Video Fragmentation (VF)')
ylabel('MOS - Video Quality (VQ)')

scatter(new_T.MOS_VU, new_T.MOS_VQ)
xlabel('MOS - Video Unclearness (VU)')
ylabel('MOS - Video Quality (VQ)')

scatter(new_T.MOS_VD, new_T.MOS_VQ)
xlabel('MOS - Video Discontinuity (VD)')
ylabel('MOS - Video Quality (VQ)')

T_MOS_train = new_T(new_T.Game ~= "Game1",:);
T_MOS_test = new_T(new_T.Game == "Game1",:);

T_Full_train = T(T.Game ~= "Game1",:);
T_Full_test = T(T.Game == "Game1",:);

X_train = [T_MOS_train.MOS_VD T_MOS_train.MOS_VF T_MOS_train.MOS_VU];
y_train = T_MOS_train.MOS_VQ;
%[~,~,~,~,stats] = regress(y,X)
mdl = fitlm(X_train,y_train)