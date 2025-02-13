# What is this?
The goal of this repo is to provide the groundwork for generating a protocol to convert raw fluorescence values from a self-luminous standard light source into photons. 
The light source can imaged by a microscope and results converted to photons per pixel.
For our purposes we will be using a multi-photon microscope, but this is not critical. 
Conversion of the detected standard source signal into photons allows direct comparison of the collection paths of different microscopes. 

## TLWR
* See [the main Jupyter notebook](./python/Get_Quantal_Vals.ipynb) for how to perform the calibration in details.
* See [matlab/README.md] for a demo that this also works in MATLAB.

## How does it work?
The idea behind this approach was described by Dimitri Yatsenko in the preprint "[Standardised Measurements for Monitoring and Comparing Multiphoton Microscope Systems](https://www.biorxiv.org/content/10.1101/2024.01.23.576417v1)" (in press at Nature Protocols). 
Briefly, photons are discrete particles and so photon detection is governed by Poisson statistics.
The variance of a Poisson signal is equal to the mean. 
If we image a structured static target over time, each pixel will have a constant mean but the exact recorded value will fluctuate from frame to frame. 
The variance of these fluctuations is dependent on the mean, and in a pure Poisson process the mean will be equal to the variance. 
Plotting mean against variance therefore yields a straight line for a static target. 

A multi-photon microscope detects signals with an amplified detector called a photo-multiplier tube. 
The slope of the variance/mean plot increases with gain and, critically, **is equal to the number of raw data values per photon**.
Increasing the gain will increase the slope of the variance/mean plot.
**The original data can be converted back into photons by subtracting any offset and dividing the data by this slope.**
The resulting photon converted data will have a variance/mean plot with a slope of 1. 
If the process was successful, we would expect the number of photons per pixel to be independent of PMT gain.

After a certain threshold and assuming negligible post-amplifier noise, increasing gain does **not** mean more photons are detected. 
In most practical scenarios, increasing amplifier gain simply creates increases the number of raw data values per photon.
Higher PMT gains drive an increase in dark counts which negatively affect the SNR. 

# Microscope comparisons
We can use photon-calibrated measurements to compare different but similar microscopes. 


## Compare collection paths between systems
1. "Image" a standard self luminous target, such a [fluorescent tritium vial](https://www.google.com/search?q=flourecent+tritium+vial).
2. Calibrate the resulting data, converting them to photons. 
3. Repeat this on different microscopes and so obtain standardised and quantifiable comparisons of different collection paths.

This will reveal differences in the collection paths and will be a combination of detector QE, detector age and health, and also potential differences in filter specs. 



## Evaluating the whole microscope system
1. Image a stable standard target at a known laser power. 
2. Convert to photons.
3. Repeat on other microscopes to compare.

Differences will in results will be all those listed for the standard source plus the excitation path.
e.g. things like pulse width, laser power, and PSF.

### Conducting these measurements
More details are presented within this repo on how to conduct these measurements. 


# Data compression
It turns out that functional multi-photon data never generate more than about 10 photons pixel and usually fewer.
Thus, despite being acquired at 12 or 16 bit, the true bit depth is more like 4 and many pixels will be zeros. 
In principle raw data can be converted to photons and, even if just stored as LZW compressed 8 bit tiffs, will yield a data saving of around 10x.


# What is here
Here you will find some Python code and notebooks that show how to convert data from a tritium source into photons. 
You will also find a MATLAB implementation of this pipeline. 
Many multi-photon microscopes run the MATLAB-based [ScanImage](https://www.mbfbioscience.com/products/scanimage/) software and it is helpful to be able to make the conversions at the rig within MATLAB without requring a Python install.
You may look through the MATLAB and Python notebooks to examine the results. 
If you wish to re-run the notebooks or play with the data, the required TIFF files can be found on Gin at [raacampbell/NV_photon_calibration_250122](https://gin.g-node.org/raacampbell/NV_photon_calibration_250122/).

## Where to start
The Jupyter notebook `python/Get_Quantal_Vals.ipynb` contains a description of the data and explains the steps for converting the standard source image from raw values to photons. 

Unlike Jupyter notebooks, MATLAB notebooks are binary so one is not included in the repo. 
The `matlab` folder contains a set of functions and a README for running them. 



## Citations
This work is based on the [original minimal Python code](https://github.com/datajoint/anscombe-numcodecs) from Dimitri Yatsenko. 
The approach used here calculates means and variances using only sequential frames. 
This significantly reduces the requirement for a static target. 
Consquently the analyses can even be run on _in vivo_ functional imaging timeseries. 

[Allen poisson-numcodecs](https://github.com/AllenNeuralDynamics/poisson-numcodecs) is a repo that contains the same photon calibration approach plus a lot of extra visualisation code. 
[NIU poisson-numcodecs](https://github.com/neuroinformatics-unit/poisson-numcodecs) has a few more examples in it and is a fork of the Allen version. 
[raacampbell poisson-numcodecs](https://github.com/raacampbell/poisson-numcodecs) is fork of NIU with a minor input argument tweak on the core calibration function. 

Yes, I know, all this needs sanitising. That's what we are hoping to catalyse here. 
