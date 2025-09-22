% matlab script: WienerHopfAccuracy_Figure4.m
%
% Generates Figure 4 in [1]. The results are extracted from the file
% WienerEnsemble_SPLResults.txt .
%
% [1] Weiss, Proudler, Altmann: "Accuracy of the Wiener-Hopf solution when 
%     based on sample statistics," submitted to IEEE Signal Processing Letter,
%     September 2025. 

% S. Weiss, UoS, 11/9/25 

clear all; close all;

%--------------------------------------------------------------------
% parameters
%--------------------------------------------------------------------
DataFile = 'WienerEnsemble_SPLResults.txt';
%SNR = (-30:10:40)';
SNR = [-20 -10 -5 -2.5 0 2.5 5 7.5 10 12.5 20 30 40]';
Lsnr = length(SNR);
Ns = [30 300 3000]';
Lns = length(Ns);
%Trials = 5000;

wopt = [0.0602 + 0.1972i;
  -0.0365 - 0.3547i;
   0.4376 + 0.2107i;
   0.4139 + 0.4789i;
   0.4163 + 0.1436i];
A = [ 0.0722 - 0.2938i   0.1469 - 0.1875i  -0.0904 + 0.1025i   0.0332 + 0.0682i   0.1842 - 0.1123i;
  -0.0375 + 0.0757i  -0.1013 - 0.0262i   0.0401 - 0.1111i   0.0498 + 0.0481i  -0.0309 + 0.2126i;
  -0.3187 - 0.0574i  -0.2856 - 0.1483i  -0.0347 + 0.0693i   0.0590 - 0.0027i  -0.1501 - 0.0246i;
   0.1256 - 0.1964i   0.2101 - 0.3097i  -0.1436 + 0.1867i  -0.1105 - 0.0320i   0.0459 - 0.0842i;
   0.2223 + 0.2049i   0.0916 - 0.0409i  -0.2811 - 0.0373i  -0.0666 + 0.0172i   0.5419 + 0.1905i];  
R = A*A';


Results = dlmread(DataFile);

MeanResults1 = zeros(Lns,Lsnr);
MeanResults2 = zeros(Lns,Lsnr);
MeanResults3 = zeros(Lns,Lsnr);
for k = 1:Lns,
   Res = Results(find(Results(:,2)==Ns(k)),:);
   for l = 1:Lsnr,
      dummy = mean(Res(find(Res(:,3)==SNR(l)),7:9));
      MeanResults1(k,l) = dummy(1);               % X1, X2
      MeanResults2(k,l) = dummy(2);               % R, X2
      MeanResults3(k,l) = dummy(3);               % X1=X2
   end;
end;      

% experimental data
clf;
% for legend only
plot(-100,-100,'k--'); hold on;
plot(-100,-100,'k-'); 
plot(-100,-100,'k-.'); 

plot(SNR,10*log10(MeanResults3(1,:)),'b-.');
plot(SNR,10*log10(MeanResults3(2,:)),'r-.');
plot(SNR,10*log10(MeanResults3(3,:)),'-.','color',[0 .5 0]);

% theoretical values
plot(SNR,10*log10(MeanResults2(1,:)),'b-');
plot(SNR,10*log10(MeanResults2(2,:)),'r-');
plot(SNR,10*log10(MeanResults2(3,:)),'-','color',[0 .5 0]);
plot(SNR,10*log10(MeanResults1(1,:)),'b--');
plot(SNR,10*log10(MeanResults1(2,:)),'r--');
plot(SNR,10*log10(MeanResults1(3,:)),'--','color',[0 .5 0]);
axis([-20 40 -70 20]);
grid on;
Rot = -15;
hh= text(-18,15,'$N=30$','interpreter','latex','color',[0 0 1]);
set(hh, 'Rotation', Rot)
hh= text(-18,3.5,'$N=300$','interpreter','latex','color',[1 0 0]);
set(hh, 'Rotation', Rot)
hh= text(-18,-6.5,'$N=3000$','interpreter','latex','color',[0 .5 0]);
set(hh, 'Rotation', Rot)

xlabel('SNR $1/\sigma^2_v$ / [dB]','interpreter','latex'); 
ylabel('mean square error $\hat{\chi}-\sigma_v^2$ / [dB]','interpreter','latex');
legend({'case (C3), simulation','case (C2), simulation','case (C1), simulation'},...
       'interpreter','latex','location','SouthWest');
set(gcf,'OuterPosition',[230 250 570 330]);
set(gca,'LooseInset',get(gca,'TightInset'));  
print -depsc SPL25_2_Fig4.eps


