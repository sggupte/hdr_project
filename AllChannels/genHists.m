% Function to make histograms of all the ldr images
%
% Since this has a visual purpose, we will convert the histograms to uint8
% and create 256 bins
% This function will also plot all the histograms on subplots
%
% Inputs:
%   ldr1,ldr2,ldr3 -    uint8  3 channel ldr images
%   hdr -               double 3 channel hdr images
%   mask -              logical region to calculate histogram over
% Outputs:
%   hist1,hist2,hist3 - double vector (size 256) with num pixels per bin
%                       for channel 1, 2, and 3 (RGB)
%   histHDR -           double vector (size 256) with sum hist1, hist2,
%                       hist3


function [hist1, hist2, hist3, histHDR] = genHists(ldr1,ldr2,ldr3,hdr,mask)

    [x,y,channels] = size(ldr1); % Assuming same size for all images
    
    hist1 = zeros(1,256);
    hist2 = zeros(1,256);
    hist3 = zeros(1,256);
    histHDR = zeros(1,256);
    
    % Convert the hdr image in to a uint8 type
    hdr_uint8 = uint8(hdr/max(max(max(hdr))) * 255);
    
    % convert back to a double
    ldr1 = double(ldr1);
    ldr2 = double(ldr2);
    ldr3 = double(ldr3);
    hdr = double(hdr_uint8);
    
    % Where the mask is 0, set the image value to be -1
    % It will not be factored in to the final histogram now
    for i = 1:x
        for j = 1:y
            if(mask(i,j) == 0)
                ldr1(i,j,:) = -1;
                ldr2(i,j,:) = -1;
                ldr3(i,j,:) = -1;
                hdr(i,j,:) = -1;
            end
        end
    end
    
    for c = 1:channels % 3 channels
        for i = 1:x
            for j = 1:y
                if(ldr1(i,j,c) ~= -1)
                    ldrPix1 = ldr1(i,j,c);
                    ldrPix2 = ldr2(i,j,c);
                    ldrPix3 = ldr3(i,j,c);
                    hdrPix = hdr(i,j,c);
                
                    hist1(ldrPix1+1) = hist1(ldrPix1+1) + 1;
                    hist2(ldrPix2+1) = hist1(ldrPix2+1) + 1;
                    hist3(ldrPix3+1) = hist1(ldrPix3+1) + 1; 
                    histHDR(hdrPix+1) = histHDR(hdrPix+1) + 1;
                end
            end
        end
    end

    % Plot the histograms
    maxY = 8000;
    
    figure;
    suptitle('Histograms for Green Channel LDR Images and HDR Image');
    subplot(2,2,1);plot(hist1);title('Neg4');xlim([1,256]);ylim([1,maxY]);xlabel('Pixel Value');
    subplot(2,2,2);plot(hist2);title('Neg5');xlim([1,256]);ylim([1,maxY]);xlabel('Pixel Value');
    subplot(2,2,3);plot(hist3);title('Neg6');xlim([1,256]);ylim([1,maxY]);xlabel('Pixel Value');
    subplot(2,2,4);plot(histHDR);title('HDR');xlim([1,256]);ylim([1,maxY]);xlabel('Pixel Value');
end