%% Lane Detection for a Video
clear; close all; clc;

video = VideoReader('data/lane_video.mp4');
output = VideoWriter('results/output_video.mp4', 'MPEG-4');
open(output);

while hasFrame(video)
    frame = readFrame(video);

    gray = rgb2gray(frame);
    blurred = imgaussfilt(gray, 2);
    edges = edge(blurred, 'Canny');

    mask = poly2mask([100 500 900 300], ...
                     [700 400 400 700], size(edges,1), size(edges,2));
    roi = edges .* mask;

    [H, theta, rho] = hough(roi);
    peaks = houghpeaks(H, 5);
    lines = houghlines(roi, theta, rho, peaks, 'FillGap', 30, 'MinLength', 40);

    % Overlay lines
    result = frame;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        result = insertShape(result, 'Line', [xy(1,1), xy(1,2), xy(2,1), xy(2,2)], ...
                             'LineWidth', 4, 'Color', 'yellow');
    end

    writeVideo(output, result);
end

close(output);
disp("Video processing complete. File saved in results/");
