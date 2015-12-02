# MATLAB App Functions
1-dimensional MATLAB wave simulator

[Stand-alone App]
* Wave_Simulator.mlappinstall --- MATLAB app installer

[Development Materials]
* waveGUI.m -------------------- GUI code specifying callbacks (WARNING: Has not been commented rigorously!)
* waveGUI.fig ------------------- GUI layout
* wave.m ------------------------- computational engine for discretizing wave equation
* wavesplashbox.png --------- splash screen
* Wave_Simulator_24.png --- icon

MATLAB GUI's are composed of two files: a `.m' file specifying callback functions and a '.fig' file consisting of the user-interface layout and elements. To test a MATLAB GUI without installing the app, save the Development Materials files into a folder that MATLAB can access, then type 'guide' into the MATLAB command window. This will open a window prompting for the GUI location. Once the desired GUI is selected, it can be run by clicking the green play button on the GUIDE interface.
