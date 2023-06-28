function [ Pic3 ] = AddPic2ToPic1( Pic1, Pic2, Th )
%********************************************************************************************************************
%**********************              Copyright: GGEC. Author: Kailing YI. 2023,02,07               **********************
%********************************************************************************************************************
% ���� ʵ�� �� Pic2 �ں� �� Pic1. 
% Input:
% Pic1: RGB Camera ͼƬ, M��N��3. uint8.
% Pic2: ��ѹ���ȷֲ�����, M��N. uint8.
% Th: ��ֵ�趨. 0 ~ 255. uint8.
% Output:
% Pic3: RGB �ں� ͼƬ, M��N��3. uint8.
% ��������:
% 1. �� Pic2 �� ���� С�� Th �� ֵ �� 0;
% 2. ��ȡ ӳ��ͼ��: nJet = 255 - double(Th) + 1; C = jet(nJet);
% 3. ���� Pic0[RGB] �� ���� �� Pic1:
%        if Idx = Pic2 < Th, �� Pic0(Idx, :) = zeros(1, 1, 3);
%        else, �� Pic0(Idx, :) = C(Pic2(Idx), :);
% 4. ���� ��ͼ: Pic3 = Pic1 + Pic0;
%% [ Pic3 ] = AddPic2ToPic1( Pic1, Pic2, Th )
assert(ndims(Pic1) == 3, 'Pic1: RGB Camera ͼƬ, M��N��3.');
[M, N, isRGB] = size(Pic1);    assert(isRGB == 3, 'Pic1: RGB.');
assert(ismatrix(Pic2),            'Pic2: ��ѹ���ȷֲ�����, M��N.');
assert(all( size(Pic2) == [M, N] ),  'Pic2: ��ѹ���Ⱦ���, M��N');
assert(isscalar(Th));                assert(Th >=0 && Th <= 255);
%% 1. �� Pic2 �� ���� С�� Th �� ֵ �� 0;
Pic2(Pic2 < Th) = 0;                                  % Pic2 < Th == 0
%% 2. ��ȡ ӳ��ͼ��: nJet = 255 - double(Th) + 1; C = jet(nJet);
nJet = 255 - double(Th) + 1; C = jet(nJet); % C: ʹ�� jet ͼ��

C = mapminmax(C.', 0, 255); C = uint8( C.' ); % C: ��Ϊ uint8
%% 3. ���� Pic0[RGB] �� ���� �� Pic1
Pic0 = zeros(size(Pic1), 'uint8');                % �� Pic2 ���� Pic0
for i1 = 1:M
    for i2 = 1:N
        if Pic2(i1, i2) >= Th
            Pic0(i1, i2, :) = C(Pic2(i1, i2) - Th + uint8( 1 ), :);
        end
    end
end
%% 4. ���� ��ͼ: Pic3 = Pic1 + Pic0;
Pic3 = Pic1 + Pic0;
end

