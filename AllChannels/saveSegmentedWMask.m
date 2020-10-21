% Function that takes in the mask, applies it to a folder full of images,
% and saves them in the current working directory
% Inputs -
%   mask:       the image mask
%   filenames:  an array of cells with the filepaths to each image. This
%               output from ReadImagesMetaData(dirName)
%   foldername: a string name of the folder you would like these images to
%               be saved to
% Outputs - void
function saveSegmentedWMask(mask, filenames, foldername)
    % Make folder called HDR_segmented
    mkdir(foldername)
    
    folderCD = strcat(foldername,'/');
    
    mask = uint8(mask);
    
    cd(folderCD)
    mkdir mask;
    cd mask;
    save('mask.mat','mask');
    cd ..
    
    mkdir Images
    cd ..
    
    folderCD = strcat(folderCD,'Images/');
    
    i = 1;
    for filepath = filenames
        % This allows us to label the file and all folders with numbers
        cFilepath = split(filepath,'/');
        lenFilepath = size(cFilepath);
        lenFilepath = lenFilepath(1);
        filename = cFilepath{lenFilepath};
        
        [s,f] = regexp(filename, '(\d+)');
        numerator = filename(s(1):f(1));
        denominator = filename(s(2):f(2));
        newName = strcat('seg_',numerator,'_',denominator,'.tif');
        
        image = imread(filenames{i});
        seg_image = mask.*image;
        i = i + 1;
        
        cd(folderCD);
        imwrite(seg_image,newName);
        cd ../..
    end
end