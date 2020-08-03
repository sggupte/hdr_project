# hdr_project
hdr Matlab implementation with fluorescence imaging

Code based on https://www.researchgate.net/publication/327545585_Deep_dive_into_high_dynamic_range_imaging_a_Matlab_tutorial
Adapted for green channel fluorescence imaging

Do this:
1.) Run the HDR_main.m script to generate filenames and dirNames. Use these to run other scripts.
2.) Use the saveSegmented.m script to segment the images and save them in a folder.
3.) Then use the saveRegistered.m script to register all the images and save them in a folder.
4.) Both these scripts will save the files as tifs.
5.) Run the HDR_main.m script to run the HDR algorithm.