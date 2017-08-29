function [a] = HorizontolProcessing(a, b)
 
    %two portrait images - should be merged in a horizontol manner with
    %their heights equalised
 
    [ha, wa, za] = size(a);
    [hb, wb, zb] = size(b);
    ra = imresize(a, (ha + hb) / (ha));
 
    rb = imresize(b, (ha + hb) / (hb));
 
    [hra, wra, zra] = size(ra);
    [hrb, wrb, zrb] = size(rb);
 
    %checking if the height are equal as sometimes they might differ in one row because of rounding off
 
    if (hra > hrb)
        ra = ra(1:hrb, 1:wra, :);
    elseif (hra < hrb)
        rb = rb(1:hra, 1:wrb, :);
    end
 
    [hra, wra, zra] = size(ra);
    [hrb, wrb, zrb] = size(rb);
    %calculating bounding box according to the 20 percent of smaller
    %image
    if (wra >= wrb)
        bBoxWidth = floor(0.2 * wrb);
    else
        bBoxWidth = floor(0.2 * wra);
    end
    a = hybridFormation(ra, ra(:, wra - bBoxWidth + 1:wra, :), rb, rb(:, 1:bBoxWidth, :));
end

