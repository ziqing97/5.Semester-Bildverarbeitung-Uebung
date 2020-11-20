% Bildverarbeitung Uebung 2 Pan Sharpening
% Ziqing YU 3218051
% Erstellt am 20/11/2019
clc
clear all;
close all;

% Bild einlesen und normieren
pan=imread('DMC_haeuser_pan.bmp');
lowRGB=imread('DMC_haeuser_lowRGB_original.bmp');
pan=im2double(pan);
figure, imshow(pan)
figure, imshow(lowRGB)
% RGB Bild in 3 Kanaele extrahieren
R=im2double(lowRGB(:,:,1));
G=im2double(lowRGB(:,:,2));
B=im2double(lowRGB(:,:,3));
% RGB zu HSI transformieren
% Hue
T = 0.5 * ((R - G) + (R - B))./sqrt((R - G).^2+(R - B).*(G - B));
H = acos(T);
H( B > G )=2 * pi - H( B > G );
k=find(isnan(H));        % NaN wird auf 0 gesetzt
H(k) = 0 ;
% Saturation
S=1-3./(R+G+B).* min(min(R,G),B);
k=find(isnan(S));     % NaN wird auf 0 gesetzt
S(k)=0;
% Intensitaet
I=(R+G+B)/3;
% Bild wird vergroe?ert
[x_size, y_size]=size(pan);
si=[x_size, y_size];
H=imresize(H,si,'bilinear');
S=imresize(S,si,'bilinear');
I=imresize(I,si,'bilinear');       % in diese Aufgabe nicht n?tig
% neue Intensitaet setzen
I=pan;
% Bedigung fuer die Ruecktransformation
H_deg=H./pi.*180;
% neue RGB Matrizen vordefinieren
R_n=zeros(si);
G_n=zeros(si);
B_n=zeros(si);
% Ruecktransformation
% 1
idx=((H_deg >= 0) & (H_deg < 120));
B_n(idx)=I(idx).*(1-S(idx));
R_n(idx)=I(idx).*(1+(S(idx).*cos(H(idx)))./cos(pi/3-H(idx)));
G_n(idx)=3*I(idx)-(R_n(idx)+B_n(idx));
% 2
idx=((H_deg >= 120) & (H_deg < 240));
H(idx)=H(idx)-2*pi/3;
R_n(idx)=I(idx).*(1-S(idx));
G_n(idx)=I(idx).*(1+(S(idx).*cos(H(idx)))./cos(pi/3-H(idx)));
B_n(idx)=3*I(idx)-(R_n(idx)+G_n(idx));
% 3
idx=((H_deg >= 240) & (H_deg < 360));
H(idx)=H(idx)-4*pi/3;
G_n(idx)=I(idx).*(1-S(idx));
B_n(idx)=I(idx).*(1+(S(idx).*cos(H(idx)))./cos(pi/3-H(idx)));
R_n(idx)=3*I(idx)-(G_n(idx)+B_n(idx));
% neuer RGB Bild wird erzeugt
RGB_n=cat(3,R_n,G_n,B_n);
% Bild zeigen
figure,imshow(R_n)
title('Rot')
figure,imshow(G_n)
title('Gruen')
figure,imshow(B_n)
title('Blau')
figure,imshow(RGB_n)
title('Bild mit hoeher Aufloesung')

