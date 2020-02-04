function[T] = bitperpixel(T)
%T = readtable("Gaming_Video_Quality_dataset.xlsx");

T{T.Resolution == 480, 5} = 480^2*3/2;
T{T.Resolution == 720, 5} = 720^2*16/9;
T{T.Resolution == 1080, 5} = 1080^2*16/9;

for i = 1:height(T)
    T.Bitperpixel(i) = T.Bitrate(i)/T.Resolution(i);
end
end
