function [ G ] = imth( I, Th )
    if(ndims(I) == 3)
        I = rgb2gray(I);
    end

    [x,y] = size(I);

    G = uint8(zeros(x,y));

    for i=1:x
        for j=1:y
            if(I(i,j)>Th)
                I(i,j) = 255;
            else
                I(i,j) = 0;
            end
        end
    end
    G = I;
end

