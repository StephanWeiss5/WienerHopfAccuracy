% matlab script: WienerHopfAccuracy_Figure2.m
%
% Generates Figure 2 in [1]. The file extraxt results from simulations recorded
% in the file 'WienerEnsemble_SPLResults.txt'. These in turn wer generated using
% the script file WienerEnsemble_SPLSim.m. Some mean results are saved into the 
% file EnsembleMeans.mat for use in the script filte WienerHopfAccuracy_Figure3.m
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
SNR = [(-30:10:-5), (-2.5:2.5:12.5), (20:10:40)]';
Lsnr = length(SNR);
Ns = [30 300 3000]';
Lns = length(Ns);

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

%--------------------------------------------------------------------
% get simulation results
%--------------------------------------------------------------------
Results = dlmread(DataFile);
MeanResults1 = zeros(Lns,Lsnr);
MeanResults2 = zeros(Lns,Lsnr);
MeanResults3 = zeros(Lns,Lsnr);
for k = 1:Lns,
   Res = Results(find(Results(:,2)==Ns(k)),:);
   for l = 1:Lsnr,
      dummy = mean(Res(find(Res(:,3)==SNR(l)),4:6));
      MeanResults1(k,l) = dummy(1);               % Case 3  X1,X2 
      MeanResults2(k,l) = dummy(2);               % Case 2  X1X1'=R
      MeanResults3(k,l) = dummy(3);               % Case 1  X1=X2
   end;
end;      

%--------------------------------------------------------------------
% theoretical values
%--------------------------------------------------------------------
M = 5;
SNR2 =  (-20:10:40);

% noise-related error term
xi_v1 = (1./(Ns-M))*10.^(-SNR2/10)*trace(inv(R));
xi_v2 = (1./Ns)*10.^(-SNR2/10)*trace(inv(R));
xi_v3 = (Ns.^2)./(Ns-M).^3*10.^(-SNR2/10)*trace(inv(R));

% system-related error term
xi_w2 = (1./Ns)*ones(size(SNR2))*trace(inv(R))*trace(R*wopt*wopt');
xi_w3 = (Ns+M.^2*Ns - M.^3 + M)./( (Ns-M).*( (Ns-M).^2-1 ) )*trace(wopt*wopt') + ...
         2*Ns.^2./( (Ns-M).*( (Ns-M).^2-1 ) ) *trace(inv(R))*  trace(R*wopt*wopt') ;
xi_w1 = zeros(size(xi_w2));

% overall system error
xi_1 = xi_v1 + xi_w1; xi_2 = xi_v2 + xi_w2; xi_3 = xi_v3 + xi_w3;

%--------------------------------------------------------------------
% plot curves
%--------------------------------------------------------------------
clf;
% for legend only
plot(-100,-100,'k--'); hold on;
plot(-100,-100,'k-'); 
plot(-100,-100,'k-.'); 
plot(-100,-100,'ks'); 
plot(-100,-100,'k*'); 
plot(-100,-100,'ko'); 
% theoretical curves
plot(SNR2,10*log10( xi_1(1,:)),'bo','color',[0 0 1],'linewidth',1);
plot(SNR2,10*log10( xi_1(2,:)),'ro','color',[1 0 0],'linewidth',1);
plot(SNR2,10*log10( xi_1(3,:)),'o','color',[0 .5 0],'linewidth',1);
plot(SNR2,10*log10( xi_2(1,:)),'*','color',[0 0 1],'linewidth',1);
plot(SNR2,10*log10( xi_2(2,:)),'*','color',[1 0 0],'linewidth',1);
plot(SNR2,10*log10( xi_2(3,:)),'*','color',[0 .5 0],'linewidth',1);
plot(SNR2,10*log10( xi_3(1,:)),'s','color',[0 0 1],'linewidth',1);
plot(SNR2,10*log10( xi_3(2,:)),'s','color',[1 0 0],'linewidth',1);
plot(SNR2,10*log10( xi_3(3,:)),'s','color',[0 .5 0],'linewidth',1);
axis([-20 40 -50 40]); grid on;
% simulation results, Case 1
plot(SNR,10*log10(MeanResults3(1,:)),'b-.');         
plot(SNR,10*log10(MeanResults3(2,:)),'r-.');
plot(SNR,10*log10(MeanResults3(3,:)),'-.','color',[0 .5 0]);
% simulation results, Case 2
plot(SNR,10*log10(MeanResults2(1,:)),'b-');         % case 2
plot(SNR,10*log10(MeanResults2(2,:)),'r-');
plot(SNR,10*log10(MeanResults2(3,:)),'-','color',[0 .5 0]);
% simulation results, Case 3
plot(SNR,10*log10(MeanResults1(1,:)),'b--');
plot(SNR,10*log10(MeanResults1(2,:)),'r--');
plot(SNR,10*log10(MeanResults1(3,:)),'--','color',[0 .5 0]);
% labels, axes, and legends
plot([-10 -10],[-50 33],'--','color',[1 1 1]*0.6,'linewidth',2);
text(-10,35,'see Fig.~3(a)','interpreter','latex');
plot([30 30],[-50 33],'--','color',[1 1 1]*0.6,'linewidth',2);
text(30,35,'see Fig.~3(b)','interpreter','latex');
hh= text(-18,34.5,'$N=30$','interpreter','latex','color',[0 0 1]);
set(hh, 'Rotation', -22)
hh= text(-18,22,'$N=300$','interpreter','latex','color',[1 0 0]);
set(hh, 'Rotation', -22)
hh= text(-18,11,'$N=3000$','interpreter','latex','color',[0 .5 0]);
set(hh, 'Rotation', -22)
xlabel('SNR $1/\sigma^2_v$ / [dB]','interpreter','latex'); 
ylabel('mean square system error $\xi_i$, $\hat{\xi}_i$ / [dB]','interpreter','latex');
legend({'$i=3$, case (C3), simulation','$i=2$, case (C2), simulation',...
        '$i=1$, case (C1), simulation','$i=3$, case (C3), theory',...
        '$i=2$, case (C2), theory','$i=1$, case (C1), theory'},...
        'interpreter','latex','location','SouthWest');
% size and export        
set(gcf,'OuterPosition',[230 250 570 430]);
set(gca,'LooseInset',get(gca,'TightInset'));  
print -depsc SPL25_2_Fig2.eps

% save mean results at {-10, 30} dB SNR for Figure 3
EnsembleMeans = [MeanResults1(:,[3 12]); 
                 MeanResults2(:,[3 12]);
                 MeanResults3(:,[3 12])];
save EnsembleMeans.mat EnsembleMeans          
