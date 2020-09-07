%%%%%%%%%%
% 4/4/2020
% RJD
% automatically segment fluorescent biopsy channels (green channel only)
% Inputs: im - three channel image input; numSeg - number of segments in
% biopsy, normally 1 but if biopsy is broken increase for each piece in
% image
% Outputs: BW - mask image, also displays mask image
%%%%%%%%%%
function BW = autoSeg(im, numSeg, cutoff)
    imG = im(:,:,2);
    BW = zeros(size(imG));
    BW(find(imG>cutoff)) = 1;
    BW = imfill(BW);
    BW = bwareafilt(logical(BW), numSeg);
    %imshow(BW);
end