% Bildverarbeitung Uebung 1 
% Ziqing Yu 3218051
% 08/11/2019

%% Eingabe und Prueung
clc;
clear all;
close all;

%% Lineare Skalierung
I=imread('pout.tif');
imshow(I)
title('Originale Bild')

% Max. und min. Grauwert finden
min_I=double(min(I(:)));
max_I=double(max(I(:)));
% Massstab und Offset rechnen
% Max. und min. Grauwert von Neuem Bild sind 255 und 0.
scale=(255.0-0.0)/(max_I-min_I);
offset=(max_I*0.0-min_I*255.0)/(max_I-min_I);
% Bild Skalierung
I_stretch=int16(I)*scale+offset;
I_stretch=uint8(I_stretch);
% Bild zeigen
figure
imshow(I_stretch)
title('Bild nach Skalierung')
% Histogramm darstellen
figure
imhist(I)
title('Histogramm von Originale Bild')
figure
imhist(I_stretch)
title('Histogramm von neuem Bild')
% Kummulativen Histogramm
anzahl_pixel=numel(I);
his_vor=imhist(I)/anzahl_pixel;
his_nach=imhist(I_stretch)/anzahl_pixel;
figure
plot(cumsum(his_vor))
title('normierten kummulative Histogramm von Originale Bild')
figure
plot(cumsum(his_nach))
title('normierten kummulative Histogramm von neuem Bild')

% Die 5% dunkelsten und hellesten Grauwerten bestimmen und beseitigen
kum_his=(cumsum(his_vor));
x1=max(kum_his(kum_his<0.05));
x2=min(kum_his(kum_his>0.95));

min_I_1=find(kum_his==x1);
len=length(min_I_1);
min_I_1=min_I_1(len)-1;
min_I_1=min_I_1+1;     % Grenzwert von 5% dunkelsten  

max_I_1=find(kum_his==x2);
max_I_1=max_I_1(1)-1;   
max_I_1=max_I_1-1;    % Grenzwert von 5% hellesten

% Wiederholung der Skalierung
scale_1=(255.0-0.0)/(max_I_1-min_I_1);
offset_1=(max_I_1*0.0-min_I_1*255.0)/(max_I_1-min_I_1);
I_stretch_1=int16(I)*scale_1+offset_1;
I_stretch_1=uint8(I_stretch_1);

% Bild und Histogramm zeigen
figure
imshow(I_stretch_1)
title('Bild nach der Skalierung au�erhalb jweils 5% der dunkelsten bzw. hellsten Grauwertes')
figure
imhist(I_stretch_1)
title('Histogramm von Bild nach der Skalierung au�erhalb jweils 5% der dunkelsten bzw. hellsten Grauwertes')

%% Histogrammverebnung
% Die Funktion sieht in 'Verebnung.m'
I_ver=Verebnung(I);
% Bild und Histogramm zeigen
figure
imshow(I_ver)
title('Bild nach der Verebnung')
figure
imhist(I_ver)
title('Histogramm von Bild nach der Verebnung')

%% Histogramm Anpassung
% Bild lesen und pruefen
I1=imread('8873_g.jpg');
I2=imread('8874_g.jpg');

% Beide werden Verebnet
I1_ver=Verebnung(I1);
I2_ver=Verebnung(I2);
% Histogramm von I1 I2
hist_I1=imhist(I1);
hist_I2=imhist(I2);
% kummulative Histogramm von I1 I2
kumm_I1=cumsum(hist_I1)/numel(I1);
kumm_I2=cumsum(hist_I2)/numel(I2);

% I2 zu I1 anpassen
I2_anpa=I2_ver;
for i=1:4000
    for j=1:3000
        m=double(I2_ver(i,j))/255.0;
        grau_wert=find(abs(kumm_I1-m)==min(abs(kumm_I1-m)))-1;
        I2_anpa(i,j)=grau_wert;
    end
end

figure
imshow(I1);
title('linkes Bild')
figure
imshow(I2)
title('rechtes Bild')
figure
imshow(I2_anpa);
title('rechtes Bild zu linkem Bild anpassen')
figure
imhist(I1)
title('Histogramm von linkem Bild')
figure
imhist(I2)
title('Histogramm von rechtem Bild')
figure
imhist(I2_anpa)
title('Histogramm von rechtem Bild nach Anpassung')



