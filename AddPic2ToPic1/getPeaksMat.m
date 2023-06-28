function [P, Idx] = getPeaksMat( A, N, isPad )
%********************************************************************************************************************
%**********************              Copyright: GGEC. Author: Kailing YI. 2023,02,08               **********************
%********************************************************************************************************************
% ���� ���� �ݶȷ� ���� ����A �� ���� N �� [�ϸ�]��ֵ P, �� �� ���� Idx. Param:
% P: N��1. Idx: N��2, A(Idx(:,1), Idx(:,2)) == P. P ֵ ���� ����.         isPad: Padding.
% 1. Nm[����õ��ķ�ֵ����] < N[Ҫ������ķ�ֵ����]
%               ��ʱ: �� �� Nm �� �� ���� P: Nm��1. Idx: Nm��2
% 2. Nm[����õ��ķ�ֵ����] > N[Ҫ������ķ�ֵ����]
%               ��ʱ: �� ��  N   �� �� ���� P: N��1. ȡ ��� �� N �� ��
%% [P, Idx] = getPeaksMat( A, N, isPad )
if nargin < 3; isPad = 1; end; assert( ismatrix(A), 'A: ����.' );
assert( isscalar(N), 'N: ����.');      assert( N >= 0, 'N >= 0.');
if N == 0;               P = []; Idx = [];     return;               end
[N1,N2] = size(A);                                            N = ceil(N);
%% ���� ǰ������ ���/�ݶ�, ���� [�ϸ�]��ֵ λ��
if isPad == 1                                                    % Padding
    Dw = min(A, [], 'all') - 1; N2 = N2+2;      % Dw: Padd ֵ
    A = [Dw.*ones(N1, 1), A, Dw.*ones(N1, 1)];    % �� Padd
    A = [Dw.*ones(1, N2); A; Dw.*ones(1, N2)];    % �� Padd
    [N1,N2] = size(A);                                    % update Size
end

AL = [A(:,1), A(:,1:N2-1)];                AR = [A(:,2:N2), A(:,N2)];
AU = [A(1,:); A(1:N1-1,:)];               AD = [A(2:N1,:); A(N1,:)];

DL = A - AL; DR = A - AR;        DU = A - AU; DD = A - AD;
Idx0 = (DL>0) & (DR>0)  &  (DU>0) & (DD>0); % �ϸ��ֵ

if isempty(Idx0); P = []; Idx = []; return; end  % �޷�: ���� [ ]

Nm = sum( Idx0, 'all' );                 % ��Ѱ���� �ϸ��ֵ ����
%% ���� ��ֵ P �� �� ���� Idx: P ��������
P = zeros(Nm,1); Idx = zeros(Nm,2); n = 1;            % ��ʼ��
for i1 = 1:N1
    for i2 = 1:N2
        if Idx0(i1, i2)
            P(n) = A(i1, i2); Idx(n, :) = [i1, i2]; n = n + 1;
        end
    end
end
[P, Idx1 ] = sort( P, 'descend' ); Idx = Idx(Idx1, :); % ��������

if Nm < N    % ����õ��ķ�ֵ���� < N[Ҫ������ķ�ֵ����]
    P = P(1:Nm); Idx = Idx(1:Nm,:);             % �� �� Nm �� ��
    warning(['����⵽ ' num2str(Nm) ' �� ��ֵ.']);       % ����
else              % ����õ��ķ�ֵ���� > N[Ҫ������ķ�ֵ����]
    P = P(1:N); Idx = Idx(1:N,:);             % �� ȡ ����N �� ��
end

if isPad;    Idx = Idx - 1;    end                 % Padding: Idx - 1
end

