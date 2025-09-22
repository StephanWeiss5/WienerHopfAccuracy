% Matlab script file: WienerEnsemble_SPLHistSim.m

% Measure the histogram of the system errors for some select points along the
% results curves in Figure 3 of the draft for [1] in order to compare to the 
% theoretical values.
%
% [1] Weiss, Proudler, Altmann: "Accuracy of the Wiener-Hopf solution when 
%     based on sample statistics," submitted to IEEE Signal Processing Letter,
%     September 2025. 

% S. Weiss, UoS, 12/9/2025

%-------------------------------
% parameters
%-------------------------------
ComplexValued=1;           % 0=real, 1=complex valued
M = 5;                     % length of filter
Trials = 10;
Ns = [30 300 3000];     % length of sequence
SNRs = [-10 30]';    % SNR in dB
FileNames=['WienerEnsemble_HistResults_N3e1M10.txt';
           'WienerEnsemble_HistResults_N3e2M10.txt';
           'WienerEnsemble_HistResults_N3e3M10.txt';
           'WienerEnsemble_HistResults_N3e1P30.txt';
           'WienerEnsemble_HistResults_N3e2P30.txt';
           'WienerEnsemble_HistResults_N3e3P30.txt'];
Trials = 1000;
Subtrials = 1000;
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
parfor t = 1:Trials,
  if mod(t,10)==0, disp(sprintf('trial %d of %d',[t Trials])); end;
  for n = 1:length(Ns),
     N = Ns(n);
     for s=1:length(SNRs),
        SNR = SNRs(s);
        Dummy = zeros(Subtrials,3); 
        for t2 = 1: Subtrials,
           SeedValue = Subtrials*(t-1)+t2;
           [Dummy(t2,1),Dummy(t2,2),Dummy(t2,3),~,~,~] = WienerSingle_SPLSim(wopt,A,N,SNR,ComplexValued,SeedValue);
        end;   
        if exist(FileNames((n-1)*s+1,:),'file') ~= 2,        
           dlmwrite(FileNames((n-1)*s+1,:),Dummy);
        else  
           dlmwrite(FileNames((n-1)*s+1,:),Dummy,'-append');
        end;
     end;        
   end;  
end;
     
% the created data can be evaluated with histogram(), and the results saved into the 
