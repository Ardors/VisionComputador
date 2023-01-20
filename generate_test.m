%% Generates image for color test
% Contains most of the color spectrum

s = 64;

prueba_r = uint8(zeros(s,s));
for i = 1:s
    prueba_r(:,i)=(i*256/s-1)*ones(s,1);
end

prueba_g = uint8(zeros(s,s));
for i = 1:s
    prueba_g(i,:)=(i*256/s-1)*ones(1,s);
end

prueba_rg = cat(3,prueba_r,prueba_g);

rg_h=cat(2,prueba_rg,prueba_rg,prueba_rg,prueba_rg);
rg_vh=cat(1,rg_h,rg_h,rg_h,rg_h);

prueba_b = uint8(zeros(256,s));
for i = 1:256
   prueba_b(i,:)=floor((i-1)/s)*s/4*ones(1,s);
end

b_vh = prueba_b;
mask = uint8(s*ones(256,s));
b_vh = cat(2,b_vh,prueba_b+mask);
b_vh = cat(2,b_vh,prueba_b+mask*2);
b_vh = cat(2,b_vh,prueba_b+mask*3);

color_test = cat(3,rg_vh,b_vh);

figure
imshow(color_test)