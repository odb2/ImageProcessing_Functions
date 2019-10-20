function [img3, origimage] = nhoodFilter1(img,option,beta,noisedensity,SP)

    [I,SorP] = saltORpepper(img,SP,noisedensity);
    betacheck = mod(beta,2);
    [~, ~, numberOfColorChannels] = size(I);
    
        % Checks to make sure beta is odd
        if betacheck == 0
            error('"beta" must be an odd integer')
        end
        
        % Checks to see if input image is RGB or grayscale
        if numberOfColorChannels == 3 
            R = double(I(:,:,1));                                                   % Takes out R,G,B matrices of the image
            G = double(I(:,:,2));
            B = double(I(:,:,3));
        else                                                                                        % Creates three RGB vectors if image is grayscale
            R = double(I(:,:,1));
            G = double(I(:,:,1));
            B = double(I(:,:,1));
        end
        
        % option = 1  = averaging operation
        if option == 1
            
            size0 = size(I);                                                                    % Finds the dimensions of the image
            size1 = size0(1);                                                                % # of rows
            size2 = size0(2);                                                                % # of columns
            index = floor(beta/2);
            R1 = zeros(size(R));                                                         % Creates copys of R, G, B
            G1 = zeros(size(G));
            B1 = zeros(size(B));

            % Adds floor(beta/2) columns and rows to each of the R,G,B matrices using pixel replication
            for i = 1:index                                                                
                R = [[R(1,1);R(:,1);R(size1,1)],[R(1, :);R;R(size1,:)],[R(1,size2);R(:,size2);R(size1,size2)]];
                G = [[G(1,1);G(:,1);G(size1,1)],[G(1, :);G;G(size1,:)],[G(1,size2);G(:,size2);G(size1,size2)]];
                B =  [[B(1,1);B(:,1);B(size1,1)],[B(1, :);B;B(size1,:)],[B(1,size2);B(:,size2);B(size1,size2)]];
            end
            % Creates the Spatial Mask Matrix
            beta1 = ones(beta);
            S = (1/(beta.^2)) .* beta1;
            
            l =0;
            R1 = R1';
            G1 = G1';
            B1 = B1';
            % implements the neighborhood to neighborhood multiplication
            for i = 0:size1-1
                for ii = 0:size2-1
                    Rtest = R(i+1:beta+i,1+ii:beta+ii).*S;
                    Gtest = G(i+1:beta+i,1+ii:beta+ii).*S;
                    Btest = B(i+1:beta+i,1+ii:beta+ii).*S;
                
                    Rmean = sum(Rtest(:));
                    Gmean = sum(Gtest(:));
                    Bmean = sum(Btest(:));
                
                    R1(ii+1+l) = Rmean;
                    G1(ii+1+l) = Gmean;
                    B1(ii+1+l) = Bmean;
                end
                l = l+size2;
            end
            R1 = R1';
            G1 = G1';
            B1 = B1';
       
            img2 = cat(3,R1,G1,B1);                                                                                                                     % Sets the edited R,G,B values 
            img2 = (img2 - min(img2(:))) /(max(img2(:)) - min(img2(:)));                                  % Normalizes img2 to between [0 1]
            img2 = im2uint8(img2);                                                                                                                    % Converts values to between [0 255]
    
            figure
            img3 = imshow(img2);
            title(sprintf('Neighborhood Method - beta = %d', beta))     
            figure
            origimage = imshow(I);
            title(sprintf('Original Image - Noise Density = %d',noisedensity))    
        end
        
        % option = 2  = median Filtering
        if option == 2
       
            size0 = size(I);                                                                    % Finds the dimensions of the image
            size1 = size0(1);                                                                % # of rows
            size2 = size0(2);                                                                % # of columns
            index = floor(beta/2);
            R1 = zeros(size(R));                                                         % Creates copys of R, G, B
            G1 = zeros(size(G));
            B1 = zeros(size(B));

            % Adds floor(beta/2) columns and rows to each of the R,G,B matrices using pixel replication
            for i = 1:index                                                                
                R = [[R(1,1);R(:,1);R(size1,1)],[R(1, :);R;R(size1,:)],[R(1,size2);R(:,size2);R(size1,size2)]];
                G = [[G(1,1);G(:,1);G(size1,1)],[G(1, :);G;G(size1,:)],[G(1,size2);G(:,size2);G(size1,size2)]];
                B =  [[B(1,1);B(:,1);B(size1,1)],[B(1, :);B;B(size1,:)],[B(1,size2);B(:,size2);B(size1,size2)]];
            end
            % Creates the Spatial Mask Matrix
            
            S = ones(beta);
           
            l =0;
            R1 = R1';
            G1 = G1';
            B1 = B1';
            % implements the neighborhood to neighborhood multiplication
            for i = 0:size1-1
                for ii = 0:size2-1
                    Rtest = R(i+1:beta+i,1+ii:beta+ii).*S;
                    Gtest = G(i+1:beta+i,1+ii:beta+ii).*S;
                    Btest = B(i+1:beta+i,1+ii:beta+ii).*S;
                
                    Rmean = median(Rtest(:));
                    Gmean = median(Gtest(:));
                    Bmean = median(Btest(:));
                
                    R1(ii+1+l) = Rmean;
                    G1(ii+1+l) = Gmean;
                    B1(ii+1+l) = Bmean;
                end
                l = l+size2;
            end
            R1 = R1';
            G1 = G1';
            B1 = B1';
       
            img2 = cat(3,R1,G1,B1);                                                                                                                     % Sets the edited R,G,B values 
            img2 = (img2 - min(img2(:))) /(max(img2(:)) - min(img2(:)));                                  % Normalizes img2 to between [0 1]
            img2 = im2uint8(img2);                                                                                                                    % Converts values to between [0 255]
    
            figure
            img3 = imshow(img2);
            title(sprintf('Median Method - beta = %d', beta))     
            figure
            origimage = imshow(I);
            title(sprintf('Original Image - Noise Density = %d, saltORpepper = %d',noisedensity, SorP))   
        end
        
        % option = 3 = max filter
        if option == 3
            size0 = size(I);                                                                    % Finds the dimensions of the image
            size1 = size0(1);                                                                % # of rows
            size2 = size0(2);                                                                % # of columns
            index = floor(beta/2);
            R1 = zeros(size(R));                                                         % Creates copys of R, G, B
            G1 = zeros(size(G));
            B1 = zeros(size(B));

            % Adds floor(beta/2) columns and rows to each of the R,G,B matrices using pixel replication
            for i = 1:index                                                                
                R = [[R(1,1);R(:,1);R(size1,1)],[R(1, :);R;R(size1,:)],[R(1,size2);R(:,size2);R(size1,size2)]];
                G = [[G(1,1);G(:,1);G(size1,1)],[G(1, :);G;G(size1,:)],[G(1,size2);G(:,size2);G(size1,size2)]];
                B =  [[B(1,1);B(:,1);B(size1,1)],[B(1, :);B;B(size1,:)],[B(1,size2);B(:,size2);B(size1,size2)]];
            end
            % Creates the Spatial Mask Matrix
            
            S = ones(beta);
           
            l =0;
            R1 = R1';
            G1 = G1';
            B1 = B1';
            % implements the neighborhood to neighborhood multiplication
            for i = 0:size1-1
                for ii = 0:size2-1
                    Rtest = R(i+1:beta+i,1+ii:beta+ii).*S;
                    Gtest = G(i+1:beta+i,1+ii:beta+ii).*S;
                    Btest = B(i+1:beta+i,1+ii:beta+ii).*S;
                
                    Rmean = max(Rtest(:));
                    Gmean = max(Gtest(:));
                    Bmean = max(Btest(:));
                
                    R1(ii+1+l) = Rmean;
                    G1(ii+1+l) = Gmean;
                    B1(ii+1+l) = Bmean;
                end
                l = l+size2;
            end
            R1 = R1';
            G1 = G1';
            B1 = B1';
       
            img2 = cat(3,R1,G1,B1);                                                                                                                     % Sets the edited R,G,B values 
            img2 = (img2 - min(img2(:))) /(max(img2(:)) - min(img2(:)));                                  % Normalizes img2 to between [0 1]
            img2 = im2uint8(img2);                                                                                                                    % Converts values to between [0 255]
    
            figure
            img3 = imshow(img2);
            title(sprintf('Max Method - beta = %d', beta))     
            figure
            origimage = imshow(I);
            title(sprintf('Original Image - Noise Density = %d, saltORpepper = %d',noisedensity,SorP))   
        end
        
        % option = 4 = min filter
        if option == 4
            size0 = size(I);                                                                    % Finds the dimensions of the image
            size1 = size0(1);                                                                % # of rows
            size2 = size0(2);                                                                % # of columns
            index = floor(beta/2);
            R1 = zeros(size(R));                                                         % Creates copys of R, G, B
            G1 = zeros(size(G));
            B1 = zeros(size(B));

            % Adds floor(beta/2) columns and rows to each of the R,G,B matrices using pixel replication
            for i = 1:index                                                                
                R = [[R(1,1);R(:,1);R(size1,1)],[R(1, :);R;R(size1,:)],[R(1,size2);R(:,size2);R(size1,size2)]];
                G = [[G(1,1);G(:,1);G(size1,1)],[G(1, :);G;G(size1,:)],[G(1,size2);G(:,size2);G(size1,size2)]];
                B =  [[B(1,1);B(:,1);B(size1,1)],[B(1, :);B;B(size1,:)],[B(1,size2);B(:,size2);B(size1,size2)]];
            end
            % Creates the Spatial Mask Matrix
            
            S = ones(beta);
           
            l =0;
            R1 = R1';
            G1 = G1';
            B1 = B1';
            % implements the neighborhood to neighborhood multiplication
            for i = 0:size1-1
                for ii = 0:size2-1
                    Rtest = R(i+1:beta+i,1+ii:beta+ii).*S;
                    Gtest = G(i+1:beta+i,1+ii:beta+ii).*S;
                    Btest = B(i+1:beta+i,1+ii:beta+ii).*S;
                
                    Rmean = min(Rtest(:));
                    Gmean = min(Gtest(:));
                    Bmean = min(Btest(:));
                
                    R1(ii+1+l) = Rmean;
                    G1(ii+1+l) = Gmean;
                    B1(ii+1+l) = Bmean;
                end
                l = l+size2;
            end
            R1 = R1';
            G1 = G1';
            B1 = B1';
       
            img2 = cat(3,R1,G1,B1);                                                                                                                     % Sets the edited R,G,B values 
            img2 = (img2 - min(img2(:))) /(max(img2(:)) - min(img2(:)));                                  % Normalizes img2 to between [0 1]
            img2 = im2uint8(img2);                                                                                                                    % Converts values to between [0 255]
    
            figure
            img3 = imshow(img2);
            title(sprintf('Min method - beta = %d', beta))     
            figure
            origimage = imshow(I);
            title(sprintf('Original Image - Noise Density = %d, saltORpepper = %d',noisedensity,SorP))   
        end
end
