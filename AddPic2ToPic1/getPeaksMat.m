function [P, Idx] = getPeaksMat( A, N, isPad )
%********************************************************************************************************************
%**********************              Copyright: GGEC. Author: Kailing YI. 2023,02,08               **********************
%********************************************************************************************************************
% 函数 根据 梯度法 计算 矩阵A 中 最大的 N 个 [严格]峰值 P, 及 其 索引 Idx. Param:
% P: N×1. Idx: N×2, A(Idx(:,1), Idx(:,2)) == P. P 值 降序 排列.         isPad: Padding.
% 1. Nm[计算得到的峰值个数] < N[要求输出的峰值个数]
%               此时: 仅 含 Nm 个 峰 —— P: Nm×1. Idx: Nm×2
% 2. Nm[计算得到的峰值个数] > N[要求输出的峰值个数]
%               此时: 仅 含  N   个 峰 —— P: N×1. 取 最大 的 N 个 峰
%% [P, Idx] = getPeaksMat( A, N, isPad )
if nargin < 3; isPad = 1; end; assert( ismatrix(A), 'A: 矩阵.' );
assert( isscalar(N), 'N: 标量.');      assert( N >= 0, 'N >= 0.');
if N == 0;               P = []; Idx = [];     return;               end
[N1,N2] = size(A);                                            N = ceil(N);
%% 计算 前后左右 差分/梯度, 给出 [严格]峰值 位置
if isPad == 1                                                    % Padding
    Dw = min(A, [], 'all') - 1; N2 = N2+2;      % Dw: Padd 值
    A = [Dw.*ones(N1, 1), A, Dw.*ones(N1, 1)];    % 列 Padd
    A = [Dw.*ones(1, N2); A; Dw.*ones(1, N2)];    % 行 Padd
    [N1,N2] = size(A);                                    % update Size
end

AL = [A(:,1), A(:,1:N2-1)];                AR = [A(:,2:N2), A(:,N2)];
AU = [A(1,:); A(1:N1-1,:)];               AD = [A(2:N1,:); A(N1,:)];

DL = A - AL; DR = A - AR;        DU = A - AU; DD = A - AD;
Idx0 = (DL>0) & (DR>0)  &  (DU>0) & (DD>0); % 严格峰值

if isempty(Idx0); P = []; Idx = []; return; end  % 无峰: 返回 [ ]

Nm = sum( Idx0, 'all' );                 % 搜寻到的 严格峰值 总数
%% 计算 峰值 P 及 其 索引 Idx: P 降序排列
P = zeros(Nm,1); Idx = zeros(Nm,2); n = 1;            % 初始化
for i1 = 1:N1
    for i2 = 1:N2
        if Idx0(i1, i2)
            P(n) = A(i1, i2); Idx(n, :) = [i1, i2]; n = n + 1;
        end
    end
end
[P, Idx1 ] = sort( P, 'descend' ); Idx = Idx(Idx1, :); % 降序排列

if Nm < N    % 计算得到的峰值个数 < N[要求输出的峰值个数]
    P = P(1:Nm); Idx = Idx(1:Nm,:);             % 仅 含 Nm 个 峰
    warning(['仅检测到 ' num2str(Nm) ' 个 峰值.']);       % 警告
else              % 计算得到的峰值个数 > N[要求输出的峰值个数]
    P = P(1:N); Idx = Idx(1:N,:);             % 仅 取 最大的N 个 峰
end

if isPad;    Idx = Idx - 1;    end                 % Padding: Idx - 1
end

