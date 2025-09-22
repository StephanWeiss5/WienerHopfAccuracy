# WienerHopfAccuracy
Accuracy of the Wiener-Hopf Solution When Based on Sample Statistics

These files generate the figures for the manuscript
Weiss, Proudler, Altmann: "Accuracy of the Wiener-Hopf Solution When Based on Sample Statistics", submitted to IEEE Signal Processing Letters, September 2025.

Example 1: WienerHopfAccuracy_Example1.m

Figure 2: WienerEnsemble_SPLSim.m (ensemble simulation file), WienerSingle_SPLSim.m  (called by WienerEnsemble_SPLSim.m), WienerEnsemble_SPLResults.txt (results from running WienerEnsemble_SPLSim.m), WienerHopfAccuracy_Figure2.m (extract means and plot Figure 2), EnsembleMeans.mat  (interim results stored here for Figure 3).

Figure 3: WienerEnsemble_SPLHistSim.m  (ensemble simulation file), WienerEnsemble_HistResults_N3e1M10.txt  (raw results generate by simulation file), WienerEnsemble_HistResults_N3e1P30.txt (ditto), WienerEnsemble_HistResults_N3e2M10.txt (ditto), WienerEnsemble_HistResults_N3e2P30.txt (ditto), WienerEnsemble_HistResults_N3e3M10.txt (ditto), WienerEnsemble_HistResults_N3e3P30.txt (ditto), WienerEnsemble_SPLHistograms.m (generate histograms and store
results in the subsequent .mat files), N3e1M10.mat (histogram data saved),N3e1P30.mat (ditto), N3e2M10.mat (ditto), N3e2P30.mat (ditto), N3e3M10.mat (ditto), N3e3P30.mat (ditto),	WienerHopfAccuracy_Figure3.m (plots Figure 3).

Figure 4: WienerHopfAccuracy_Figure4.m (plots Figure 4 from results in WienerEnsemble_SPLResults.txt).
