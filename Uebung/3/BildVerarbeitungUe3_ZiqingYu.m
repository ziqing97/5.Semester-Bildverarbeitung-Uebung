% Bildverarbeitung Uebung 3
% Ziqing Yu 3218051
% 14 / 12 / 2019

clc;
clear all;
close all;

%% Vorbereitung
I = imread("einstein.tif");
figure,imshow(I)
I = im2double(I);
title("original")

I_f =fft2(I);
S = fftshift(abs(I_f));
figure, imshow(S,[]);
title("Frequenztransfromatierles Bild nach Zentrierung");
colormap('default');
[a,b] = size(I);


%% Boxfilter
% Ortsraum
F_box = ones(5,5,'double');
F_box =F_box / sum(sum(F_box));
I_box = imfilter(I,F_box,'replicate');
figure, imshow(I_box)
title('BoxFilter im Ortsraum')

% Frequenzraum
H_box = fft2(F_box, a, b);
H_bino_shift = fftshift(H_box);
figure, imshow(abs(H_bino_shift), []);
title('Frequenytransformaierter Boxfilter nach Zentrierung');
colormap('default')
figure, freqz2(F_box);
title('3D Plot Boxfrequenytransformierter Filter')
I_boxf = real(ifft2(H_box.* I_f));
I_boxf = I_boxf(1:a, 1:b);
figure, imshow(I_boxf, [])
title('BoxFilter im Frequenzraum')


%% Binomialfilter
% Ortsraum
bino = conv(conv(conv([1,1],[1,1]),[1,1]),[1,1]);
F_bino = bino' * bino;
F_bino = F_bino / sum(sum(F_bino));
I_bino = imfilter(I,F_bino,'replicate');
figure, imshow(I_bino);
title('Binomialfilter im Ortsraum');

% Frequenzraum
H_bino = fft2(F_bino, a, b);
H_bino_shift = fftshift(H_bino);
figure, imshow(abs(H_bino_shift), []);
title('Frequenztransformaierter Binomialfilter nach Zentrierung');
colormap('default')
figure, freqz2(F_bino);
title('3D Plot Binomialfrequenztransformierter Filter')
I_binof = real(ifft2(H_bino.* I_f));
I_binof = I_binof(1:a, 1:b);
figure, imshow(I_binof, [])
title('BinoFilter im Frequenzraum')


%% Laplacefilter
% Ortsraum
F_Laplace = [0,1,0;1,-4,1;0,1,0];
I_Laplace = imfilter(I, F_Laplace);
figure, imshow(I_Laplace,[]);
title('Laplacefilter im Ortsraum')

BW_Log = edge(I,'log',[],1.5);
figure,imshow(BW_Log,[]);
title('Log Kanten')

% Frequenzraum
H_Laplace = fft2(F_Laplace, a, b);
H_Laplace_shift = fftshift(H_Laplace);
figure, imshow(abs(H_Laplace_shift),[]);
title('Frequenztransformierter Laplacefilter nach Zentrierung')
colormap('default')
figure,freqz2(F_Laplace);
title('3D Plot Laplacefrequenztransformierter Filter')
I_Laplacef = real(ifft2(H_Laplace .* I_f));
figure, imshow(I_Laplacef, []);
title('Laplacefilter im Frequenzraum')


%% Sobelfilter
% Ortsraum
S_x = [1,0,-1;2,0,-2;1,0,-1];
I_Sobel_x = imfilter(I,S_x,'replicate');
figure, imshow(I_Sobel_x),
title('Soberfilter x Richtung im Ortsraum')

S_y = [1,2,1;0,0,0;-1,-2,-1];
I_Sobel_y = imfilter(I,S_y,'replicate');
figure, imshow(I_Sobel_y),
title('Soberfilter y Richtung im Ortsraum')

figure, imshow(sqrt(I_Sobel_x.^2 + I_Sobel_y.^2), []);
title('Gradientenbetrag im Ortsraum')

BW_Sobel = edge(I,'sobel',0.03,'both','thinning');
figure, imshow(BW_Sobel,[])
title('Sobel Kanten')

% Frequenzraum
H_Sx = fft2(S_x, a, b);
H_Sx_shift = fftshift(H_Sx);
figure, imshow(abs(H_Sx_shift),[]);
title('Frequenztransformierter Soberfilter in x Richtung nach Zentrierung')
colormap('default')
figure,freqz2(S_x);
title('3D Plot Soberfrequenztransformierter Filter x Richtung')
I_Sxf = real(ifft2(H_Sx .* I_f));
figure, imshow(I_Sxf);
title('Soberfilter x Richtung im Frequenzraum')

H_Sy = fft2(S_y, a, b);
H_Sy_shift = fftshift(H_Sy);
figure, imshow(abs(H_Sy_shift),[]);
title('Frequenztransformierter Soberfilter in y Richtung nach Zentrierung')
colormap('default')
figure,freqz2(S_y);
title('3D Plot Soberfrequenztransformierter Filter y Richtung')
I_Syf = real(ifft2(H_Sy .* I_f));
figure, imshow(I_Syf);
title('Soberfilter y Richtung im Frequenzraum')

figure, imshow(sqrt(I_Syf.^2 + I_Sxf.^2), []);
title('Gradientenbetrag im Frequenzraum')