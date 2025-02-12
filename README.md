# What is this?
The goal of this repo is to provide the groundwork for generating a protocol to convert raw fluorescence values from a self-luminous standard light source into photons. 
The light source can imaged by a multi-photon microscope (possibly also a confocal) and results converted to photons per pixel. 
This will allow direct comparison of the collection paths of different microscopes. 

## How does it work? 
The idea behind this approach was described by Dimitri Yatsenko in the preprint "[Standardised Measurements for Monitoring and Comparing Multiphoton Microscope Systems](https://www.biorxiv.org/content/10.1101/2024.01.23.576417v1)" (in press at Nature Protocols). 
Briefly, photons are discete particles and so photon detection is governed by the Poisson distribution.
The variance of a Poisson signal is equal to the mean. 
If we image a structured static target over time, each pixel will have a constant mean but the exact recorded value will vary from frame to frame. 
The variance of this variability is dependant on the mean (higher means will have higher variances). 
Plotting mean against variance should yield a straight line with a static target. 
A multi-photon microscope detects signals with an amplified detector called a photo-multiplier tube. 
The slope of the variance/mean plot increases with gain and, critically, **is equal to the number of raw data values per photon**.
Consequently a plot of photons/pixel as a function of gain should be straight (flat) line with a slope of zero. Therefore, assuming negligable post-amplifier noise, increasing gain does **not** mean more photons are detected. It simply increases the number of raw data values per photon. 

We can use the above to obtained standardised measurements that allow comparison of different microscopes. 

### Evaluating the whole microscope system
1. Image a standard target which bleaches slowly at a known laser power.
2. Convert to photons.
3. Repeat on other microscopes to compare

### Compare collection paths between systems
1. "Image" a standard self luminous target, such a [fluorescent tritium vial](https://www.google.com/search?q=flourecent+tritium+vial).
2. Calbrate the resulting data, converting them to photons. The details for this are coverered in this repo.
3. Repeat this on different microscopes and so obtain standardised and quantifiable comparisons of different collection paths.

This will show up differences in detector QE, detector age and health, and also potential differences in filter specs.

## Data compression
It turns out that functional mutliphoton data never generate more than about 10 photons pixel and usually much less.
Thus, despite being acquired at 12 or 16 bit, the true bit depth is more like 4 and many pixels will be zeros. 
In principle raw data can be converted to photons and, even if just stored as LZW compressed 8 bit tiffs, will yield a data saving of around 10x.


# What is here
Here you will find some Python code and notebooks that show how to convert data from a tritium source into photons. 
You will also find a MATLAB implementation of this pipeline. 
Many multi-photon microscopes run the MATLAB-based [ScanImage](https://www.mbfbioscience.com/products/scanimage/) software and it is helpful to be able to make the conversions at the rig within MATLAB without requring a Python install.
You may look through the MATLAB and Python notebooks to examine the results. 
If you wish to re-run the notebooks or play with the data, the required TIFF files can be found on Gin at [raacampbell/NV_photon_calibration_250122/](https://gin.g-node.org/raacampbell/NV_photon_calibration_250122/).

## Citations
This work is based on the [original minimal Python code](https://github.com/datajoint/anscombe-numcodecs) from Dimitri Yatsenko. 
The approach used here calculates means and variances using only sequential frames. 
This significantly reduces the requirement for a static target. 
Consquently the analyses can even be run on _in vivo_ functional imaging timeseries. 

[Allen poisson-numcodecs](https://github.com/AllenNeuralDynamics/poisson-numcodecs) is a repo that contains the same photon calibration approach plus a lot of extra visualisation code. 
[NIU poisson-numcodecs](https://github.com/neuroinformatics-unit/poisson-numcodecs) has a few more examples in it and is a fork of the Allen version. 
[raacampbell poisson-numcodecs](https://github.com/raacampbell/poisson-numcodecs) is fork of NIU with a minor input argument tweak on the core calibration function. 

Yes, I know, all this needs sanitising. That's what we are hoping to catalyse here. 
