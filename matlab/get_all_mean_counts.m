function [gains,qSize,offsetLevel,photons,min_values] = get_all_mean_counts(tiff_files, verbose)
    % Get quantal size for all recordings from one channel
    %
    % function [gains,qSize,offsetLevel,photons,min_values] = get_all_mean_counts(tiff_files, verbose)
    %
    % Inputs
    % tiff_files is the output of standardSourceFileServer.get_tiff_files_for_chan(chanId);
    %
    % e.g. to analyse all of channel 2
    % im_path = '/Users/rob/LOCAL/RoCa_2025_Q1_Photon_QC/NeuroVision__2025_01_22';
    % sss=standardSourceFileServer(im_path);
    % get_all_mean_counts(sss.get_tiff_files_for_chan(2))
    %


    if nargin<2
        verbose=false;
    end




    gains = zeros(1,length(tiff_files));
    qSize = zeros(1,length(tiff_files));
    offsetLevel = zeros(1,length(tiff_files));
    photons = zeros(1,length(tiff_files));
    min_values = zeros(1,length(tiff_files));


    for ii = 1:length(tiff_files)

        t_file = tiff_files{ii};
        tok=regexp(t_file,'_(\d+)V_','tokens');
        gain = str2num(tok{1}{1});


        if gain == 0
            continue
        end

        t_data = single(tiffreadVolume(t_file));
        t_min_val = min(t_data(:));
        t_data = t_data - t_min_val;

        if gain < 500
            minprop=0.25; % does nothing much, TBH
        else
            minprop=[];
        end

        % Second argument is the weighting for the robust fit
        OUT = compute_sensitivity(t_data,0.8,minprop);

        OUT.gain = gain;
        OUT.fname = t_file;

        M = (t_data-OUT.zero_level) / OUT.quantal_size;

        gains(ii) = gain;
        qSize(ii) = OUT.quantal_size;
        offsetLevel(ii) = OUT.zero_level;
        photons(ii) = OUT.photons_per_pixel;
        min_values(ii) = t_min_val;

        if verbose
            fprintf('Quantal size: %0.2f, Gain: %dV, mean photon count: %0.2f\n', ...
            qSize(ii), gains(ii), photons(ii) )
        end

    end
