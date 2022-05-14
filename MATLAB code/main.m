clc
clear all
addpath('./features/');

srno = '4.png';
url = "./img/Shadow/"+srno;
[seg, segnum, between, near, label] = detect(url);
[test_im,test_im1] = removal(seg, segnum, between, label, near, url);


% figure;
% imshowpair(imread(url), test_im, 'montage'),title('RESULT');

figure;
subplot(2,2,1),imshow(url),title('Original image');
subplot(2,2,2),imshow(imcomplement(label(seg))),title('Shadow mask');
subplot(2,2,3),imshow(test_im1),title('Shadow removal');
subplot(2,2,4),imshow(test_im),title('Smoothening of edges after shadow removal');
imwrite(test_im1,"./img/test_im.png");

% Original Image
oim = double(imread(url));
tim = double(imread("./img/test_im.png"));
[rows, columns] = size(tim);
% Ground Truth Image address name
gurl = "./img/Ground/"+srno;
gim = double(imread(gurl));
% ggim = rgb2gray(gim);
% goim = rgb2gray(oim);
% gtim = rgb2gray(tim);

fprintf("Non shadow image:\n");
fprintf("\nRMSE: %.2f", RMSE_RGB(tim,gim));
fprintf("\nPSNR: %.2f", PSNR_RGB(tim,gim));
ssimval = SSIM(tim,gim);
fprintf("\nSSIM: %.2f\n", ssimval);
fprintf("\nOriginal Shadow image:\n");
fprintf("\nRMSE: %.2f", RMSE_RGB(oim,gim));
fprintf("\nPSNR: %.2f", PSNR_RGB(oim,gim));
ossimval = SSIM(oim,gim);
fprintf("\nSSIM: %.2f\n", ossimval);