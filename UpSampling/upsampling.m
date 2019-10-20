function J = upsampling(Image,Type)
    I = imread(Image);
    tf = strcmp(Type,'vis-a-vis');
    tf1 = strcmp(Type,'nearest');
    tf2 = strcmp(Type,'bilinear');
    tf3 = strcmp(Type,'bicubic');
        if tf == 1
            R = double(I(:,:,1));
            G = double(I(:,:,2));
            B = double(I(:,:,3));
            J1 = ones(4);
            J2 = kron(R,J1);
            J3 = kron(G,J1);
            J4 = kron(B,J1);
            J = uint8(cat(3, J2, J3, J4));
        elseif tf1 == 1 
            J = imresize(I,4,'nearest');
        elseif tf2 == 1
            J = imresize(I,4,'bilinear');
        elseif tf3 == 1
            J = imresize(I,4,'bicubic');
        else
            
        end
    figure
    imshow(J)
end
    

