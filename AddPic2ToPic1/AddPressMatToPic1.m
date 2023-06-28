function [ Pic3, IdxS, Peaks ] = AddPressMatToPic1( Pic1, PressMat, Ns, b, is_dB )
%********************************************************************************************************************
%**********************              Copyright: GGEC. Author: Kailing YI. 2023,02,07               **********************
%********************************************************************************************************************
% ���� ʵ�� �� NAH �㷨 ��������ѹ���ȷֲ�����PressMat �ں� �� Camera��ȡ��ͼ��Pic1. 
% Input:
% Pic1: Camera ��ȡ �� RGB ͼƬ, M��N��3. uint8.
% PressMat: ԭʼ����ѹ���ȷֲ�����, M��N. double.
% Ns: �趨 �� Pic1 �� ��Ҫ��ʾ ���� Ns �� �ϸ��ֵ.
% b: �趨 PressMat >= b * min(Peaks) ʱ, ��ʾ ��ͼ����.
% is_dB: ָ�� PressMat �Ƿ� �� dB Ϊ ��λ.
% Output:
% Pic3: RGB �ں� ͼƬ, M��N��3. uint8.
% IdxS: Ns��2. ���� �� ��Դ λ�� ����: PressMat(IdxS(i,:)) �� �� i-th �� Peaks ֵ.
% Peaks: Ns��1. ���� �� ��Դ λ�� �� �� ��ѹ����ֵ, ��ֵ ��������, ��λ: not_dB.
% ��������:
% 0. �� dB ��λ �� PressMat ת�� ��λ;
% 1. ���� PressMat ��� �� Ns �� �ϸ��ֵ:
%        [P, Idx] = getPeaksMat( PressMat, Ns ); Th = b * min(P); 
% 2. ���� PressMat ����, ��ȡ ӳ��ͼ��C:
%        if Idx = PressMat < Th, �� PressMat(Idx) = Th;
%        PressMat ��һ���� 0~255, ��ȡ uint8;
%        Th = uint8(  1  ); nJet = 255 - Th + 1; C = jet(nJet);
% 3. ���� Pic0[RGB] �� ���� �� Pic1:
%        if Idx = PressMat > 0, �� Pic0(Idx, :) = C(PressMat(Idx) - Th + 1, :);
% 4. ���� ��ͼ: Pic3 = Pic1 + Pic0;
%% [ Pic3 ] = AddPressureMatToPic1( Pic1, PressMat, Ns, b, is_dB )
if nargin < 4; b = 0.8; end;                        if nargin < 5; is_dB = 1; end
assert(ndims(Pic1) == 3,                 'Pic1: RGB Camera ͼƬ, M��N��3.');
[M, N, isRGB] = size(Pic1);                    assert(isRGB == 3, 'Pic1: RGB.');
assert(ismatrix(PressMat),                     'Pic2: ��ѹ���ȷֲ�����, M��N.');
assert(all( size(PressMat) == [M, N] ),          'Pic2: ��ѹ���Ⱦ���, M��N');
assert(isscalar(Ns) && isscalar(b) && isscalar(is_dB), 'Ns, b, is_dB: ����');
assert(Ns > 0, 'Ns > 0.');               assert(b >= 0 && b <= 1, 'b: 0 ~ 1.');
%% 0. �� dB ��λ �� PressMat ת�� ��λ;
if is_dB == 1;               PressMat = 10 .^ (PressMat ./ 20);               end
%% 1. ���� PressMat ��� �� Ns �� �ϸ��ֵ:
[Peaks, IdxS] = getPeaksMat( PressMat, Ns );         Th = b * min(Peaks); 
%% 2. ���� PressMat ����, ��ȡ ӳ��ͼ��C:
PressMat(PressMat < Th) = Th;                                  % PressMat < Th
PressMat = MyNormlizeMat( PressMat, 0, 255 );         % ��һ�� �� uint8
PressMat = uint8( round(PressMat) );                         % ��������: uint8
Th = uint8( 1 );                                                          % ���� ��ֵ: uint8

nJet = 255 - double(Th) + 1; C = jet(nJet);           % ͼ�� C: ʹ�� jet ͼ��
C = mapminmax(C.', 0, 255); C = uint8( C.' );           % ͼ�� C: ��Ϊ uint8
%% 3. ���� Pic0[RGB] �� ���� �� Pic1
Pic0 = zeros(size(Pic1), 'uint8');                          % �� PressMat ���� Pic0
for i1 = 1:M
    for i2 = 1:N
        if PressMat(i1, i2) > 0
            Pic0(i1, i2, :) = C(PressMat(i1, i2) - double(Th) + 1, :);
        end
    end
end
%% 4. ���� ��ͼ: Pic3 = Pic1 + Pic0;
Pic3 = Pic1 + Pic0;
end

