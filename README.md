# hdr_project
## Overview
hdr Matlab implementation with fluorescence imaging

Code based on https://www.researchgate.net/publication/327545585_Deep_dive_into_high_dynamic_range_imaging_a_Matlab_tutorial
Adapted for green channel fluorescence imaging

## Do this to segment/register and then run:
1.) Choose either Green Channel only or All Channels folder
2.) Run the HDR_main.m script to generate filenames and dirNames. Use these to run other scripts such as saveSegmented.
3.) Use the saveSegmented.m script to segment the images and save them in a folder. saveSegmented takes 3 arguments:
saveSegmented(filenames, thresholding % x 100, number of objects to segment) The folder will be output with the filename of "HDR_Segmented" and will be created in the current folder.
4.) Then use the saveRegistered.m script to register all the images and save them in a folder (optional)
5.) Both these scripts will save the files as tifs.
6.) Move segmented or registered files to the Images Folder with the originals, adding the originals in a separate subfolder and the segment in their own subfolder (See Image Folder Structure)
7.) Run the HDR_main.m script to run the HDR algorithm, specifying the new filepath

## Images Folder Structure
Include all ldr images in a folder. You cannot have a folder and standalone images in one folder. Make sure the folder you are taking images from ONLY has images. The code will ignore .DS_Store files files names '.' and '..'
Please do not include any other files in the folder with ldr images

### File naming convention
Each file should be labeled as such:
'imageName_numerator_denominator'.filetype
Numerator and denominator correspond to the exposure of that image. For example, a tif image with an exposure of 1/4 should be named 'im_1_4.tif'
imageName cannot contain any numbers. Please use the folder name to specify the series of images.
