function [ Pic3, IdxS, Peaks ] = AddPressMatToPic1( Pic1, PressMat, Ns, b, is_dB )
%********************************************************************************************************************
%**********************              Copyright: GGEC. Author: Kailing YI. 2023,02,07               **********************
%********************************************************************************************************************
% 函数 实现 将 NAH 算法 给出的声压幅度分布矩阵PressMat 融合 至 Camera获取的图像Pic1. 
% Input:
% Pic1: Camera 获取 的 RGB 图片, M×N×3. uint8.
% PressMat: 原始的声压幅度分布矩阵, M×N. double.
% Ns: 设定 在 Pic1 中 将要显示 最大的 Ns 个 严格峰值.
% b: 设定 PressMat >= b * min(Peaks) 时, 显示 云图像素.
% is_dB: 指定 PressMat 是否 以 dB 为 单位.
% Output:
% Pic3: RGB 融合 图片, M×N×3. uint8.
% IdxS: Ns×2. 估计 的 声源 位置 索引: PressMat(IdxS(i,:)) 即 第 i-th 个 Peaks 值.
% Peaks: Ns×1. 估计 的 声源 位置 处 的 声压幅度值, 幅值 降序排列, 单位: not_dB.
% 处理流程:
% 0. 将 dB 单位 的 PressMat 转换 单位;
% 1. 计算 PressMat 最大 的 Ns 个 严格峰值:
%        [P, Idx] = getPeaksMat( PressMat, Ns ); Th = b * min(P); 
% 2. 处理 PressMat 数据, 获取 映射图例C:
%        if Idx = PressMat < Th, 则 PressMat(Idx) = Th;
%        PressMat 归一化至 0~255, 并取 uint8;
%        Th = uint8(  1  ); nJet = 255 - Th + 1; C = jet(nJet);
% 3. 制作 Pic0[RGB] 以 叠加 至 Pic1:
%        if Idx = PressMat > 0, 则 Pic0(Idx, :) = C(PressMat(Idx) - Th + 1, :);
% 4. 叠加 云图: Pic3 = Pic1 + Pic0;
%% [ Pic3 ] = AddPressureMatToPic1( Pic1, PressMat, Ns, b, is_dB )
if nargin < 4; b = 0.8; end;                        if nargin < 5; is_dB = 1; end
assert(ndims(Pic1) == 3,                 'Pic1: RGB Camera 图片, M×N×3.');
[M, N, isRGB] = size(Pic1);                    assert(isRGB == 3, 'Pic1: RGB.');
assert(ismatrix(PressMat),                     'Pic2: 声压幅度分布矩阵, M×N.');
assert(all( size(PressMat) == [M, N] ),          'Pic2: 声压幅度矩阵, M×N');
assert(isscalar(Ns) && isscalar(b) && isscalar(is_dB), 'Ns, b, is_dB: 标量');
assert(Ns > 0, 'Ns > 0.');               assert(b >= 0 && b <= 1, 'b: 0 ~ 1.');
%% 0. 将 dB 单位 的 PressMat 转换 单位;
if is_dB == 1;               PressMat = 10 .^ (PressMat ./ 20);               end
%% 1. 计算 PressMat 最大 的 Ns 个 严格峰值:
[Peaks, IdxS] = getPeaksMat( PressMat, Ns );         Th = b * min(Peaks); 
%% 2. 处理 PressMat 数据, 获取 映射图例C:
PressMat(PressMat < Th) = Th;                                  % PressMat < Th
PressMat = MyNormlizeMat( PressMat, 0, 255 );         % 归一化 至 uint8
PressMat = uint8( round(PressMat) );                         % 数据类型: uint8
Th = uint8( 1 );                                                          % 更新 阈值: uint8

nJet = 255 - double(Th) + 1; C = jet(nJet);           % 图例 C: 使用 jet 图例
C = mapminmax(C.', 0, 255); C = uint8( C.' );           % 图例 C: 改为 uint8
%% 3. 制作 Pic0[RGB] 以 叠加 至 Pic1
Pic0 = zeros(size(Pic1), 'uint8');                          % 由 PressMat 制作 Pic0
for i1 = 1:M
    for i2 = 1:N
        if PressMat(i1, i2) > 0
            Pic0(i1, i2, :) = C(PressMat(i1, i2) - double(Th) + 1, :);
        end
    end
end
%% 4. 叠加 云图: Pic3 = Pic1 + Pic0;
Pic3 = Pic1 + Pic0;
end

