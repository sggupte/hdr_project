function [newImage, newHistoValues] = myHistEq(image)
    [numRows, numCols] = size(image);
    % Calculate the original histogram
    histoValues = zeros(256,1);
    for row = 1:600
        for col = 1:800
            r = image(row,col);
            index = int16(r) + 1;
            histoValues(index) = histoValues(index) + 1;
        end
    end

    histoValues = histoValues/(numRows*numCols); %Normalize

    % Display the original histogram
    rArray = linspace(0,255,256);
    figure(1);
    stem(rArray, histoValues, 'Marker', 'none')
    xlim([0,255]);
    xlabel('Pixel Values')
    ylabel('Probability')

    % Calculate the Map
    sArray = zeros(256,1);
    for s = 1:256
        for i = 1:s
            sArray(s) = sArray(s) + 255*histoValues(i); %(L-1)*integral(Pr) from 0 to s
        end
    end

    % Display the Map
    figure(2);
    plot(rArray,sArray)
    xlabel("r");
    ylabel("s");
    xlim([0,255]);

    % Equalize the image
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
end