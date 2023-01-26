original = imread('dataset1_back_631.png');

reducida = imresize(original,0.5);

figure(1)
subplot(1,2,1), imshow(original);
title('Original');
subplot(1,2,2), imshow(reducida);
title('Reducida 0.5');

%% Obtención de RGB
% Se observa en los resultados como ninguno de los canales por separado
% permite distinguir las manzanas del resto de la imagen.

r = reducida(:,:,1);
g = reducida(:,:,2);
b = reducida(:,:,3);

figure(2)
subplot(1,3,1), imshow(r);
title('Canal R');
subplot(1,3,2), imshow(g);
title('Canal G');
subplot(1,3,3), imshow(b);
title('Canal B');

%% Obtención de Drg y Drb

r0 = cast(r,"single")./(cast(r,"single")+cast(g,"single")+cast(b,"single"));
g0 = cast(g,"single")./(cast(r,"single")+cast(g,"single")+cast(b,"single"));
b0 = cast(b,"single")./(cast(r,"single")+cast(g,"single")+cast(b,"single"));

Drg = r0-g0;
Drb = r0-b0;pixel distribution 

alpha = 0.15;
beta = 0.25;

figure(3)
scatter(Drb,Drg);
% title('Distribución de píxeles en Drb/Drg');
xlabel('Drb') 
ylabel('Drg')

%% Umbral propio con floats
Drg_bin = imbinarize(Drg,alpha);

figure (4)
subplot(1,3,1), imshow(reducida);
subplot(1,3,2), imagesc(Drg_bin);
subplot(1,3,3), imshow(Drg);

%% Opening and closing
% La máscara disco da resultados muy cuadrados. El diamante da
% resultados mas redondos. El diametro 3 parece el mejor compromiso entre
% perder manzanas (diametros mayores) y captar ruido (diametros menores)

se = strel('diamond',3);
limpia = imopen(Drg_bin,se);
limpia = imclose(limpia,se);

se = strel('diamond',2);
limpia2 = imopen(Drg_bin,se);
limpia2 = imclose(limpia2,se);

se = strel('disk',3);
limpia3 = imopen(Drg_bin,se);
limpia3 = imclose(limpia3,se);

% figure (5)
subplot(1,5,1), imshow(reducida);
title('Original');
subplot(1,5,2), imagesc(Drg_bin);
title('Binarizado');
subplot(1,5,3), imagesc(limpia);
title('Diamante 3');
subplot(1,5,4), imagesc(limpia2);
title('Diamante 2');
subplot(1,5,5), imagesc(limpia3);
title('Disco 3');

%% Bordes 

gris = rgb2gray(reducida);
BW2=edge(gris,'canny'); 

figure(6);
subplot(1,3,1), imshow(gris);
subplot(1,3,2), imshow(BW2);
title('Reducida 0.5');

%% Aplicar mascara
% Aplico sobre la imagen original la mascara

limpiaX3 = cat(3, limpia, limpia, limpia);
Inew = r.*uint8(limpia);

figure(7);
subplot(1,3,1), imshow(reducida);
subplot(1,3,2), imshow(limpia);
subplot(1,3,3), imshow(Inew);

%% Características
caract = regionprops(limpia, 'all');

figure(8)
imshow(original);

for i = 1:length(caract)
    rectangle('Position', caract(i).BoundingBox*2, 'LineWidth', 2, 'EdgeColor', 'r')
end

