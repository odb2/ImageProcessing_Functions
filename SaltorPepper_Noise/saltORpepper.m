function [noisyimg,SorP] = saltORpepper(img, SP, noisedens)    

    if isequal(SP, 'salt')
        SorP = 255;
    elseif isequal(SP, 'pepper')
        SorP = 0;
    end

    I = imread(img);
    I = rgb2gray(I);
    s = size(I);
    s1 = s(1);
    s2 = s(2);
    
    I2 = I;
    p = rand(1,s1*s2);
    
        for ii = 1:(s1*s2)
            if p(ii) < noisedens
                I2(ii)= SorP;
            end
        end                                 % Normalizes img2 to between [0 1]
    noisyimg = uint8(I2);
    figure
    imshow(noisyimg)
    title(sprintf('Noisy image - Noise Density = %d, saltORpepper = %d',noisedens,SorP)) 
end