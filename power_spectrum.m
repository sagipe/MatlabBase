function [pspectrum f]= power_spectrum(sig, Fs, NFFT)
%
%   Computes the power spectrum of a sampled signal. 
%   INPUTS:
%   sig : vector containing the sampled values of the signal
%   [Fs]: sampling frequency of the signal. default- 1Hz
%   [NFFT]: length of fft . default- next power of 2 from signal length
%
%   OUTPUTS:
%   pspectrum: Single sided amplitude spectrum
%   f        : Single sided frequency in Hz
%
%   Sagi Perel, 02/2008

% ---- sanity check on inputs
sig_size = size(sig);
if(sig_size(1) > 1 && sig_size(2) > 1)
    error('power_spectrum: sig has to be either a row or a column vector');
end

if(~exist('Fs','var'))
    Fs = 1;
end

% ---- make sig a column vector
if(sig_size(1) == 1 && sig_size(2) ~= 1)
    sig = sig';
end
sig_len = length(sig);

% ---- compute the power spectrum
if(~exist('NFFT','var'))
    NFFT      = 2^nextpow2(sig_len); % Next power of 2 from length of signal
end
Y         = fft(sig,NFFT)/sig_len;
pspectrum = 2*abs(Y(1:NFFT/2));
f         = Fs/2*linspace(0,1,NFFT/2);
