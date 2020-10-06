% -------------------------------------------------------------------------
% Implements a complete hdr and tonemapping cycle
%
% 1.: Computes the camera response curve according to "Recovering High
% Dynamic Range Radiance Maps from Photographs" by P. Debevec.
% You need a wide range of differently exposed pictures from the same scene
% to get good results.
%
% 2.: Recovers a hdr radiance map from the range of ldr pictures
%
% 3.: Tonemaps the resulting hdr radiance map according to "Photographic
% Tone Reproduction for Digital Images" by Reinhard et al.
% Both the simple global and the more complex local tonemapping operator
% are applied to the hdr radiance map.
%
% Some code taken from Paul Debevec's implementation of his SIGGRAPH'97
% paper "Recovering High Dynamic Range Radiance Maps from Photographs"
% -------------------------------------------------------------------------

% clc;clear all;close all;

% Specify the directory that contains your range of differently exposed
% pictures. Needs to have a '/' at the end.
% The images need to have exposure information encoded in the filename,
% i.e. the filename 'window_exp_1_60.jpg' would indicate that this image
% has been exposed for 1/60 second. See readDir.m for details.

dirName = ('../Images/11_M1T1B1-HRWL/Originals/');

[filenames, exposures, numExposures] = ReadImagesMetaData(dirName);

tmp = imread(filenames{1});
numPixels = size(tmp,1) * size(tmp,2);
numExposures = size(filenames,2);

% Show the image sequence and the coresponding exposures
fprintf('Opening test images\n');
figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:size(filenames,2)
    subplot(1,size(filenames,2),i),imshow(filenames{i});
    title(['Image Exposure ' num2str(exposures(i))])
end

% Save all ldr images
ldr1 = imread(filenames{1});
ldr2 = imread(filenames{2});
ldr3 = imread(filenames{3});

% define lamda smoothing factor

l = 50;

fprintf('Computing weighting function\n');
% precompute the weighting function value
% for each pixel
weights = [];
for i=1:256
    weights(i) = weight(i,1,256); % Creates the weight for each pixel and zmin,zmax
end

% load and sample the images
[zRed, zGreen, zBlue, sampleIndices] = makeImageMatrix(filenames, numPixels);

B = zeros(size(zRed,1)*size(zRed,2), numExposures);

fprintf('Creating exposures matrix B\n')
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
    else
        l = l + 25; %Increase by increments of 15 until everything is monotonic
    end
end

% Plot the response function for every colour channel
temp = linspace(1,256,256);

% compute the hdr radiance map
fprintf('Computing hdr image\n')
hdrMap = hdr(filenames, gRed, gGreen, gBlue, weights, B);

figure,imshow(hdrMap);title('Irradiance HDR map');

% apply Reinhard local tonemapping operator to the hdr radiance map
fprintf('Tonemapping - Reinhard local operator\n');
saturation = 0.6;
eps = 0.05;
phi = 8;
[ldrLocal, luminanceLocal, v, v1Final, sm ] = reinhardLocal(hdrMap, saturation, eps, phi);

% apply Reinhard global tonemapping oparator to the hdr radiance map
fprintf('Tonemapping - Reinhard global operator\n');

% specify resulting brightness of the tonampped image. See reinhardGlobal.m
% for details
a = 0.72;

% specify saturation of the resulting tonemapped image. See reinhardGlobal.m
% for details
saturation = 0.6;

[ldrGlobal, luminanceGlobal ] = reinhardGlobal( hdrMap, a, saturation );

% Show only the green channels
%allBlack = zeros(size(ldrGlobal, 1), size(ldrGlobal, 2), 'double');
%ldrGlobal = cat(3, allBlack, ldrGlobal(:,:,2), allBlack);
%ldrLocal = cat(3, allBlack, ldrLocal(:,:,2), allBlack);

figure,imshow(ldrGlobal);
title('Reinhard global operator');

figure,imshow(ldrLocal);
title('Reinhard local operator');

% Save hdr file as a 16 bit uint image
uint16_hdrMap = uint16((2^16 - 1)*(hdrMap));
imwrite(uint16_hdrMap,"hdrMap.tif");

fprintf('Finished!\n');

%% Additional Normalizations
hdrMap2 = hdrMap/max(max(max(hdrMap)));
figure, imshow(hdrMap2);
title('Total Maximum Normalized');

hdrMap3(:,:,1) = hdrMap(:,:,1)/max(max(hdrMap(:,:,1)));
hdrMap3(:,:,2) = hdrMap(:,:,2)/max(max(hdrMap(:,:,2)));
hdrMap3(:,:,3) = hdrMap(:,:,3)/max(max(hdrMap(:,:,3)));
figure,imshow(hdrMap3);
title('Channel Normalized');

%% Show the plots for each g function
sup = "CFR \lambda = " + l;
figure; suptitle(sup);
subplot(3,1,1);plot(gRed);ylabel("Red");
subplot(3,1,2);plot(gGreen);ylabel("Green");
subplot(3,1,3);plot(gBlue);ylabel("Blue");

%% Show the image of the hdrMap Green Channel with green color
dim = size(hdrMap);
allBlack = zeros(dim(1),dim(2), 'double');
greenImage = cat(3, allBlack, hdrMap3(:,:,2), allBlack);

mask = autoSeg(greenImage, 1, 0.16);
greenImage = double(mask).*greenImage;

figure,imshow(greenImage);
titleName = strcat('Green Channel (\lambda=', num2str(l), ')');
title(titleName);