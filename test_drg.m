%% Script to test the Drg canal. Needs image

r = image(:,:,1);
g = image(:,:,2);
b = image(:,:,3);

drg = uint8(uint16(r-g)*256./uint16(r+g+b));
drb = uint8(uint16(r-b)*256./uint16(r+g+b));

figure(1)
imshow(image)
figure(2)
imshow(drg)
figure(3)
imshow(drb)
