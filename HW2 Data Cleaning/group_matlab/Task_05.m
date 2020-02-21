
df = readtable("datasets/DB01_gaming_video_quality_dataset.xlsx");

df.VQ = ((2/3)*df.VQ) + (1/3);

max(df.VQ)

min(df.VQ)

df.VQ =((7/8)*df.VQ) + (1/8);

max(df.VQ)

min(df.VQ)

df.VQ


