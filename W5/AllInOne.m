
T_Full = readtable('Gaming_video_quality_dataset.xlsx');

T_MOS = grpstats(T_Full,{'Game','Condition'},'mean','DataVars',{'VQ','VF','VU','VD'});

T_MOS

T_Full.Bitperpixel = zeros(height(T_Full),1);

for i = 1:height(T_Full)
    if T_Full{i,'Resolution'} == 480
        T_Full{i, 'Bitperpixel'} = (T_Full{i, 'Bitrate'}/(480*720));
    elseif T_Full{i,'Resolution'} == 720
        T_Full{i, 'Bitperpixel'} = (T_Full{i, 'Bitrate'}/(720*1280));
    else
        T_Full{i, 'Bitperpixel'} = (T_Full{i, 'Bitrate'}/(1080*1920));
    end
end

scatter(T_MOS.mean_VF, T_MOS.mean_VQ)
xlabel('MOS - Video Fragmentation (VF)')
ylabel('MOS - Video Quality (VQ)')

scatter(T_MOS.mean_VU, T_MOS.mean_VQ)
xlabel('MOS - Video Unclearness (VU)')
ylabel('MOS - Video Quality (VQ)')

scatter(T_MOS.mean_VD, T_MOS.mean_VQ)
xlabel('MOS - Video Discontinuity (VD)')
ylabel('MOS - Video Quality (VQ)')

T_MOS_train = T_MOS(T_MOS.Game ~= "Game1",:);
T_MOS_test = T_MOS(T_MOS.Game == "Game1",:);

T_Full_train = T_Full(T_Full.Game ~= "Game1",:);
T_Full_test = T_Full(T_Full.Game == "Game1",:);

X_train = [T_MOS_train.mean_VD T_MOS_train.mean_VF T_MOS_train.mean_VU];
y_train = T_MOS_train.mean_VQ;
%[~,~,~,~,stats] = regress(y,X)
mdl = fitlm(X_train,y_train)

X_test = [T_MOS_test.mean_VD T_MOS_test.mean_VF T_MOS_test.mean_VU];
y_test = mdl.predict(X_test)

T_MOS_test.mean_VQ

abs(T_MOS_test.mean_VQ - y_test)

fitobj1 = fit(T_Full_test.Bitperpixel, T_MOS_test.mean_VF, 'exp1')
fitobj2 = fit(T_Full_test.Bitperpixel, T_MOS_test.mean_VU, 'poly3')
fitobj3 = fit(T_Full_test.Bitperpixel, T_MOS_test.mean_VD, 'exp1')

license('checkout','Curve_Fitting_Toolbox')

regressionLearner


