%% Run setup.m before running this code

%% Display a grid with the original images
% Create an array of all the LDR images
ldrArray = cell(1,size(filenames,2));

% Show the original LDR Images and save them in ldrArray
% Comment lines a,b,c,d, and e to hide the images
fprintf('Opening test images\n');                           %a
figure('units','normalized','outerposition',[0 0 1 1]);     %b
suptitle('Original LDR Images Read');                       %c
 for i=1:size(filenames,2)
     subplot(1,size(filenames,2),i),imshow(filenames{i});   %d
     title(['Image Exposure ' num2str(exposures(i))])       %e
     ldrArray(i) = {imread(filenames{i})};                  %f
 end

%% Do some math
% define lamda smoothing factor
l = 50;

fprintf('Computing weighting function\n');
% precompute the weighting function value for each pixel
% Use a triangle shaped weighting function that weights the center more
% heavily than the edges to reduce saturation and low signal noise
weights = zeros(1,256);
for i=1:256
    weights(i) = weight(i,1,256);
end

% load and sample the images
fprintf('Creating exposures matrix B\n')
[zRed, zGreen, zBlue, sampleIndices] = makeImageMatrix(filenames, mask);
B = zeros(size(zRed,1)*size(zRed,2), numExposures);
for i = 1:numExposures
    B(:,i) = log(exposures(i));
end

% Calculate g functions for each channel, making sure each g function is
% monotonic
isItMonotonic = false;
while(~isItMonotonic)
    fprintf('lambda = %d\n',l);
    
    % solve the system for each color channel
    fprintf('Solving for red channel\n')
    [gRed,lERed]=gsolve(zRed, B, l, weights);
    fprintf('Solving for green channel\n')
    [gGreen,lEGreen]=gsolve(zGreen, B, l, weights);
    fprintf('Solving for blue channel\n')
    [gBlue,lEBlue]=gsolve(zBlue, B, l, weights);
    save('gMatrix.mat','gRed', 'gGreen', 'gBlue');
    
    if(isMonotonic(gRed)&&isMonotonic(gGreen)&&isMonotonic(gBlue))
        isItMonotonic = true;
        fprintf('Function is now monotonic\n')
    else
        l = l + 25; %Increase by increments of 15 until everything is monotonic
    end
end

%% Show the plots for each g function
sup = "CFR \lambda = " + l;
figure; suptitle(sup);
subplot(3,1,1);plot(gRed);ylabel("Red");
subplot(3,1,2);plot(gGreen);ylabel("Green");
subplot(3,1,3);plot(gBlue);ylabel("Blue");

%% Compute the radiance map
% compute the hdr radiance map
fprintf('Computing hdr image\n')
hdrMap = hdr(filenames, gRed, gGreen, gBlue, weights, B);

%% Additional Normalizations
% hdrMap2: all channels are normalized by the largest value of all 3 channels
hdrMap2 = hdrMap/max(max(max(hdrMap)));
%figure, imshow(hdrMap2);
%title('Total Maximum Normalized');

% hdrMap3: each channel is normalized by the largest value in the channel
hdrMap3(:,:,1) = hdrMap(:,:,1)/max(max(hdrMap(:,:,1)));
hdrMap3(:,:,2) = hdrMap(:,:,2)/max(max(hdrMap(:,:,2)));
hdrMap3(:,:,3) = hdrMap(:,:,3)/max(max(hdrMap(:,:,3)));
%figure,imshow(hdrMap3);
%title('Channel Normalized');

%% Show the image of the hdrMap Green Channel with green color
dim = size(hdrMap);
allBlack = zeros(dim(1),dim(2), 'double');
greenImage = cat(3, allBlack, hdrMap3(:,:,2), allBlack);

greenImage = double(mask).*greenImage;

%figure,imshow(greenImage);
%titleName = strcat('Green Channel (\lambda=', num2str(l), ')');
%title(titleName);

%% Scale to fit display range
minHDR = min(min(hdrMap(:,:,2)));
maxHDR = max(max(hdrMap(:,:,2)));
hdrDisp = (hdrMap(:,:,2) - minHDR)/(maxHDR-minHDR);

%figure;
%imshow(hdrDisp);
%title('HDR Scaled for Display Range');

%% Save images as normalized .tif files
% This section of code is good if you want to compare the intensities of
% several images to one image

% maxIntensity = 8.4970;    % preset the max intensity here that you want
% to compare to
% manNormHDR = uint16((2^16 - 1)*double(mask).*hdrMap(:,:,2)/maxIntensity);
% 
% cd phantomImages
% imwrite(manNormHDR,'norm6_25uM.tif');
% 
% cd ..

%% Save all standard normalizations in a folder outside the folder the images were retreived from
cd ../Images
cd(imageLocation)
cd ..

mkdir hdrImages

% SAVE ALL YOUR IMAGES HERE!
cd hdrImages
imwrite(hdrMap2,'overallNormalizedHDRData.tif');
imwrite(hdrMap3,'channelNormalizedHDRData.tif');
% You can manually add more lines of code to save your hdr Images

cd ..

% Go back to the main  folder
numDirectories = length(strsplit(imageLocation,'/'))-1;
tmp = "";
for i = 1:numDirectories
    tmp = strcat(tmp,'../');
end

cd(tmp)
cd AllChannels

fprintf('Finished!\n');
