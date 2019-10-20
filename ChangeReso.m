function img = ChangeReso(b,I)
    L = imread(I);
    S = size(L);
    S = S(1);
    M = dec2bin(L);
    chr = cellstr(M);
        for k = 1 : length(chr)
            cellContents = chr{k};
            chr{k} = cellContents(1:b);
        end
    X = bin2dec(chr)';
    X = (X - min(X(:))) / (max(X(:)) - min(X(:)));
    X = im2uint8(X);
    X = reshape(X,S,S,3);
    figure
    img = imshow(X);
 end