function [finalCorners] = MyDetectedInterest_2014CSB1018(input, threshold)
    % Get the number of rows and columns,
    % and, most importantly, the number of color channels.
    [~, ~, numberOfColorChannels] = size(input);
    if numberOfColorChannels > 1
        % It's a true color RGB image.  We need to convert to gray scale.
        image = rgb2gray(input);
    else
        image = input;
    end
 
    [rows, columns] = size(image);
    image=MyCannyEdgeDetector_2014CSB1018(image,threshold);
    corners = zeros(rows, columns);
 
    % Gaussian Filter
    gaussF = 1 / 159 .* [2, 4, 5, 4, 2; 4, 9, 12, 9, 4; 5, 12, 15, 12, 5; 4, 9, 12, 9, 4; 2, 4, 5, 4, 2];
 
    % Sobel Filter for horizontal and vertical direction
    sobelX = [- 1, 0, 1; - 2, 0, 2; - 1, 0, 1];
    sobelY = [1, 2, 1; 0, 0, 0; - 1, - 2, - 1];
 
    % Convolution by horizontal and vertical filter
 
    Ix = conv2(image, sobelX, 'same');
    Iy = conv2(image, sobelY, 'same');
    Ix2 = Ix .* Ix;
    Iy2 = Iy .* Iy;
    Ixy = Ix .* Iy;
 
    % Convolution by Gaussian Coefficient
 
    Ix2 = conv2(Ix2, gaussF, 'same');
    Iy2 = conv2(Iy2, gaussF, 'same');
    Ixy = conv2(Ixy, gaussF, 'same');
 
    for i = 1:rows
        for j = 1:columns
            M = [Ix2(i, j) Ixy(i, j); Ixy(i, j) Iy2(i, j)];
            corners(i, j) = det(double(M)) - 0.01 * trace(double(M)) ^ 2;
        end
    end
    corners = - 1 * corners * (255 / min(min(corners)));
    for i = 1:rows
        for j = 1:columns
            if corners(i, j) < threshold
                corners(i, j) = 0;
            end
        end
    end
    for i = 2:rows - 1
        for j = 2:columns - 1
            if corners(i, j) < corners(i + 1, j + 1) || corners(i, j) < corners(i + 1, j) || corners(i, j) < corners(i, j + 1) || corners(i, j) < corners(i - 1, j) || corners(i, j) < corners(i, j - 1) || corners(i, j) < corners(i - 1, j + 1) || corners(i, j) < corners(i + 1, j - 1) || corners(i, j) < corners(i - 1, j - 1)
                corners(i, j) = 0;
            end
        end
    end
    finalCorners=zeros(rows,columns);
    for i = 1:rows
        for j = 1:columns
            if corners(i, j) ~= 0
                finalCorners(i, j) = 255;
            end
        end
    end
    C = imfuse(finalCorners,input);
    imwrite(C,'Corners Displayed on the original image.png')
    figure();
    imshow(C);
end
 