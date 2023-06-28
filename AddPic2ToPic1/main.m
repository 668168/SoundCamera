clear; close all; clc;                   % 图片格式: RGB, Uint8
%% **************         Pic1 参数         **************
% --------------   Pic1 参数: 由 樊工 提供   --------------
FovH = 2 * 94.5; FovV = 2* 75;                     % FOV: 度
nH = 640; nV = 480;  % Pic1 的 Size: nH 列 nV 行, Pix
dCm = 1;   % Pic1中心 对应的 实际位置 与 相机 距离, 米
% *********************  设定 Pic1  ********************
Pic1 = randn(nV, nH);       Pic1 = repmat(Pic1, 1, 1, 3);
Pic1 = MyNormlizeMat( Pic1, 0, 255 );           % 归一化
Pic1 = uint8( round(Pic1) );               % 数据类型: uint8
%% **************         Pic2 参数         **************
% --------------   Pic2 参数: 由 易工 提供   --------------
% 坐标: 阵列中心 - 原点. 由 阵列 至 被测物体 看去,  正前 
% 为 x轴, 正左 为 y轴, 正上 为 z轴.    Pic2: [yGrid, zGrid]
% 实际, Pic2较于Pic1: y 对应 Horizontal, z 对应 Vertical
d = 1.0;                                         % 重构面 为 x = d 处
Ly = 1.5; Lz = 1.5;           % Pic2 空间 Size: [+-Ly, +-Lz]
dyG = 0.04;  dzG = 0.04;     % Pic2 对应 的 空间 采样率
% --------------------------------------------------------
FovY = 2 * atand( Ly/d );       FovZ = 2 * atand( Lz/d );
yGrid = -Ly : dyG : Ly;                 zGrid = -Lz : dzG : Lz;
nY = length(yGrid); nZ = length(zGrid); % nY 行 nZ 列
% ********************   设定 Pic2   ********************
Pic2 = hann(nY) * hann(nZ).';       % NAH 声压矩阵: dB
%% **********            Pic2 格式转换            **********
% -------------------      Pic2 处理      -------------------
% Pic2 沿 x轴 平移 直至 d = dCm (因为 d < dCm), 裁切
% 或 充零 Pic2, 给出 Same Size oF Pic1 的 Pic2Re 【1】
% *****************************************************
% Pic2 沿 原点发出的射线 发散 至 d = dCm (仿射), 裁切
% 或 充零 Pic2, 给出 Same Size oF Pic1 的 Pic2Re 【2】
% *****************************************************
Pic2 = 10 .^ (Pic2 ./ 20);           % dB 单位 的 Pic2 转换
Pic2 = Pic2.';   % Pic2转置, 于是 nZ行 nY列 == nV×nH
Pic2 = Pic2(:, end:-1:1);               % y: 右到左 转 左到右
% -------------------------------------------------------
% *****************************************************
% 1. 确定 Pic2 在 Pic1 中 的 位置、索引
% *****************************************************
% Pic2 沿 x轴 平移 直至 d = dCm (因为 d < dCm)【1】
bY = abs( Ly ./ (dCm*tand(FovH/2)) );  % Y:  Pic2/Pic1
bZ = abs( Lz ./ (dCm*tand(FovV/2)) );  % Z:  Pic2/Pic1
% *****************************************************
% bY = abs( tand(FovY/2) ./ tand(FovH/2) );         % Y
% bZ = abs( tand(FovZ/2) ./ tand(FovV/2) );         % Z
% Pic2 沿 原点发出的射线 发散 至 d = dCm (仿射) 【2】
% *****************************************************
if bY > 1                               % Y/H 方向 Pic2 超出 Pic1
    bY = 1 / bY;                   % Y: Pic1 在 Pic2 中 的 占比
    nY1 = round(nY .* bY);         % Pic2: 裁切后的 Y Size
    nIdxY = round((nY - nY1) / 2);  % Pic2: 两侧各nIdxY
    IdxY = (1:nY1) + nIdxY;            nY = nY1;      bY = 1;
    Pic2 = Pic2(IdxY, :);  yGrid = yGrid(IdxY);       % 更新
end                             % Pic2: Y/H 方向 Pic2 在 Pic1 内
nH1 = round( nH .* bY   );        % Pic1: Pic2 所占 Y Size
nIdxY = round((nH - nH1) / 2);     % Pic1: 两侧各 nIdxY
dyR = 2 * Ly / (nH1 - 1);                yGd = -Ly : dyR : Ly;
IdxY = (nIdxY+1) : (nIdxY+nH1);     % Pic2 Index For Y
% --------------------------------------------------------
if bZ > 1                               % Z/V 方向 Pic2 超出 Pic1
    bZ = 1 / bZ;                   % Z: Pic1 在 Pic2 中 的 占比
    nZ1 = round(nZ .* bZ);         % Pic2: 裁切后的 Z Size
    nIdxZ = round((nZ - nZ1) / 2);  % Pic2: 两侧各nIdxZ
    IdxZ = (1:nZ1) + nIdxZ;            nZ = nZ1;      bZ = 1;
    Pic2 = Pic2(IdxZ, :);  zGrid = zGrid(IdxZ);       % 更新
end                             % Pic2: Z/V 方向 Pic2 在 Pic1 内
nV1 = round( nV .* bZ   );        % Pic1: Pic2 所占 Z Size
nIdxZ = round((nV - nV1) / 2);     % Pic1: 两侧各 nIdxZ
dzR = 2 * Lz / (nV1 - 1);                 zGd = -Lz : dzR : Lz;
IdxZ = (nIdxZ+1) : (nIdxZ+nV1);     % Pic2 Index For Z
% *****************************************************
% 2. Resample Pic2, get Pic2R,   as [IdxZ, IdxY] in Pic1
% *****************************************************
Pic2R = InterpXY(     zGrid, yGrid, Pic2, zGd, yGd      );
Pic2Re = zeros(nV, nH);     Pic2Re(IdxZ, IdxY) = Pic2R;
% *****************************************************
% 3. Add Pic2 to Pic1:  采用 AddPressMatToPic1 函数
% *****************************************************
Ns = 2; b = 0.8;                                          % 参数 设定
Pic3 = AddPressMatToPic1(Pic1 ,  Pic2Re , Ns , b ,  0);

