%% Prepare Images from HDR_main (only green channel)
ldr1 = imread(filenames{1});
ldr2 = imread(filenames{2});
ldr3 = imread(filenames{3});

ldr1 = ldr1(:,:,2);
ldr2 = ldr2(:,:,2);
ldr3 = ldr3(:,:,2);

hdrComp = greenImage(:,:,2);

%% Convert ldrs to double using maximum value of hdrComp to scale

maxVal = max(max(hdrComp));

%hdrComp = uint8((hdrComp/maxVal)*255);

ldr1 = maxVal.*double(ldr1);
ldr2 = maxVal.*double(ldr2);
ldr3 = maxVal.*double(ldr3);

%% Calculate PSNR
% order of these params don't matter

peaksnr1 = psnr(hdrComp,ldr1);
peaksnr2 = psnr(hdrComp,ldr2);
peaksnr3 = psnr(hdrComp,ldr3);