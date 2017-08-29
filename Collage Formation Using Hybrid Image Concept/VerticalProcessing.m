function [a] = VerticalProcessing(a, b)
 
    %two landscape images - should be merged in a vertical manner with
    %their widths equalised
 
    [ha, wa, za] = size(a);
    [hb, wb, zb] = size(b);
 
    ra = imresize(a, (wa + wb) / wa);
    rb = imresize(b, (wa + wb) / wb);
 
    [hra, wra, zra] = size(ra);
    [hrb, wrb, zrb] = size(rb);
 
    %checking if the widths are equal as sometimes they might differ in one row because of rounding off
    if (wra > wrb)
        ra = ra(1:hra, 1:wrb, :);
    elseif (wra < wrb)
        rb = rb(1:hrb, 1:wra, :);
    end
 
    [hra, wra, zra] = size(ra);
    [hrb, wrb, zrb] = size(rb);
    %calculating bounding box according to the 20 percent of smaller
    %image
    if (hra >= hrb)
        bBoxHeight = floor(0.2 * hrb);
    else
        bBoxHeight = floor(0.2 * hra);
    end
 
    a = hybridFormation(ra, ra(hra - bBoxHeight + 1:hra, :, :), rb, rb(1:bBoxHeight, :, :));
 
end

