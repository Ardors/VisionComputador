%% Cosas Peris
clear

%% Modificables
img  = "dataset1_back_631.png";
% img = 'random';
% img = "dataset1_front_961.png";
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
% title('original')


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

figure(3)
set(gcf,'Position',[0 100 1400 700])
subplot(1,4,1)
imshow(rgb2gray(imgReduced))
title('L')

subplot(1,4,2)
% imshow(cat(3, r, zeros(H,W,2)))
imshow(r)
title('R')

subplot(1,4,3)
% imshow(cat(3, zeros(H,W,1), g, zeros(H,W,1)))
imshow(g)
title('G')

subplot(1,4,4)
% imshow(cat(3, zeros(H,W,2), b))
imshow(b)
title('B')

% Histograma
[counts, binLocations] = imhist(rgb2gray(imgReduced), 20);
[countsR, binLocationsR] = imhist(r, 20);
[countsG, binLocationsG] = imhist(g, 20);
[countsB, binLocationsB] = imhist(b, 20);

% figure(31)
% subplot(2,2,1)
% bar(binLocations, counts/sum(counts), 'grouped', 'black');
% title('L')
% 
% subplot(2,2,2)
% bar(binLocationsR, countsR/sum(countsR), 'grouped', 'red');
% title('R')
% 
% subplot(2,2,3)
% bar(binLocationsG, countsG/sum(countsG), 'grouped', 'green');
% title('G')
% 
% subplot(2,2,4)
% bar(binLocationsB, countsB/sum(countsB), 'grouped', 'blue');
% title('B')

%% Distintas opciones
Drg = uint8(uint16(r-g)*256./uint16(r+g+b));

Drg2 = rescale((single(r)-single(g))./single(r+g+b));

% figure(4)
% imshow(Drg2, [])

figure(5)
imshow(Drg)

%% Umbral
imgBin = imbinarize(Drg);
% imgBin = imbinarize(Drg, graythresh(Drg));

figure(6)
subplot(1,2,1)
imshow(imgOriginal)
subplot(1,2,2)
imshow(imgBin)

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
imgApple(~imgOpenedClosed) = 0;



figure(8)
subplot(1,2,1)
imshow(r)
subplot(1,2,2)
imshow(imgApple)



% ¿Bordes?
se = strel('diamond', 2);
imgBorder = imclose(edge(imgApple), se) | edge(imgOpenedClosed);
figure(9)


subplot(1,2,1)
imshow(edge(imgApple))
subplot(1,2,2)
imshow(imgBorder)


%% Bordes bien
[~, imgBoundaries] = bwboboundaiundaries(imgBorder, 'holes');
[~, imgRealBoundaries] = bwboundaries(imgBorder, 'noholes');
imgWithoutBoundaries = imgBoundaries;
imgWithoutBoundaries(imgRealBoundaries ~= 0) = 0;

figure(10)
subplot(1,3,1)
imshow(label2rgb(imgBoundaries, @jet, [.5,.5,.5]))
subplot(1,3,2)
imshow(label2rgb(imgRealoundaries, @jet, [.5,.5,.5]))

subplot(1,3,3)
imshow(label2rgb(imgWithoutBoundaries, @jet, [.5,.5,.5]))

%% Imagen rellena ñamñam
imgFilled = imfill(imgOpenedClosed, 'holes');

figure(91)
subplot(1,2,1)
imshow(imgOriginal) 
subplot(1,2,2)
imshow(imgFilled)

[~, imgBoundaries] = bwboundaries(imgFilled, 'holes');

% Máscara

limpiaX3 = uint8(cat(3, imgWithoutBoundaries, imgWithoutBoundaries, imgWithoutBoundaries));
Inew = limpiaX3.*imgOriginal;

figure(92)
subplot(1,2,1)
imshow(label2rgb(imgBoundaries, @jet, [.5,.5,.5]))
subplot(1,2,2)
imshow(Inew)

%% Características
caract = regionprops(imgFilled, 'all');

figure(11)
subplot(1,2,1)
imshow(imgReduced);

for i = 1:length(caract)
%     if caract(i).Area < 100
%         continue
%     end
    rectangle('Position', caract(i).BoundingBox, 'LineWidth', 2, 'EdgeColor', 'r')
end

subplot(1,2,2)
imshow(imgReduced);
for i = 1:length(caract)
    if caract(i).Area < 100
        continue
    end
    rectangle('Position', caract(i).BoundingBox, 'LineWidth', 2, 'EdgeColor', 'r')
end
