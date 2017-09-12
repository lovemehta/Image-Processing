function [output] = MyCannyEdgeDetector_2014CSB1018(input, threshold)
 
    [~, ~, numberOfColorChannels] = size(input);
    if numberOfColorChannels > 1
        % It's a true color RGB image.  We need to convert to gray scale.
        input = rgb2gray(input);
    end
 
    % Processing Input image
    inputImg = double ((input));
 
    % Values for Thresholding
    thLow = threshold;
    thHigh = threshold / 3;
 
    % Gaussian Filter
    gaussF = 1 / 159 .* [2, 4, 5, 4, 2; 4, 9, 12, 9, 4; 5, 12, 15, 12, 5; 4, 9, 12, 9, 4; 2, 4, 5, 4, 2];
 
    % Sobel Filter for horizontal and vertical direction
    sobelX = [- 1, 0, 1; - 2, 0, 2; - 1, 0, 1];
    sobelY = [1, 2, 1; 0, 0, 0; - 1, - 2, - 1];
 
    % Convolution of image by Gaussian Coefficient
    smooth = conv2(inputImg, gaussF, 'same');
    [rows, columns] = size(smooth);
 
    % Convolution by image by horizontal and vertical filter
    Gx = conv2(smooth, sobelX, 'same');
    Gy = conv2(smooth, sobelY, 'same');
 
    % Calculating directions/orientations
    dir = (atan2 (Gy, Gx)) * 180 / pi;
    % Adjustment for negative directions, making all directions positive
    for i = 1:rows
        for j = 1:columns
            if (dir(i, j) < 0)
                dir(i, j) = 360 + dir(i, j);
            end;
        end;
    end;
 
    dirAdj = zeros(rows, columns);
 
    % Adjusting directions to nearest 0, 45, 90, or 135 degree
    for i = 1 : rows
        for j = 1 : columns
            if ((dir(i, j) >= 0) && (dir(i, j) < 22.5) || (dir(i, j) >= 157.5) && (dir(i, j) < 202.5) || (dir(i, j) >= 337.5) && (dir(i, j) <= 360))
                dirAdj(i, j) = 0;
            elseif ((dir(i, j) >= 22.5) && (dir(i, j) < 67.5) || (dir(i, j) >= 202.5) && (dir(i, j) < 247.5))
                dirAdj(i, j) = 45;
            elseif ((dir(i, j) >= 67.5 && dir(i, j) < 112.5) || (dir(i, j) >= 247.5 && dir(i, j) < 292.5))
                dirAdj(i, j) = 90;
            elseif ((dir(i, j) >= 112.5 && dir(i, j) < 157.5) || (dir(i, j) >= 292.5 && dir(i, j) < 337.5))
                dirAdj(i, j) = 135;
            end;
        end;
    end;
 
    % Calculate sqAdd
    sqAdd = (Gx .^ 2) + (Gy .^ 2);
    grMag = sqrt(sqAdd);
 
    temp = zeros (rows, columns);
 
    nmsImg = NMS(rows, columns, dirAdj, grMag, temp);
 
    trackedImg = HYST(thLow, thHigh, nmsImg, rows, columns);
 
    % Show final edge detection result
    output = trackedImg;
    figure();
    imshow(output);
end

function [output] = NMS(rows, columns, dirAdj, grMag, nmsImg)
    % Non-Maximum Supression
    for i = 2:rows - 1
        for j = 2:columns - 1
            if (dirAdj(i, j) == 0)
                nmsImg(i, j) = (grMag(i, j) == max([grMag(i, j), grMag(i, j + 1), grMag(i, j - 1)]));
            elseif (dirAdj(i, j) == 45)
                nmsImg(i, j) = (grMag(i, j) == max([grMag(i, j), grMag(i + 1, j - 1), grMag(i - 1, j + 1)]));
            elseif (dirAdj(i, j) == 90)
                nmsImg(i, j) = (grMag(i, j) == max([grMag(i, j), grMag(i + 1, j), grMag(i - 1, j)]));
            elseif (dirAdj(i, j) == 135)
                nmsImg(i, j) = (grMag(i, j) == max([grMag(i, j), grMag(i + 1, j + 1), grMag(i - 1, j - 1)]));
            end;
        end;
    end;
 
    nmsImg = nmsImg .* grMag;
    output = nmsImg;
end

function [output] = HYST(thLow, thHigh, nmsImg, rows, columns)
    % Hysteresis Thresholding
    thLow = thLow * max(max(nmsImg));
    thHigh = thHigh * max(max(nmsImg));
 
    tempHyst = zeros (rows, columns);
 
    for i = 1 : rows
        for j = 1 : columns
            if (nmsImg(i, j) < thLow)
                tempHyst(i, j) = 0;
            elseif (nmsImg(i, j) > thHigh)
                tempHyst(i, j) = 1;
                % Using 8-connected components
            elseif (nmsImg(i + 1, j) > thHigh || nmsImg(i - 1, j) > thHigh || nmsImg(i, j + 1) > thHigh || nmsImg(i, j - 1) > thHigh || nmsImg(i - 1, j - 1) > thHigh || nmsImg(i - 1, j + 1) > thHigh || nmsImg(i + 1, j + 1) > thHigh || nmsImg(i + 1, j - 1) > thHigh)
                tempHyst(i, j) = 1;
            end;
        end;
    end;
 
    output = (tempHyst .* 255);
 
end

