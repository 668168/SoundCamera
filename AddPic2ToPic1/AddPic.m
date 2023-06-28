clear; close all; clc; yPix = 640; zPix = 480; nBit = 8;
%% **********         读取 Pic1 和 Pic2         **********
Pic1 = imread('1.jpg');                  % Pic1: 1.jpg 或 2.jpg
load('Pic2.mat');             % NAH给出的原始声压分布矩阵
Pic2 = MyNormlizeMat(Pic2, 0, 255); Pic2 = uint8(Pic2);
%% ***********************************************
% *****************     融合 Pic1 和 Pic2     **************
% ********************************************************
%% *****     将 Pic2 作为 Pic1 的 Alpha 通道      *****
% b1 = 10; b2 = 255;               Pic2 = double( Pic2 );
% Pic2 = mapminmax(Pic2, b1, b2);     % 归一化 至 b
% Pic2 = uint8( round( Pic2 ) );                     % uint8
% imwrite(      Pic1, 'AddPic3.png', 'Alpha', Pic2      );
%% ** 将 Pic2 点乘 c 再 叠加 至 Pic1 的 R/G/B 通道 **
% c = 1;         % Pic2 叠加 至 Pic1 的 R/G/B 通道 的 系数
% % ***********            R/G/B: i = 1/2/3            ***********
% Pic3 = Pic1; i = 1;     C = double( squeeze(Pic3(:,:,i)) );
% C = C + c .* double(Pic2); C = mapminmax(C, 0, 255);
% C = uint8( round( C ) );                           Pic3(:,:,i) = C;
% imwrite(               Pic3,        'AddPic3.png'               );
%% ***  将 Pic2 归一化 至 [b1, b2] 再 点乘至 Pic1  ***
% b1 = 1; b2 = 2;                    Pic2 = double( Pic2 );
% Pic2 = mapminmax(Pic2, b1, b2);     % 归一化 至 b
% Pic3 = double( Pic1 ) .* Pic2;            % 点乘至 Pic1
% for i = 1:3                                    % uint8: 0 - 255
%     Pic3(:,:,i) = mapminmax(Pic3(:,:,i), 0, 255);
% end
% Pic3 = uint8( round( Pic3 ) );                     % uint8
% imwrite(            Pic3,         'AddPic3.png'            );
%% 将 Pic2 归一化 至 [b1, b2] 再 点乘至 Pic1 的 R/G/B
% b1 = 1; b2 = 2;                           Pic2 = double( Pic2 );
% Pic2 = mapminmax(Pic2, b1, b2);            % 归一化 至 b
% % ***********            R/G/B: i = 1/2/3            ***********
% i = 1; Pic3 = Pic1; Pic3(:,:,i) = double( Pic1(:,:,i) ) .* Pic2;
% Pic3(:,:,i) = mapminmax(           Pic3(:,:,i), 0, 255          );
% Pic3 = uint8( round( Pic3 ) );                             % uint8
% imwrite(                 Pic3,       'AddPic3.png'                 );
%% 采用 AddPic2ToPic1 函数
% Th = uint8( 200 ); Pic3 = AddPic2ToPic1( Pic1, Pic2, Th );
% imwrite(                 Pic3,         'AddPic3.png'                 );
%% 采用 AddPressMatToPic1 函数
load('Pic2.mat');              % NAH给出的原始声压分布矩阵
Ns = 2; b = 0.8;                                           % 参数 设定

Pic3 = AddPressMatToPic1(   Pic1 ,  Pic2 ,  Ns ,  b ,  0   );
imwrite(                 Pic3,         'AddPic3.png'                 );

