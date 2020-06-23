%% Read in the duckling image and show it
file = dir(dirName);
image = imread(strcat('HDR_Segmented/',file(3).name));
[numRows, numCols] = size(image);
imshow(image)

%% Calculate the original histogram
histoValues = zeros(256,1);
for row = 1:600
    for col = 1:800
        r = image(row,col);
        index = int16(r) + 1;
        histoValues(index) = histoValues(index) + 1;
    end
end

histoValues = histoValues/(numRows*numCols); %Normalize

%% Display the original histogram
rArray = linspace(0,255,256);
figure(1);
stem(rArray, histoValues, 'Marker', 'none')
xlim([0,255]);
xlabel('Pixel Values')
ylabel('Probability')

%% Calculate the Map
sArray = zeros(256,1);
for s = 1:256
    for i = 1:s
        sArray(s) = sArray(s) + 255*histoValues(i); %(L-1)*integral(Pr) from 0 to s
    end
end

%% Display the Map
figure(2);
plot(rArray,sArray)
xlabel("r");
ylabel("s");
xlim([0,255]);

%% Equalize the image and show it
newImage = uint8(zeros(numRows,numCols));
newHistoValues = zeros(256,1);
for row = 1:numRows
    for col = 1:numCols
        val0 = int16(image(row,col)) + 1;
        val1 = uint8(round(sArray(val0)));
        newImage(row,col) = val1;
        newHistoValues(uint16(val1)+1) = newHistoValues(uint16(val1)+1) + 1;
    end
end

newHistoValues = newHistoValues/(numRows*numCols); %Normalize by area

imshow(newImage)

%% Show the new histogram
figure(3)
stem(rArray,newHistoValues,'Marker','none')
xlabel('Pixel Values')
ylabel('Probability')
xlim([0,255])

%% Matlab built in histogram equalization
[mLabHistIm,matlabMap] = histeq(image);
figure(4)
sgtitle("Implemented Histogram Equalization versus Built-In Matlab Histogram Equalization")

subplot(2,2,1)
imshow(newImage)
title('Implemented Histogram Equalization Image')

subplot(2,2,2)
imhist(newImage,64)
title('Implemented Histogram Equalization Histogram')

subplot(2,2,3)
imshow(mLabHistIm)
title('Built-in Histogram Equalization Image')

subplot(2,2,4)
imhist(mLabHistIm,64)
title('Built-in Histogram Equalization Histogram')

%% Graph the difference in maps
figure(5);
subplot(1,2,1);
tempSArray = sArray/max(sArray);
scatter(rArray,tempSArray,'fill','black')
xlabel("r");
ylabel("s");
xlim([0,255]);
title("Implemented Histogram Equalization Map");

subplot(1,2,2);
scatter(rArray,matlabMap,'fill','black');
xlabel("r");
ylabel("s");
xlim([0,255]);
title("Builtin Histogram Equalization Map");

sgtitle('Maps of implemented histeq versus builtin histeq');

%% Notes
% The builtin matlab function equalizes by spreading each pixel values into
% the number of specified bins provided
