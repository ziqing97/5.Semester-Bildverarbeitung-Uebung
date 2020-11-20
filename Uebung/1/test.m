%% Histogramm Anpassung
% Bild lesen und pruefen
I1=imread('8873_g.jpg');
I2=imread('8874_g.jpg');
% Histogramm von I1 I2
hist_I1=imhist(I1);
hist_I2=imhist(I2);

J1=histeq(I2,hist_I1);

imshow(I1);
figure
imshow(J1);
figure
imhist(I1);
figure
imhist(J1);
