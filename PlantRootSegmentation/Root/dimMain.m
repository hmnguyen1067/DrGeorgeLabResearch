clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
show = "on"; % "on" by default
folder = ".\TestImages";

dims = boxDimCalculator(@createMask, folder, show);