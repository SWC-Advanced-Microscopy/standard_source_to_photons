import os
from glob import glob
import tifffile as tiff
import numpy as np
import matplotlib.pyplot as plt
from poisson_numcodecs import Poisson, calibrate


def get_calib_data(channel: int = 2, gain: int = 614,
      count_weight_gamma: float = 0.8, min_percent_max: float = 3):

    # Get the data for a defined channel and gain. Calculate the quantal size, show
    # the graph, then convert the standard source data. Can optionally set the
    # count_weight_gamma and min_percent_max params. This function is used alongside
    # the notebook to see how good fits are and probe parameters.
    # Returns standard source photons/pixel to CLI.
    #
    # Inputs
    # channel - integer defining which channel to load data from
    # gain -- integer defining which PMT gain to load data from
    # count_weight_gamma -- robust fit scaling function. 0.8 by default
    #  min_percent_max -- 3 (three percent) by default. Increase to trim weird low values
    #          from the variance/intensity plot
    #
    #
    # Rob Campbell -- SWC 2025


    fname = glob(('*_lens_paper_%dV_*_Channel_%d_*' % (gain, channel)))

    assert len(fname) == 1, \
            ('Expected to find 1 file, found %d' % len(fname))


    im = tiff.imread(fname)

    min_im = np.min(im)

    im = im - min_im # Our data have a large negative offset, which we remove here.


    calibrator = calibrate.SequentialCalibratePhotons(im)
    [photon_sensitivity, dark_signal] = \
        calibrator.get_photon_sensitivity_parameters(count_weight_gamma=count_weight_gamma, min_percent_max=min_percent_max)

    plt.figure(fname[0])
    plt.cla()
    calibrator.plot_poisson_curve()
    M = calibrator.get_photon_flux_movie()
    photons_per_pixel = np.mean(M)
    plt.title(('Channel %d, Gain: %d, %0.1f photons/pixel' % \
        (channel, gain, photons_per_pixel)))



    print('Quantal size: %0.2f, Zero level: %0.1f, mean photon count: %0.2f' % \
          (photon_sensitivity, dark_signal, photons_per_pixel))


    # Convert the standard source to photons
    SS_dir = 'NeuroVision_standard_light_source_White_2024Q2__2025-01-22_10-20'

    SS_fname = \
        glob(os.path.join(SS_dir, f'Neuro*{gain}V_*.tif'))[0]

    ss_im = tiff.imread(fname)

    # Get the channel from the stack
    ss_im = ss_im[channel-1,:]

    # Convert to photons
    ss_im_p = (ss_im - min_im - dark_signal) / photon_sensitivity

    print('Standard source is %0.1f photons/pixel' % np.mean(ss_im_p.flatten()))
