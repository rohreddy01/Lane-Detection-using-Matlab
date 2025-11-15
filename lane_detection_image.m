%% Lane Detection for a Single Image
clear; close all; clc;

% Load image
img = imread('data/road.png');
figure; imshow(img); title('Original Image');

% Convert to grayscale
gray = rgb2gray(img);

% Noise reduction
blurred = imgaussfilt(gray, 2);

% Edge detection
edges = edge(blurred, 'Canny');
figure; imshow(edges); title('Canny Edges');

% Region of Interest (ROI)
mask = poly2mask([100 500 900 300], [700 400 400 700], size(edges,1), size(edges,2));
roi = edges .* mask;
figure; imshow(roi); title('Region of Interest');

% Hough Transform
[H, theta, rho] = hough(roi);
peaks = houghpeaks(H, 5);
lines = houghlines(roi, theta, rho, peaks, 'FillGap', 30, 'MinLength', 40);

% Show final detected lanes
figure; imshow(img); hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 4, 'Color', 'yellow');
end
title('Detected Lane Lines');
hold off;
