function []= MyCompareOutput_2014CSB1018(input, threshold)
 
    % Get the number of rows and columns,
    % and, most importantly, the number of color channels.
    [~, ~, numberOfColorChannels] = size(input);
    if numberOfColorChannels > 1
        % It's a true color RGB image.  We need to convert to gray scale.
        input = rgb2gray(input);
    end
    trackedImg = (MyCannyEdgeDetector_2014CSB1018(input, threshold));
    edgeImg = (edge(((input)), 'canny', threshold));
 
    % Euclidean distance
 
    [rows, columns] = size(((input)));
    blockwiseX = floor(rows / 3);
    blockwiseY = floor(columns / 3);
 
    % PSNR and Euclidean Distance Measures
 
    psnr = zeros(blockwiseX, blockwiseY);
    euDis = zeros(blockwiseX, blockwiseY);
    for i = 1:blockwiseX
        for j = 1:blockwiseY
            block1 = trackedImg(3 * i - 2:3 * i, 3 * j - 2:3 * j);
            block2 = edgeImg(3 * i - 2:3 * i, 3 * j - 2:3 * j);
            euDis(i, j) = abs(sumsqr(block2) - sumsqr(block1));
            MSE = sum(sum((block2 - block1) .^ 2)) / (3 * 3);
            psnr(i, j) = 10 * log10(256 * 256 / MSE);
        end
    end
 
    figure();
    imshow(euDis);
    colormap jet;
    title('Colormap of Euclidean Distance Measures');
 
    figure();
    imshow(psnr);
    colormap jet;
    title('Colormap of PSNR Distance Measures');
 
end