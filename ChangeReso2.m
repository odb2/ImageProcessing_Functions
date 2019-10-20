function img = ChangeReso2(b,I)
    L = imread(I);
    S = size(L);
    S = S(1);
    img = bin2dec(cellstr(dec2bin(L)))';
    b = 2.^b;
    b = 1*b;
    t = floor((256/b));
    g = floor((256/(b-1)));
    for i = 1:length(img)
        for ii = 0:b-1
            if img(i) >= ii*t && img(i) <= (ii+1)*(t-1)+ii
                if ii == b-1
                    img(i) = 255;
                else
                img(i) = ii*g;
                end
            end
        end
    end
    img = uint8(img);
    X = reshape(img,S,S,3);
    figure
    img = imshow(X);
end