%% HDR Setup! (Run the next few blocks individually to set up)

%% Run this block to read images and get filenames and create a mask

%  Read Images
fprintf('Enter the location of your images and end the directory with a "/" at the end\n');
imageLocation = input('../Images/','s');

dirName = strcat('../Images/',imageLocation);

% Load the file name and all the exposures
[filenames, exposures, numExposures] = ReadImagesMetaData(dirName);
tmp = imread(filenames{1});

% Create a Mask (Depending on which option the user inputs, the following code will run)
ui = input('Chose 1 (no mask), 2 (green thresholded mask), 3 (custom loaded mask)');
if(ui ~= 2 && ui ~= 3)
%   Option 1: don't Use a Mask
    fprintf('No mask chosen\n');
    mask = ones(size(tmp));
    mask = mask(:,:,1);
elseif(ui == 2)
%   Option 2: Use a Thresholded Mask based on the green channel of the 
%       first image in the folder
    fprintf('Using thresholded mask\n');
    numSeg = input('How many objects are there to segment in the image?\n');
    cutoff = input('What is the pixel cutoff?\n');
    mask = autoSeg(tmp,numSeg,cutoff);
else
%   Option 3: Use a Custom Mask or a Graph Cuts Mask
    fprintf('Custom mask chosen\n');
    fprintf('Please load your mask into the workspace before running the next block of code\n');
end

%% Save your Segmented Images
saveSegmentedWMask(mask,filenames,'Segmented');
