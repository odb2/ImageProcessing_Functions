clear all
close all
clc

I = imread('noisyLena.jpg');    %Image
N = 1;                          %Controls the number of areas of interest you want to filter out
alpha = 0.02;                   %Controls the radius of the notch filters (0.05 gets rid of leakage on edges of images)
s_imagex = size(I,1);           %Size of x-axis IMAGE
s_imagey = size(I,2);           %Size of y-axis IMAGE
s = 2*s_imagex;                 %Size of fft

type = 1;


% %Dispalys Noisy Image
% figure
% imshow(I)
% title('Noisy Image')

%Takes the DFT double the size of input image
y = fft2(I,s,s);
z = fftshift(y);
%Displays the Frequency domain of the noisy image
figure
imshow(uint8(z));
title('Frequency Domain')

%ginput() lets you mark 'N' number of points which will be filtered out
NI = [];
for i = 1:N
    zoom on;
    pause()
    zoom off; 
    NI(:,i)=ginput(1);
    zoom out
end
NI = reshape(NI,1,2*N);

%Converts locations of interest to numerical values between [0 1]
for i = 1:2*N
    N_locate1(i) = s/2 - NI(i);
    N_locatexy(i) = N_locate1(i)/s;
end

%Creates the Filter (Blob Notch Filter)
if type == 1
    notchFreq = N_locatexy;      
    faxis = linspace(-0.5,0.5,s);         
    [u,v] = meshgrid(faxis,faxis); 
    H = ones(length(faxis));
    q=0;
    for i = 1:N
        H(sqrt((u-notchFreq(i+q)).^2 + (v-notchFreq(i+1+q)).^2) <= alpha) = 0;
        H(sqrt((u-(-notchFreq(i+q))).^2 + (v-(-notchFreq(i+1+q))).^2) <= alpha) = 0;
        q = 1+q;
    end
    figure
    imshow(H)
    title('Filter')
else
end

%Creates the Filter (Gaussian Notch Filter)
if type == 2
    notchFreq = N_locatexy;      
    faxis = linspace(-0.5,0.5,s);         
    [u,v] = meshgrid(faxis,faxis);
    q = 0;
    H2 = ones(length(faxis));
    for i = 1:N
        w = sqrt((u-notchFreq(i+q)).^2+(v-notchFreq(i+1+q)).^2); 
        q = 1+q;
        H = zeros(length(faxis));
        H = exp(-0.5*(w./alpha).^2); 
        H = 1 - H;
        H2 = H.*H2;
    end
    q = 0; 
    H3 = ones(length(faxis));
    for i = 1:N
        w1 = sqrt((u-(-notchFreq(i+q))).^2+(v-(-notchFreq(i+1+q))).^2);
        q = 1+q; 
        H1 = zeros(length(faxis));
        H1 = exp(-0.5*(w1./alpha).^2);
        H1 = 1 - H1;
        H3 = H1.*H3;
    end
    H = H2.*H3;
    figure
    imshow(H)
else
end

%Multiplys Filter with noisy image
H_filtered = H.*z;
figure
imshow(uint8(H_filtered))
title('Noisy image multiplied with filter in Frequency-domain')

%Outputs the filtered image
I1 = ifft2(ifftshift(H_filtered),s,s);
I2 = I1(1:s_imagex,1:s_imagey);
figure
subplot(121)
imshow(uint8(I2))
title('Filtered Image')
subplot(122)
imshow(I)
title('Noisy Image')
