classdef standardSourceFileServer < handle

    properties
        im_path
    end % properties

    methods
        function obj = standardSourceFileServer(im_path)
            % standardSourceFileServer(im_path)
            %
            % Inputs
            % im_path - the path to the image data

            if ~exist(im_path,'dir')
                error('The path %s can not be found\n', im_path)
                return
            end

            obj.im_path = im_path;
        end % constructor


        function files = get_tiff_files_for_chan(obj,chanNumber)
            % files = get_tiff_files_for_chan(chanNumber)
            %
            % Inputs
            % chanNumber - scalar (2 to 4) indicating which channel to return data for
            tiff_file_pattern = sprintf('N*_Channel_%d_*.tif', chanNumber);
            d=dir(fullfile(obj.im_path,tiff_file_pattern));

            if length(d)==0
               fpintf('No TIFF files found\n')
            end

            files={d(:).name};
        end

    end % methods

end % classdef
