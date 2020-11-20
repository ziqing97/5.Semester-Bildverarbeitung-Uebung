%% Bildverabreitung - Übung 4
%  Projektive Bildtransformation durch homogene Koordinaten
%  Robin Knogl 3142583

% clear all;
% close all;

%% a) Homographie

% Bilder einlesen
% 1. Fassadenbilder
 Bild_1 = imread('DSC_0187.jpg'); 
 Bild_2 = imread('DSC_0188.jpg');

% 2. Seminarraumbilder
% Bild_1 = imread('DBV_2017_1.jpg');
% Bild_2 = imread('DBV_2017_2.jpg');
 
 
% Größe der Bilder anpassen
 Bild_1 = imresize(Bild_1,0.5);
 Bild_2 = imresize(Bild_2,0.5);


% Auswahl der Punkte im ertsten Bild
imshow(Bild_1)
title('Mindestens 6 Punkte wählen');
[x,y] = getline('closed');
InPkt = length(x)-1;


% gewählte Punkte im Bild markieren
pkt_1=[x(1:InPkt),y(1:InPkt)]';
hold on,
plot([x(1:InPkt);x(1)],[y(1:InPkt);y(1)],'rx'),title('Bild 1: Ausgewählte Punkte');
drawnow


% Auswahl der Punkte im zweiten Bild
figure;
imshow(Bild_2),title('Identische Punkte wie im ersten Bild wählen!');
[x,y]=getline('closed');


% Anzahl der ausgewählte Punkte vergleichen
if (length(x)-1)~=InPkt
    fprintf('Anzahl der ausgewählten Punkte stimmt nicht überein!');
end

pkt_2=[x(1:InPkt),y(1:InPkt)]';
hold on,
plot([x(1:InPkt);x(1)],[y(1:InPkt);y(1)],'rx'),title('Bild 2: Ausgewählte Punkte');
drawnow



% Homogene Koordinaten bestimmen
x_1=[pkt_1; ones(1,InPkt)];
x_2=[pkt_2; ones(1,InPkt)];

A = zeros(2*InPkt,9);
O = [0 0 0];


for n = 1:InPkt
    X = x_1(:,n)';
    x = x_2(1,n);
    y = x_2(2,n);
    w = x_2(3,n);
    A(2*n-1,:) = [O, -w*X, y*X];
    A(2*n,:) = [w*X, O, -x*X];
end


% Erstellen der Homographie
% Singulärwertzerlegung
[U, D, V] = svd(A,0);

% H-Matrix aufstellen
H = reshape(V(:,9),3,3)';

% Vergleichsbild mit ausgewählten Punkten
x_1hs = x_1';
x_2hs = x_2';


figure;
h_0 = imshow([Bild_1, Bild_2]);
title('Originalbilder mit gewaelten Punkten')
hold on;
diff = length(Bild_1);
line([x_1hs(:,1),x_2hs(:,1)+diff]',[x_1hs(:,2),x_2hs(:,2)]');
hold off;


%% Bildkoordinatentransformation


[width,height,numbands] = size(Bild_1);


% Matrix mit Pixelkoordinaten
[x_i, y_i] = meshgrid(1:height, 1:width);
TransPoints=[x_i(:) y_i(:) ones(length(y_i(:)),1)]';


% Bildkoordinatentransformation
pixel_pkt = H*TransPoints;


% Pixelkoordinaten normieren
pixel_pkt(1,:) = pixel_pkt(1,:)./pixel_pkt(3,:);
pixel_pkt(2,:) = pixel_pkt(2,:)./pixel_pkt(3,:);
pixel_pkt(3,:) = [];


% Pixelkoordinaten zurück in Matrixform 
x_i = reshape(pixel_pkt(1,:),width,height);
y_i = reshape(pixel_pkt(2,:),width,height);


% Grauwertinterpolation
Bildhsv_1 = rgb2hsv(Bild_1);
Bildgrauw_1 = Bildhsv_1(:,:,3);
Bildhsv_2 = rgb2hsv(Bild_2);
Bildgrauw_2 = Bildhsv_2(:,:,3);


% Interpolation 
Bild_neu = interp2(double(Bildgrauw_2),x_i,y_i,'linear',0);


% Darstellung Originalbild neben transformiertem Bild
figure;
h1 = imshow([Bildgrauw_2, Bild_neu]);title('Originalbild und transformiertes Bild')

% Bilder überlagern
Bild_ueberlagert = (0.5*Bild_neu+0.5*double(Bildgrauw_1));

% Darstellung des überlagerten Bildes
figure;
imshow(Bild_ueberlagert); title('Überlagertes Bild');

