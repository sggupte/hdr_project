% Takes relevant samples from the images for use in gsolve.m
%
%
function [ zRed, zGreen, zBlue, sampleIndices ] = makeImageMatrix(filenames, mask)

    % determine the number of differently exposed images
    numExposures = size(filenames,2);


    % Create the vector of sample indices
    % We need N(P-1) > (Zmax - Zmin)
    % Assuming the maximum (Zmax - Zmin) = 255,
    % N = (255 * 2) / (P-1) clearly fulfills this requirement
    numSamples = ceil(255*2 / (numExposures - 1)) * 2;

    % create a random sampling matrix, telling us which
    % pixels of the original image we want to sample
    % using ceil fits the indices into the range [1,numPixels+1],
    % i.e. exactly the range of indices of zInput
    %step = numPixels / numSamples;
    %sampleIndices = floor((1:step:numPixels));
    %sampleIndices = sampleIndices';
    
    % We need numSamples number of pixels
    % Input the mask in and sample randomly from inside the mask
    maskedPix = find(mask == 1)';
    
    numPixels = length(maskedPix);
    step = numPixels / numSamples;
    indexIntervals = floor((1:step:numPixels));
    sampleIndices = maskedPix(indexIntervals);

    maskSize = size(mask);
%     maskedPix = zeros(1,sum(sum(mask)));
%     maskIndex = 1;
%     for i = 1:maskSize(1)
%        for j = 1:maskSize(2)
%            if(mask(i,j) == 1)
%                %Add linear index to the maskedPix list
%                maskedPix(maskIndex) = sub2ind(maskSize,i,j);
%                maskIndex = maskIndex + 1;
%           end
%        end
%     end
    
    
    % Now we should have the linear indexes we can sample from
    %randIndices = randperm(length(maskedPix),numSamples);
    %sampleIndices = maskedPix(randIndices)';
    
    % Proof that the image is sampling from the masked region
%     im = zeros(maskSize(1),maskSize(2),3);
%     for k = 1:length(sampleIndices)
%         im(sampleIndices(k)) = 1;
%     end
%     figure;
%     im(:,:,3) = 0.5*(1-mask);
%     imshow(im)
    
    % allocate resulting matrices
    zRed = zeros(numSamples, numExposures);
    zGreen = zeros(numSamples, numExposures);
    zBlue = zeros(numSamples, numExposures);

    for i=1:numExposures

        % read the nth image
        fprintf('Reading image number %i...', i);
        image = imread(filenames{i});

        fprintf('sampling.\n');
        % sample the image for each color channel
        [zRedTemp, zGreenTemp, zBlueTemp] = sample(image, sampleIndices);

        % build the resulting, small image consisting
        % of samples of the original image
        zRed(:,i) = zRedTemp;
        zGreen(:,i) = zGreenTemp;
        zBlue(:,i) = zBlueTemp;
    end
end