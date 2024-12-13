# CT-based Plantar Pressure Analysis
Code used to evaluate plantar pressure data based on segmented CT scans. Pulished as *A method for automated masking and plantar pressure analysis using segmented computed tomography scans* in [*Gait & Posture*, 2024](https://doi.org/10.1016/j.gaitpost.2024.04.015)


## Why did we make this?
Plantar pressure is a commonly reported measurement of foot function. Plantar pressure has been associated with a variety of conditions affecting foot health including diabetes, foot bone anomalies, and heel pain. We created this code as part of a multimodal analysis of foot function changes assocaited with diabetes. However, our lab also performs a number of biplanar flouroscopy, gait, and gait simulation studies that require CT scans, meaning that we often have segmented scans for our studies. In an effort to improve the flexibility of plantar pressure summary variables and save processing time, we created this automated plantar pressure processing method with pressure regions derived from bony anatomy. For additional context, please see our published paper in [*Gait & Posture*.](https://doi.org/10.1016/j.gaitpost.2024.04.015)

## Features included
* Peak pressure 
* Pressure-Time Integral (PTI)
* Force-Time Integral (FTI)
* PTI from FTI (PTI_F)
* Pressure Gradient (PPG) *dynamic only*
* Pressure Gradient Angle (PGA) *dynamic only*


## Requirements 
* MATLAB
* Segmented CT scan saved as .bmp images with individual bone colors as found in the code
  * Required bones are: Hallux, phallanges, metatarsals, all three cuneiforms, cuboid, navicular, and calcaneus
* Plantar pressure output text file

## Running the Code
### About the code 
This program takes a volumetric bony scan of the foot with pre-segmented bone overlays and uses the bone geometry to compute a 10-region plantar pressure mask (Hallux, toes, 5 metatarsal heads, lateral and medial midfoot, hindfoot). This mask is then applied to any number of user-input plantar pressure files to compute common static and dynamic plantar pressure metrics as well as several less common metrics. These metrics are then saved as .mat files. 

### Operating the program
The main file generates the plantar mask, calculates the summary variables, and saves the summary variables for each mask region into both matlab and excel readable files. Upon running the program, a window will pop up, asking you to select your CT image files, then your static and dynamic plantar pressure files. The program will then run automatically, generating a few plots along the way to check that the program is running as expected (e.g. the mask is calculated corrrectly). **This program requires substantial RAM as it holds the full CT scan in memory.**

The main file is supported by functions in the support_files folder. The support_files folder also includes programs to aggregate the outputs of the main file for summarizing multiple subjects' data. 

### Troubleshooting
There are two main areas where the code may fail: 
* The hard-coded bone colors are incorrect, leading to incorrect masks and bounding boxes 
* The mask offsets are incorrect 

Some other things to check: 
* Make sure you selected static and dynamic plantar pressure files correctly. There are some dynamic metrics that cannot be calculated on a static file.
* Make sure you selected the correct foot. The transforms are different for right and left feet.  


## Caveats 
This code was developed and tested on single right foot pantar pressure acquired using the novel emed plantar pressure system. This code was developed and tested using MATLAB 2018b and Windows 7. Compatibility with other software and OS versions is left to the user. This code is not actively maintained and is offered as-is to other researchers. This code is under a GPL-3.0 license. You are free to use and adapt this code, but it must remain in public domain. If you use this code in your work, please cite [L. Brady et al, *Gait & Posture*, 2024](https://doi.org/10.1016/j.gaitpost.2024.04.015)
