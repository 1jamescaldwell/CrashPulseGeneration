# CrashPulseGeneration
Generates an acceleration pulse that can be used on a crash sled test rig

In Aug. 2022, my lab at UVA needed to generate crash pulses (acceleration profiles) of real world crashes for use on a crash test sled in our lab. We needed to generate 10-15 pulses that would then be used at various scale factors: 100%, 50%, 40%, etc. 

The code I wrote takes in Insurance Institute for Highway Safety crash test data, generates the various crash pulse profiles from that data, visualizes the pulses, then saves each pulse in a .csv in a format that can input into our SESA sled system.

Process:
1. Get the crash pulse data into matlab. I've uploaded AccordFront.m as an example. AccordFront means a Honda Accord in a full frontal crash.
2. Run Main.m, which generates the plots and exports the .csv  <b>
  a. cfc.m is a filter function that is called by Main.m. Applies a cfc60 filter to the raw data for smoothing.
