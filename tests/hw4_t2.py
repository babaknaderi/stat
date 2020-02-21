
import itertools
import numpy as np  # pip install numpy
import scipy.stats  # pip install scipy

import pandas as pd  # pip install pandas

if __name__ == '__main__':
    data = pd.read_csv("../datasets/DB03_speech_quality_repetition_dataset.csv")

    stimulusData = data[data.testStimulus == "maus_m_700_normAsl_-26"]
    new_df = stimulusData.pivot(index='subjectCode', columns='repetition', values='rating')
    flattened = pd.DataFrame(new_df.to_records())
    print(flattened.head())

    [r12, p12] = scipy.stats.pearsonr(flattened['1'].tolist(), flattened['2'].tolist())
    [r23, p23] = scipy.stats.pearsonr(flattened['2'].tolist(), flattened['3'].tolist())
    [r34, p34] = scipy.stats.pearsonr(flattened['3'].tolist(), flattened['4'].tolist())


