% Segment the images and save them to a new directory
function saveSegmented(filenames, cutoff, numSeg)
    % Make folder called HDR_segmented
    mkdir HDR_Segmented
    
    % Generate the mask
    image = imread(filenames{1});
    mask = uint8(autoSeg(image, cutoff, numSeg));
    
    for i = 1:size(filenames,2)
        filename = filenames{i};
        
        [s,f] = regexp(filename, '(\d+)');
        numerator = filename(s(1):f(1));
        denominator = filename(s(2):f(2));
        newName = strcat('seg_',numerator,'_',denominator,'.tif');
        
        seg_image = mask.*image;
        
        cd HDR_segmented/
        imwrite(seg_image,newName);
        cd ..
        
        image = imread(filenames{i});
    end
    
end