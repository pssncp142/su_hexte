*************************************
A-resultsB.sav
*************************************

Monte carlo simulations are made considering discrete time interval A in microseconds.
Each result is given as the mean value of 1000 trials and errors are calculated as mean(res)/sqrt(1000).
Total duration is 32 sec for each case.

B modes:
  - 1: deadtime=[2.5:6.5:0.2],rate=100.,xuldrate=100.
  - 2: deadtime=2.5,rate=[60:160:5],xuldrate=100.
  - 3: deadtime=2.5,rate=100.,xuldrate=[60:160:5]

Each file contains:
     - dead   for deadtime (milisec)
     - back_r for rate
     - xuld_r for xuldrate
     - res:
	- res[*,0] mean value of 1000 simulations as a percentage of the initial rate of the light curve.
	- res[*,1] is the error res[*,0]/sqrt(1000)
