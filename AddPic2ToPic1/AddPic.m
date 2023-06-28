clear; close all; clc; yPix = 640; zPix = 480; nBit = 8;
%% **********         ��ȡ Pic1 �� Pic2         **********
Pic1 = imread('1.jpg');                  % Pic1: 1.jpg �� 2.jpg
load('Pic2.mat');             % NAH������ԭʼ��ѹ�ֲ�����
Pic2 = MyNormlizeMat(Pic2, 0, 255); Pic2 = uint8(Pic2);
%% ***********************************************
% *****************     �ں� Pic1 �� Pic2     **************
% ********************************************************
%% *****     �� Pic2 ��Ϊ Pic1 �� Alpha ͨ��      *****
% b1 = 10; b2 = 255;               Pic2 = double( Pic2 );
% Pic2 = mapminmax(Pic2, b1, b2);     % ��һ�� �� b
% Pic2 = uint8( round( Pic2 ) );                     % uint8
% imwrite(      Pic1, 'AddPic3.png', 'Alpha', Pic2      );
%% ** �� Pic2 ��� c �� ���� �� Pic1 �� R/G/B ͨ�� **
% c = 1;         % Pic2 ���� �� Pic1 �� R/G/B ͨ�� �� ϵ��
% % ***********            R/G/B: i = 1/2/3            ***********
% Pic3 = Pic1; i = 1;     C = double( squeeze(Pic3(:,:,i)) );
% C = C + c .* double(Pic2); C = mapminmax(C, 0, 255);
% C = uint8( round( C ) );                           Pic3(:,:,i) = C;
% imwrite(               Pic3,        'AddPic3.png'               );
%% ***  �� Pic2 ��һ�� �� [b1, b2] �� ����� Pic1  ***
% b1 = 1; b2 = 2;                    Pic2 = double( Pic2 );
% Pic2 = mapminmax(Pic2, b1, b2);     % ��һ�� �� b
% Pic3 = double( Pic1 ) .* Pic2;            % ����� Pic1
% for i = 1:3                                    % uint8: 0 - 255
%     Pic3(:,:,i) = mapminmax(Pic3(:,:,i), 0, 255);
% end
% Pic3 = uint8( round( Pic3 ) );                     % uint8
% imwrite(            Pic3,         'AddPic3.png'            );
%% �� Pic2 ��һ�� �� [b1, b2] �� ����� Pic1 �� R/G/B
% b1 = 1; b2 = 2;                           Pic2 = double( Pic2 );
% Pic2 = mapminmax(Pic2, b1, b2);            % ��һ�� �� b
% % ***********            R/G/B: i = 1/2/3            ***********
% i = 1; Pic3 = Pic1; Pic3(:,:,i) = double( Pic1(:,:,i) ) .* Pic2;
% Pic3(:,:,i) = mapminmax(           Pic3(:,:,i), 0, 255          );
% Pic3 = uint8( round( Pic3 ) );                             % uint8
% imwrite(                 Pic3,       'AddPic3.png'                 );
%% ���� AddPic2ToPic1 ����
% Th = uint8( 200 ); Pic3 = AddPic2ToPic1( Pic1, Pic2, Th );
% imwrite(                 Pic3,         'AddPic3.png'                 );
%% ���� AddPressMatToPic1 ����
load('Pic2.mat');              % NAH������ԭʼ��ѹ�ֲ�����
Ns = 2; b = 0.8;                                           % ���� �趨

Pic3 = AddPressMatToPic1(   Pic1 ,  Pic2 ,  Ns ,  b ,  0   );
imwrite(                 Pic3,         'AddPic3.png'                 );

