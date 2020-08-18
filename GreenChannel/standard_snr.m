function snr = standard_snr(image)
    [numRows, numCols] = size(image);
    signal = mean(reshape(image,1,numRows*numCols));
    noise = std(reshape(image,1,numRows*numCols));
    
    snr = 10*log10(signal/noise); % Answer is expressed in dBs
end
