% Bildverarbeitung Uebung 4
% Ziqing Yu 3218051

clc
clear all;
close all;

% Vordefinieren
name1 = 'DSC_0187.jpg';
name2 = 'DSC_0188.jpg';
name3 = 'DBV_2019_1.jpg';
name4 = 'DBV_2019_2.jpg';

% Funktion anrufen
% Projektive(name1,name2);
% Projektive(name3,name4);

% function [] = Projektive(name1,name2)
    % Daten lesen
    I1 = imread(name3);
    I2 = imread(name4);

    % identische Punkte
    figure, imshow(I1);
    hold on
    [x1,y1] = getline('closed');
    scatter(x1,y1,'p','r');
    x1 = x1(1:end-1);
    y1 = y1(1:end-1);

    figure, imshow(I2);
    hold on
    [x2,y2] = getline('closed');
    scatter(x2,y2,'p','r');
    x2 = x2(1:end-1);
    y2 = y2(1:end-1);

    % ueberpruefen
    if length(x1) ~= length(x2)
        error('Anzahl der Punkten nicht identisch!')
    end


    %% 
    % homogene Punkte
    p1 = [x1,y1,ones(length(x1),1)];
    p2 = [x2,y2,ones(length(x2),1)];

    A = zeros(2 * length(1),9);
    O = [0 0 0];

    for n = 1:length(x1)
        X = p1(n,:);
        x = p2(n,1);
        y = p2(n,2);
        w = p2(n,3);
        A(2 * n - 1, :) = [O, -w * X, y * X];
        A(2 * n, :) = [w * X, O, -x * X];
    end

    % Sigulaerwerte
    [U,D,V] = svd(A);
    H = reshape(V(:,9),3,3)';

    figure;
    h_0 = imshow([I1, I2]);
    title('Originalbilder mit gewealten Punkten')
    hold on;
    diff = length(I1);
    line([p1(:,1),p2(:,1)+diff]',[p1(:,2),p2(:,2)]');
    hold off;

    % Transformation
    [width,height,~] = size(I1);

    % Matrix mit Pixelkoordinaten
    [x_i, y_i] = meshgrid(1:height, 1:width);
    TransPoints=[x_i(:),y_i(:),ones(length(y_i(:)),1)]';

    % Bildkoordinatentransformation
    pixel_pkt = H * TransPoints;

    % Pixelkoordinaten normieren
    pixel_pkt(1,:) = pixel_pkt(1,:)./pixel_pkt(3,:);
    pixel_pkt(2,:) = pixel_pkt(2,:)./pixel_pkt(3,:);
    pixel_pkt(3,:) = [];

    % Pixelkoordinaten zuruek in Matrixform 
    x_i = reshape(pixel_pkt(1,:),width,height);
    y_i = reshape(pixel_pkt(2,:),width,height);

    % Grauwertinterpolation
%     Bildhsv_1 = rgb2hsv(I1);
%     Bildgrauwert_1 = Bildhsv_1(:,:,3);
%     Bildhsv_2 = rgb2hsv(I2);
%     Bildgrauwert_2 = Bildhsv_2(:,:,3);
    Bildhsv_1 = rgb2gray(I1);
    Bildhsv_2 = rgb2gray(I2);


    % Interpolation 
    Bild_neu1 = interp2(im2double(Bildhsv_2),x_i,y_i,'linear',0);
    Bild_neu2 = interp2(double(Bildhsv_2),x_i,y_i,'linear',0);
    % Darstellung Originalbild neben transformiertem Bild
    figure
    imshow([Bildhsv_2, Bild_neu2]);
    title('Originalbild und transformiertes Bild')

    % Bilder ueberlagern
    Bild_ueberlagert = (0.5 * Bild_neu1 + 0.5 * im2double(Bildhsv_1));

    % Darstellung des ueberlagerten Bildes
    figure
    imshow(Bild_ueberlagert); 
    title('ueberlagertes Bild');
% end
