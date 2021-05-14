function W = awt1d(I, varargin)
% W = AWT(I) computes the A Trou Wavelet Transform of image I.
% A description of the algorithm can be found in:
% J.-L. Starck, F. Murtagh, A. Bijaoui, "Image Processing and Data
% Analysis: The Multiscale Approach", Cambridge Press, Cambridge, 2000.
%
% W = AWT(I, nBands) computes the A Trou Wavelet decomposition of the
% image I up to nBands scale (inclusive). The default value is nBands =
% ceil(max(log2(N), log2(M))), where [N M] = size(I).
%
% Output:
% W contains the wavelet coefficients, an array of size N x M x nBands+1.
% The coefficients are organized as follows:
% W(:, :, 1:nBands) corresponds to the wavelet coefficients (also called
% detail images) at scale k = 1...nBands
% W(:, :, nBands+1) corresponds to the last approximation image A_K.
%
% You can use awtDisplay(W) to display the wavelet coefficients.
%
% Sylvain Berlemont, 2009

[N, M] = size(I);

K = ceil(max(log2(N), log2(M)));

nBands = K;

if nargin > 1 && ~isempty(varargin{1})
    nBands = varargin{1};
    
    if nBands < 1 || nBands > K
        error('invalid range for nBands parameter.');
    end
end

W = zeros(N, M, nBands + 1);

I = double(I);
lastA = I;

for k = 1:nBands
    newA = convolve(lastA, k);
    W(:, :, k) = lastA - newA;
    lastA = newA;
end

W(:, :, nBands + 1) = lastA;


function F = convolve(I, k)
[N, M] = size(I);
k1 = 2^(k - 1);
%k2 = 2^k;


tmp = padarray(I, [0, k1], 'replicate');

% Convolve the rows
for i = k1+1:k1+M
    I(:, i - k1) = 2*tmp(:, i) + (tmp(:, i + k1) + tmp(:, i - k1));
end

F = I * .25;