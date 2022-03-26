clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.

imagesDir = ".\TestImages";

areas = colorAreaCalculator(imagesDir,@createMask, true);