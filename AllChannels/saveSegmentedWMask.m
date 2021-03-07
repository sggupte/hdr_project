% Function that takes in the mask, applies it to a folder full of images,
% and saves them in the current working directory
% Inputs -
%   mask:       the image mask made of 0 background, 1 foreground
%   filenames:  an array of cells with the filepaths to each image. This
%               output from ReadImagesMetaData(dirName)
%   foldername: a string name of the folder you would like these images to
%               be saved to
% Outputs - void
function saveSegmentedWMask(mask, filenames, foldername)
    % cd to the folder one outside of the folder where the images are
    % located
    tmp = split(filenames(1),'/');
    
    revDir = "";
    for i = 1:(length(tmp)-2)
        revDir = strcat(revDir,tmp(i),'/');
    end
    cd(revDir);
    
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
    
    folderCD = strcat('..','/',folderCD,'Images/');
    
    cd(string(tmp(length(tmp)-1)))
    
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
        
        %Inside Originals Folder
        imPath = split(filenames{i},'/');
        imName = imPath{length(imPath)};
        image = imread(imName);
        
        seg_image = mask.*image;
        i = i + 1;
        
        %Inside Images Folder
        cd(folderCD);
        imwrite(seg_image,newName);
        
        %Go back to the Originals folder
        cd ../..
        cd(imPath{length(imPath)-1})
    end
    
    % Go back to the main folder
    for i = 1:(length(tmp)-2)
        cd ..
    end
    cd AllChannels
    
end