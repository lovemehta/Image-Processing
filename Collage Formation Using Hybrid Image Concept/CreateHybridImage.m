function [output] = CreateHybridImage(a, b)
    %   reading the size of images
    [ha, wa, za] = size(a);
    [hb, wb, zb] = size(b);
    %   deciding which kind of processing has to be done on the basis of
    %   orientation
    if (wa / ha > 1 && wb / hb > 1)
        %if both images are landscape
        a = VerticalProcessing(a, b);
     
    end
 
    if (wa / ha < 1 && wb / hb < 1)
        % if both images are portrait
        a = HorizontolProcessing(a, b);
     
    end
 
    if (wa / ha >= 1 && wb / hb <= 1 || wa / ha <= 1 && wb / hb >= 1)
        %if one of the images is landscape and other portrait
        if (wa / ha > hb / wb)
            %if the landscape one has more elongation in width than the
            %height
            a = HorizontolProcessing(a, b);
         
        end
        if (wa / ha < hb / wb)
            %if the portrait one has more elongation in height than the
            %width
            a = VerticalProcessing(a, b);
         
        end
    end
 
    output = a;
end

