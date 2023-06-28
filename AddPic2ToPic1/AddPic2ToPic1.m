function [ Pic3 ] = AddPic2ToPic1( Pic1, Pic2, Th )
%********************************************************************************************************************
%**********************              Copyright: GGEC. Author: Kailing YI. 2023,02,07               **********************
%********************************************************************************************************************
% 函数 实现 将 Pic2 融合 至 Pic1. 
% Input:
% Pic1: RGB Camera 图片, M×N×3. uint8.
% Pic2: 声压幅度分布矩阵, M×N. uint8.
% Th: 阈值设定. 0 ~ 255. uint8.
% Output:
% Pic3: RGB 融合 图片, M×N×3. uint8.
% 处理流程:
% 1. 将 Pic2 中 所有 小于 Th 的 值 置 0;
% 2. 获取 映射图例: nJet = 255 - double(Th) + 1; C = jet(nJet);
% 3. 制作 Pic0[RGB] 以 叠加 至 Pic1:
%        if Idx = Pic2 < Th, 则 Pic0(Idx, :) = zeros(1, 1, 3);
%        else, 则 Pic0(Idx, :) = C(Pic2(Idx), :);
% 4. 叠加 云图: Pic3 = Pic1 + Pic0;
%% [ Pic3 ] = AddPic2ToPic1( Pic1, Pic2, Th )
assert(ndims(Pic1) == 3, 'Pic1: RGB Camera 图片, M×N×3.');
[M, N, isRGB] = size(Pic1);    assert(isRGB == 3, 'Pic1: RGB.');
assert(ismatrix(Pic2),            'Pic2: 声压幅度分布矩阵, M×N.');
assert(all( size(Pic2) == [M, N] ),  'Pic2: 声压幅度矩阵, M×N');
assert(isscalar(Th));                assert(Th >=0 && Th <= 255);
%% 1. 将 Pic2 中 所有 小于 Th 的 值 置 0;
Pic2(Pic2 < Th) = 0;                                  % Pic2 < Th == 0
%% 2. 获取 映射图例: nJet = 255 - double(Th) + 1; C = jet(nJet);
nJet = 255 - double(Th) + 1; C = jet(nJet); % C: 使用 jet 图例

C = mapminmax(C.', 0, 255); C = uint8( C.' ); % C: 改为 uint8
%% 3. 制作 Pic0[RGB] 以 叠加 至 Pic1
Pic0 = zeros(size(Pic1), 'uint8');                % 由 Pic2 制作 Pic0
for i1 = 1:M
    for i2 = 1:N
        if Pic2(i1, i2) >= Th
            Pic0(i1, i2, :) = C(Pic2(i1, i2) - Th + uint8( 1 ), :);
        end
    end
end
%% 4. 叠加 云图: Pic3 = Pic1 + Pic0;
Pic3 = Pic1 + Pic0;
end

