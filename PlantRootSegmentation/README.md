# Plant image segmentation for area measurement and root segmentation for fractal dimension calculation

In the case of our research, in order to investigate the effects of different treatments to the growth of plant and root, we consider the area of the plants and the measurement of root branching as the main metrics for comparison.

## Installation

I use `Matlab=R2020a` along with Color Thresholder app in Image Processing Toolbox.

## Description

### Plant

Given an image, the program will store the colors of the image in pixel values to a matrix then we use the app Color Thresholding in Matlab with a specific setting for HSV color space to segment out the color range of green in the plant. As there can be a lot of noise in the segmentation due to the variety of color green in the picture, we only extract the biggest color blob and fill in the holes. After the segmentation, we can calculate the total number of non-zero pixels in it and divide it by the number of pixels per centimeter measured by Fiji to get the area of the leaves. Last but not least, we let the program run through every image to generate area data for the graphs.

### Root

For root, the program will be similar to plant segmentation. However, instead of calculating the area of the roots, it will return the fractal dimension unit, in this case is the Minkowski–Bouligand dimension.

## Running

### Plant

The file areaMain.m is used in order to generate result for the area by using the function colorAreaCalculator.m and createMask.m (created from Color Thresholding).

### Root

The file dimMain.m is used in order to generate result for the area by using the function boxDimCalculator.m, BoxCountfracDim.m and createMask.m (created from Color Thresholding).
