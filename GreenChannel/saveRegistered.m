% Segment the images and save them to a new directory
function saveRegistered(filenames, dirName)
    % Make folder called at specified imput
    cd(dirName);
    mkdir regImages;
    
    % Create Optimizer and Fixed Image
    filename = filenames{1};
    fixed = imread(filename);
    [optimizer,metric] = imregconfig('multimodal'); %multimodal for images with varying contrasts
    
    % Jump into regImages folder and write the first fixed image to the folder
    [s,f] = regexp(filename, '(\d+)');
    numerator = filename(s(1):f(1));
    denominator = filename(s(2):f(2));
    newName = strcat('reg_',numerator,'_',denominator,'.tif');
    
    cd regImages/;
    imwrite(fixed, newName);
    cd ..;
    
    % Register the rest of the files to the first one
    % Start from the second image to not register the first image to itself
    for i = 2:size(filenames,2)
        moving = imread(filenames{i});
        filename = filenames{i};
        
        [s,f] = regexp(filename, '(\d+)');
        numerator = filename(s(1):f(1));
        denominator = filename(s(2):f(2));
        newName = strcat('reg_',numerator,'_',denominator,'.tif');
        
        newRedImage = imregister(fixed(:,:,1), moving(:,:,1), 'rigid', optimizer, metric);
        newGreenImage = imregister(fixed(:,:,2), moving(:,:,2), 'rigid', optimizer, metric);
        newBlueImage = imregister(fixed(:,:,3), moving(:,:,3), 'rigid', optimizer, metric);
        
        newImage = cat(3,newRedImage, newGreenImage, newBlueImage);
        
        cd regImages/;
        imwrite(newImage,newName);
        cd ..;
    end
    
end