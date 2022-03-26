%%% This function segments and quantifies leaf area. The code will
%%% extract an image from a file, segment the leaves, quantify the area,
%%% and return the area. The images here are extracted from a folder so
%%% there are extra inputs to accomadate for the directory

function areas = colorAreaCalculator(folderDir, thresholdFunction, show)

%%% Allowing this many inputs gives a generic code that can be used for any
%%% group of any sample size. 

%%% The threshold is an input function using ColorThresholding.

format long g;
format compact;
fontSize = 20;

if nargin<3
    show = false;
end

theFiles = dir(fullfile(folderDir, '*.jpg'));

areas = zeros(1,length(theFiles));
exportFolder = "Results";
saveFolder = fullfile(folderDir, exportFolder);
[~,currFolName,~] = fileparts(folderDir);

for i = 1:length(theFiles)
    
    % the image name
    imgName = theFiles(i).name;
    [~, imgNameNoExtension, ~] = fileparts(imgName);
    
    % the directory to the image
    img = fullfile(folderDir, imgName);
    img
    
    % read the image and store the pixel values (color) in the matrix rgbImage
    rgbImage = imread(img);
    
    % Threshold using created function
    % Convert RGB image to chosen color space
    mask = thresholdFunction(rgbImage);

    % Extract biggest blob.
    mask = bwareafilt(mask, 1);
    
    % Fill holes.
    mask=imfill(mask,'holes');

    theFig = figure('visible', show);
    
    subplot(2,2,1);
    imshow(rgbImage);
    title('Original RGB Image', 'FontSize', fontSize, 'Interpreter', 'None');

    subplot(2,2,2);
    imshow(mask)
    title('Mask Image', 'FontSize', fontSize, 'Interpreter', 'None');
    % Mask the image using bsxfun() function
    maskedRgbImage = bsxfun(@times, rgbImage, cast(mask, 'like', rgbImage));
    % Display final masked image

    subplot(2,2,3);
    imshow(maskedRgbImage)
    title('Masked RGB Image'+ " " + nnz(mask)+ " "+"pixels", 'FontSize', fontSize, 'Interpreter', 'None');
    % Set up figure properties:

    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % Get rid of tool bar and pulldown menus that are along top of figure.
    %set(gcf, 'Toolbar', 'none', 'Menu', 'none');

    titleName = imgNameNoExtension;
    % Give a name to the title bar.
    set(gcf, 'Name', titleName, 'NumberTitle', 'Off')

    % compute the number of pixels that are not zero
    areas(i)  = nnz(mask);   %calculate area

    imgNameSave = imgNameNoExtension + ".fig";
    
    if ~exist(saveFolder, 'dir')
       mkdir(saveFolder)
    end
    
    saveas(theFig, fullfile(saveFolder, imgNameSave));
    
end

    if isempty(theFiles) == 0
        theTable = table({theFiles.name}.', areas.', 'VariableNames', {'ImgName' 'Area in pixels'});
        writetable(theTable, fullfile(saveFolder, currFolName + ".txt"), "Delimiter", "\t") ;
    end

end

