function [eps1,eps2,eps3,mse1,mse2,mse3] = WienerSingle_SPLSim(wopt,A,N,SNR,ComplexValued,SeedValue);
% [eps1,eps2,eps3,mse1,mse2,mse3] = WienerSingle_SPLSim(wopt,A,N,SNR,ComplexValued,SeedValue);
%
% Run a single Wiener-Hopf simulation for [1] with various parameters and a 
% seed value for the noise specified.
% 
% Input parameters
%     wopt             ideal weight column vector
%     A                spatial correlation matrix for input
%     N                number of snapshots
%     SNR              column vector containing SNR range in dB
%     ComplexValued    0 = real, 1 = complex
%     SeedValue        initialisation for random number generator
% Output parameters
%     eps1             system error for case 1 (statistics derived from same data_
%     eps2             system error for case 2 (using exact covariance)
%     eps3             system error for case 3 (R and p from different data)
%     mse1             mean square error for case 1
%     mse2             mean square error for case 2
%     mse3             mean square error for case 3
%
% Reference
% [1] Weiss, Proudler, Altmann: "Accuracy of the Wiener-Hopf solution when 
%     based on sample statistics," submitted to IEEE Signal Processing Letter,
%     September 2025. 

% S. Weiss, UoS, 12/9/25 

%-------------------------------
% parameters
%-------------------------------
randn('seed',SeedValue);
L = length(wopt);
%SeedValue=0;
%M = 5;                     % length of filter
%N = 10;                    % length of sequence
%SNR = [-10 0 10 20 30];    % SNR in dB

eps1 = zeros(length(SNR),1); eps2 = eps1; eps3 = eps1;
mse1 = zeros(length(SNR),1); mse2 = mse1; mse3 = mse1;

%-------------------------------
%   input sequence and noise
%-------------------------------
randn('seed',SeedValue);
% input sequences
X1 = A*(randn(L,N) + 1i*randn(L,N))/sqrt(2);
X2 = A*(randn(L,N) + 1i*randn(L,N))/sqrt(2);
%if ComplexValued==1,
%  X1 = (X1+sqrt(-1)*randn(N,M))/sqrt(2);
%  X2 = (X2+sqrt(-1)*randn(N,M))/sqrt(2);
%end;    
% noise
%sigx2 = wopt'*wopt;
sigma_v = 10.^(-SNR/20);      % vector of standard deviations
v = randn(N,2)*[1; 1i]/sqrt(2);
%if ComplexValued==1,
%  v = (v+sqrt(-1)*randn(N,1))/sqrt(2);
%end;

%-------------------------------
% case 1: two different data sets
%-------------------------------
Rhatinv = inv(X1*X1');
for i = 1:length(SNR),
   phat = X2*(X2'*wopt+v*sigma_v(i));
   w = Rhatinv*phat;
   eps1(i) = norm(w-wopt).^2;
   mse1(i) = norm(A'*(w-wopt)).^2;
end;      

%-------------------------------
% case 2: one data set, 'exploiting' pre-knowledge
%-------------------------------
Rhatinv = inv(A*A')/N;
for i = 1:length(SNR),
   phat = X2*(X2'*wopt+v*sigma_v(i));
   w = Rhatinv*phat;
   eps2(i) = norm(w-wopt).^2;
   mse2(i) = norm(A'*(w-wopt)).^2;
end;      

%-------------------------------
% case 3: one data set
%-------------------------------
Rhatinv = inv(X1*X1');
for i = 1:length(SNR),
   phat = X1*(X1'*wopt+v*sigma_v(i));
   w = Rhatinv*phat;
   eps3(i) = norm(w-wopt).^2;
   mse3(i) = norm(A'*(w-wopt)).^2;
end;      



