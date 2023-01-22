%% Cosas Peris
clear

%% Modificables
% img  = "dataset1_back_631.png";
% img = 'random';
img = "dataset1_front_961.png";
reduction = 0;
firstOpen = 0;

%% Imagen original
foldername = "../test_data/detection/images/";

% Selección de imagen
if img == "random"
    listing = dir(foldername);
    randNumber = randi(length(listing)-2) + 2; % los dos primeros archivos devueltos por dir son "." y ".."
    filename = listing(randNumber).name;
    imgOriginal = imread(foldername + filename);
else
    imgOriginal = imread(foldername + img);
end

figure(1)
imshow(imgOriginal);
title('original')


% Imagen reducida
imgReduced = imresize(imgOriginal, 1-reduction);

% figure(2)
% imshow(imgReduced);
% title("reducida un " + reduction*100 + "%")


H = height(imgReduced);
W = width(imgReduced);

%% Canales de color
r = imgReduced(:,:,1);
g = imgReduced(:,:,2);
b = imgReduced(:,:,3);

% figure(3)
% set(gcf,'Position',[0 100 1400 700])
% subplot(1,4,1)
% imshow(rgb2gray(imgReduced))
% title('L')
% 
% subplot(1,4,2)
% imshow(cat(3, r, zeros(H,W,2)))
% title('R')
% 
% subplot(1,4,3)
% imshow(cat(3, zeros(H,W,1), g, zeros(H,W,1)))
% title('G')
% 
% subplot(1,4,4)
% imshow(cat(3, zeros(H,W,2), b))
% title('B')

%% Distintas opciones
Drg = uint8(uint16(r-g)*256./uint16(r+g+b));

Drg2 = rescale((single(r)-single(g))./single(r+g+b));

% figure(4)
% imshow(Drg2, [])

% figure(5)
% imshow(Drg, [])

%% Umbral
imgBin = imbinarize(Drg);
% imgBin = imbinarize(Drg, graythresh(Drg));

% figure(6)
% imshow(imgBin)

%% Cierre y apertura
se = strel('diamond', 3);
if firstOpen == 1
    imOpened = imopen(imgBin, se);
    imgOpenedClosed = imclose(imOpened, se);
else
    imClosed = imclose(imgBin, se);
    imgOpenedClosed = imopen(imClosed, se);
end

figure(7)
imshow(imgOpenedClosed)

%% Limpia
imgApple = r;
imgApple(~imgOpenedClosed) = 3;
% 
% figure(8)
% imshow(imgApple)

% ¿Bordes?
se = strel('diamond', 3);
imgBorder = imclose(edge(imgApple), se) | edge(imgOpenedClosed);
figure(9)
imshow(imgBorder)


%% Bordes bien
[~, imgBoundaries] = bwboundaries(imgBorder, 'holes');
[~, imgRealBoundaries] = bwboundaries(imgBorder, 'noholes');
imgWithoutBoundaries = imgBoundaries;
imgWithoutBoundaries(imgRealBoundaries ~= 0) = 0;

figure(101)
imshow(label2rgb(imgBoundaries, @jet, [.5,.5,.5]))
figure(102)
imshow(label2rgb(imgRealBoundaries, @jet, [.5,.5,.5]))

figure(10)
imshow(label2rgb(imgWithoutBoundaries, @jet, [.5,.5,.5]))

% %% Imagen rellena ñamñam
% imgFilled = imfill(imgBoundaries, 'holes');
% 
% figure(91)
% imshow(label2rgb(imgFilled))


%% Características
caract = regionprops(imgOpenedClosed, 'all');

figure(111)
imshow(imgReduced);

for i = 1:length(caract)
    if caract(i).Area < 20
        continue
    end
    rectangle('Position', caract(i).BoundingBox, 'LineWidth', 2, 'EdgeColor', 'r')
end
