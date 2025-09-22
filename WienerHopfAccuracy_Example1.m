% matlab script: WienerHopfAccuracy_Example1.m
%
% Generates the numerical results for Example 1 in [1].
%
% [1] Weiss, Proudler, Altmann: "Accuracy of the Wiener-Hopf solution when 
%     based on sample statistics," submitted to IEEE Signal Processing Letter,
%     September 2025. 

% S. Weiss, UoS, 11/9/25 

disp('*** for observation noise power 0.001 ***');
M = 3; N = 100;
omega = [1 .5 .25]';
randn('seed',3);
X = (randn(M,N)+randn(M,N)*1i)/sqrt(2);
v = (randn(1,N)+randn(1,N)*1i)/sqrt(2);
d = omega'*X + sqrt(0.001)*v;
Rhat = X*X'/N;
phat = X*d'/N;
disp(sprintf('covariance matrix estimation error:       %g', norm(Rhat - eye(3),'fro')^2));
disp(sprintf('crosscorrelation vector estimation error: %g', norm(phat - omega)^2));
w_o_hat = inv(Rhat)*phat;
disp(sprintf('system error:                             %g', norm(w_o_hat - omega)^2))

disp('*** without observation noise ***');
M = 3; N = 100;
omega = [1 .5 .25]';
randn('seed',3);
X = (randn(M,N)+randn(M,N)*1i)/sqrt(2);
v = (randn(1,N)+randn(1,N)*1i)/sqrt(2);
d = omega'*X;
Rhat = X*X'/N;
phat = X*d'/N;
disp(sprintf('covariance matrix estimation error:       %g', norm(Rhat - eye(3),'fro')^2));
disp(sprintf('crosscorrelation vector estimation error: %g', norm(phat - omega)^2));
w_o_hat = inv(Rhat)*phat;
disp(sprintf('system error:                             %g', norm(w_o_hat - omega)^2))

