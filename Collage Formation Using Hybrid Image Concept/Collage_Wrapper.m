function [out] = Collage_Wrapper(address)
 
    % reading files and storing them into a cell array 'a'
 
    file_list1 = dir([address, '*.jpg']);
    
    file_list2 = dir([address, '*.png']);
    
    n1 = size(file_list1, 1);
    n2 = size(file_list2, 1);
    a = {};
    for i = 1:(n1)
        a1 = imread(file_list1(i).name);
        a{i} = a1;
     
    end
    
    
    for i = 1:(n2)
        a1 = imread(file_list2(i).name);
        a{i+n1} = a1;
     
    end
    % merging two images at a time and updating the queue with it. Also
    % deleting the used two images from the queue (the cell array is referred to as queue)
    i = 1;
    while (size(a, 2) ~= 1)
     
        temp = CreateHybridImage(a{i}, a{i + 1});
     
        a{i} = [];
     
        a{i} = temp;
     
        a(i + 1) = [];
     
        i = i + 1;
     
        if (i >= size(a, 2))
            %reassigning i to 1 if the queue still has more than one images. So that they get merged in the next iteration of the while loop.
            i = 1;
         
        end
    end
    out = a{1};
end

