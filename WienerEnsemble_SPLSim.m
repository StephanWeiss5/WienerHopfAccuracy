% WienerEnsemble_SPLSim.m

%-------------------------------
% parameters
%-------------------------------
ComplexValued=1;           % 0=real, 1=complex valued
M = 5;                     % length of filter
Ns = [30 300 3000];     % length of sequence
%Ns = [30];     % length of sequence
%SNR = (-30:10:40)';    % SNR in dB
SNR = [-2.5 2.5 7.5 12.5]';
Trials = 10;           % overall number of trials will the Trials*Subtrials
Subtrials = 5000;      % simulations over which subresults are averaged
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
   
%-------------------------------
% parameters
%-------------------------------
for t = 1:Trials,
  disp(sprintf('trial %d of %d',[t Trials])); 
  for k = 1:length(Ns),
     N = Ns(k); 
     E1 = zeros(length(SNR),1); E2 = E1; E3 = E1; M1 = E1; M2 = E1; M3 = E1;
     for t2 = 1: Subtrials,
        SeedValue = Subtrials*(t-1)+t2;
        [Es1,Es2,Es3,Ms1,Ms2,Ms3] = WienerSingle_SPLSim(wopt,A,N,SNR,ComplexValued,SeedValue);
        E1 = E1*(t2-1)/t2 + Es1/t2;
        E2 = E2*(t2-1)/t2 + Es2/t2;
        E3 = E3*(t2-1)/t2 + Es3/t2;
        M1 = M1*(t2-1)/t2 + Ms1/t2;
        M2 = M2*(t2-1)/t2 + Ms2/t2;
        M3 = M3*(t2-1)/t2 + Ms3/t2;
     end;   
     if exist('WienerEnsemble_SPLResults.txt','file') ~= 2,        
%       disp('new results file created');
        dlmwrite('WienerEnsemble_SPLResults.txt',[SeedValue N SNR(1) E1(1) E2(1) E3(1) M1(1) M2(1) M3(1)]);
        for k2 = 2:length(E1),
           dlmwrite('WienerEnsemble_SPLResults.txt',[SeedValue N SNR(k2) E1(k2) E2(k2) E3(k2) M1(k2) M2(k2) M3(k2)],'-append');
        end;   
     else  
%        disp('results appended');
        for k2 = 1:length(E1),
           dlmwrite('WienerEnsemble_SPLResults.txt',[SeedValue N SNR(k2) E1(k2) E2(k2) E3(k2) M1(k2) M2(k2) M3(k2)],'-append');
        end;  
     end;    
  end;
end;
     

