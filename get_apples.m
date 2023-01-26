function [bbox, centroids] = get_apples(imgOri)

r = imgOri(:,:,1);
g = imgOri(:,:,2);
b = imgOri(:,:,3);

Drg = uint8(uint16(r-g)*256./uint16(r+g+b));

Drg_bin = imbinarize(Drg,100/256);

se = strel('diamond',3);
imgClean = imopen(Drg_bin,se);
imgClean = imclose(imgClean,se);

caract = regionprops(imgClean, 'all');



bbox = vertcat(caract.BoundingBox);
centroids = vertcat(caract.Centroid);

figure(111)
imshow(imgOri);

for i = 1:length(caract)
    rectangle('Position', bbox(i, :), 'LineWidth', 2, 'EdgeColor', 'r')
end

end
