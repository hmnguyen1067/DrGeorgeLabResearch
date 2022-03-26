%%% This function segments and quantifies root branching using fractal dimension. The code will
%%% extract an image from a file, segment the root, apply the thresholding, the box-counting function
%%% and return the fractal dimension. The images here are extracted from a folder so
%%% there are extra inputs to accomadate for the directory

function dim = boxDimCalculator(thresholdFunction, folderDir, show)

%%% Allowing this many inputs gives a generic code that can be used for any
%%% group of any sample size. 

%%% The threshold is an input function using ColorThresholding.

format long g;
format compact;
fontSize = 20;

checkSub = dir(folderDir);

for k = 3:length(checkSub)
    subDir = checkSub(k).name;
    subFolPath = fullfile(folderDir, subDir);
    if (isfolder(subFolPath) && (strcmp(subDir, "Results") == 0))
        lol = boxDimCalculator(thresholdFunction, subFolPath, show);
    end
    
end

theFiles = dir(fullfile(folderDir, '*.jpg'));

dim = zeros(1,length(theFiles));
exportFolder = "Results";
saveFolder = fullfile(folderDir, exportFolder);
[~,currFolName,~] = fileparts(folderDir);

for i = 1:length(theFiles)
    % The image name
    imgName = theFiles(i).name;
    [~, imgNameNoExtension, ~] = fileparts(imgName);
    
    % The directory to the image
    img = fullfile(folderDir, imgName);
    img
    
    % Read the image and store the pizel values (color) in the matrix rgbImage
    rgbImage = imread(img);
    
    % Extract the root (according to specific pixels)
    rgbCropImage = imcrop(rgbImage, [2650 1000 5910-2650 3400-1000]);
    
    % Threshold using created function
    % Convert RGB image to chosen color space
    mask = thresholdFunction(rgbCropImage);
    
    % Extract the root
    %mask = mask(450:2950, 500:3050); 
    
    % Extract biggest blob.
    mask = bwareafilt(mask, 1);
    
    theFig = figure('visible', show);
    subplot(2,2,1);
    imshow(rgbCropImage);
    
    title('Original RGB Image', 'FontSize', fontSize, 'Interpreter', 'None');
    
    subplot(2,2,2);
    imagesc(mask)
    colormap gray
    axis image
    title('Mask Image', 'FontSize', fontSize, 'Interpreter', 'None');
    % Mask the image using bsxfun() function
    maskedRgbImage = bsxfun(@times, rgbCropImage, cast(mask, 'like', rgbCropImage));
    % Display final masked image
    
    subplot(2,2,3);
    imshow(maskedRgbImage)
    title('Masked RGB Image', 'FontSize', fontSize, 'Interpreter', 'None');
    % Set up figure properties:
    
    % Enlarge figure to full screen.
    set(theFig, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % Get rid of tool bar and pulldown menus that are along top of figure.
    %set(theFig, 'Toolbar', 'none', 'Menu', 'none');
    
    titleName = imgNameNoExtension;
    % Give a name to the title bar.
    set(theFig, 'Name', titleName, 'NumberTitle', 'Off')

    subplot(2,2,4);
    % Compute the box dimension
    dim(i) = BoxCountfracDim(mask); 
    
    imgNameSave = imgNameNoExtension + ".fig";
    
    if ~exist(saveFolder, 'dir')
       mkdir(saveFolder)
    end
    
    saveas(theFig, fullfile(saveFolder, imgNameSave));

end
    if isempty(theFiles) == 0
        theTable = table({theFiles.name}.', dim.', 'VariableNames', {'ImgName' 'FracDim'});
        writetable(theTable, fullfile(saveFolder, currFolName + ".txt"), "Delimiter", "\t") ;
    end

end

