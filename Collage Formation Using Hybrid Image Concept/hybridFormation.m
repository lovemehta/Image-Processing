
function [output] = hybridFormation(im1, bBox1, im2, bBox2)
    %using the inbuilt function fspecial to blur the image
    H = fspecial('disk', 10);
    blur1 = imfilter(bBox1, H, 'replicate');
    %to sharpen the details of the second image we substract the blurred
    %image from the original image
    blur2 = imfilter(bBox2, H, 'replicate');
    sharp2 = bBox2 - blur2;
 
    [y1, x1, z1] = size(im1);
    [y2, x2, z2] = size(im2);
    [h1, w1, z3] = size(bBox1);
    
    clear im3;
 
    if (x1 == x2)
        % if width is same then we do vertical merge and make a hybrid image
        %first we blur the bounding box part of image 1
     
        for i = 1:h1
            im1(y1 - h1 + i, :, :) = blur1(i, :, :);
         
        end
        %second we sharpen the bounding box part of image 2
     
        for i = 1:h1
            im2(i, :, :) = (im2(i, :, :) + sharp2(i, :, :));
        end
        % we copy the unchanged part of image 1 in new empty image 3
     
        im3(1:y1 - h1, :, :) = im1(1:y1 - h1, :, :);
        % merge the two images in the bounding region to make a hybrid
        % region, by assigning weightage to each pixel and gradually
        % varying it from 1 to 0 and 0 to 1
        j = 1;
     
        for i = y1 - h1 + 1:y1
         
            im3(i, :, :) = ((1 - j / h1) * im1(i, :, :) + (j / h1) * im2(j, :, :));
         
            j = j + 1;
        end
        %copy the unchanged part of image 2 to image 3
     
        im3(y1 + 1:y1 + y2 - h1, :, :) = im2(h1 + 1:y2, :, :);
     
    elseif (y1 == y2)
        % if height is same then we do horizontol merge and make a hybrid image
        %first we blur the bounding box part of image 1
        for i = 1:w1
            im1(:, x1 - w1 + i, :) = blur1(:, i, :);
         
        end
        %second we sharpen the bounding box part of image 2
        for i = 1:w1
            im2(:, i, :) = (im2(:, i, :) + sharp2(:, i, :));
        end
        % we copy the unchanged part of image 1 in new empty image 3
        im3(:, 1:x1 - w1, :) = im1(:, 1:x1 - w1, :);
        % merge the two images in the bounding region to make a hybrid
        % region, by assigning weightage to each pixel and gradually
        % varying it from 1 to 0 and 0 to 1
        j = 1;
        for i = x1 - w1 + 1:x1
            im3(:, i, :) = ((1 - j / w1) * im1(:, i, :) + (j / w1) * im2(:, j, :));
            j = j + 1;
        end
        %copy the unchanged part of image 2 to image 3
        im3(:, x1 + 1:x1 + x2 - w1, :) = im2(:, w1 + 1:x2, :);
     
    end
 
    output = im3;
 
end