# Converting the standard source to photons using MATLAB

The code in this folder uses MATLAB to generate figures equivalent to those in the `Get_Quantal_Vals` Jupyter notebook. 
You can compare the two sets of figures to convince yourself the results are the same in both programming languages. 
The explanations behind the figures can be found in the Jupyter notebook. 
 
## Basic Example
See [example_standard_target_calibration.md](example_standard_target_calibration.md) for a basic example on how to convert an image stack to photons. 

## Calibrating the standard source
The script [convert_standard_source.m](convert_standard_source.m) runs through all structured target images and process them all. 
It uses the resulting coefficients to convert the standard source data to photons per pixel.
You can see an example presented at [convert_standard_source.md](convert_standard_source.md).



### Getting the raw data
If you wish to re-run the analyses or play with the data, the required TIFF files can be found on Gin at [raacampbell/NV_photon_calibration_250122](https://gin.g-node.org/raacampbell/NV_photon_calibration_250122/).
