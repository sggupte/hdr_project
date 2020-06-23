function [ luminanceMap ] = makeLuminanceMap( image )
    %Creates a luminance map from an image
    %
    % The input image is expected to be a 3d matrix of size rows*columns*3
    %luminanceMap = 0.2125 * image(:,:,1) + 0.7154 * image(:,:,2) + 0.0721 * image(:,:,3);
    % Testing for one channel
    luminanceMap = 0.7154*image(:,:,2);
end