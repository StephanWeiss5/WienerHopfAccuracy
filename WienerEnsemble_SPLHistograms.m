% WienerEnsemble_SPLHistograms.m
%
% extraxt results from simulations in order to generate histogram data that can
% be plotted into Figure 3 of [1].
%
% [1] Weiss, Proudler, Altmann: "Accuracy of the Wiener-Hopf solution when 
%     based on sample statistics," submitted to IEEE Signal Processing Letter,
%     September 2025. 

% S. Weiss, UoS, 19/9/25 


clear all; close all;

%--------------------------------------------------------------------
% parameters
%--------------------------------------------------------------------
DataFiles = ['WienerEnsemble_HistResults_N3e3M10.txt';
             'WienerEnsemble_HistResults_N3e2M10.txt';
             'WienerEnsemble_HistResults_N3e1M10.txt';
             'WienerEnsemble_HistResults_N3e3P30.txt';
             'WienerEnsemble_HistResults_N3e2P30.txt';
             'WienerEnsemble_HistResults_N3e1P30.txt'];
Ranges = [-2 2 -2 2 -2  2;
          -2 2 -2 2 -2  2;         
           0 3  0 3  0  3;
          -4 0 -4 0 -5 -1;
          -2 2 -3 1 -5 -1;
          -2 2 -2 2 -4  0];    
ResultsFiles = ['N3e3M10.mat'; 'N3e2M10.mat'; 'N3e1M10.mat'; 'N3e3P30.mat'; 'N3e2P30.mat'; 'N3e1P30.mat'];             
for k = 1:6,
   % read in data
   Results = dlmread(DataFiles(k,:));

   % extract results for 3 cases
   Res1 = Results(:,1);
   Res2 = Results(:,2);
   Res3 = Results(:,3);

   % produce histograms
   h1 = histogram(Res1,logspace(Ranges(k,1),Ranges(k,2),130),'Normalization','pdf');
   x1 = h1.BinEdges; y1 = h1.Values;
   h2 = histogram(Res2,logspace(Ranges(k,3),Ranges(k,4),130),'Normalization','pdf');
   x2 = h2.BinEdges; y2 = h2.Values;
   h3 = histogram(Res3,logspace(Ranges(k,5),Ranges(k,6),130),'Normalization','pdf');
   x3 = h3.BinEdges; y3 = h3.Values;

   save(Results(k,:),'x1','y1','x2','y2','x3','y3');
end;   
