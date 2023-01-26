function [bbox, centroids] = get_apples(img)
% get_apples Returns bounding boxes and centroids of apples in the image
%   [bbox, centroids] = get_apples(img) returns the bounding boxes of the N
%   detected apples in an Nx4 matrix bbox, and the centorids in an Nx2 matrix
%   centroids, of the full coluor RGB image img. Also, an image is plotted

% extract colours
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);

% Drg (uint8)
Drg = uint8(uint16(r-g)*256./uint16(r+g+b));

% thresholding via Otsu's method - binary image
binImg = imbinarize(Drg);

% structuring element diamond 3
se = strel('diamond',2);

% opening, closing, and filling
imgClean = imclose(binImg,se);
imgClean = imopen(imgClean,se);
imgClean = imfill(imgClean);

% characteristic
charact = regionprops(imgClean, 'all');

% boundig boxes and centroids
bbox = vertcat(charact.BoundingBox);
centroids = vertcat(charact.Centroid);

% plot figure with boundign boxes
figure(111)
imshow(img);

for i = 1:length(charact)
    rectangle('Position', bbox(i, :), 'LineWidth', 2, 'EdgeColor', 'r')
end

end
