# Calibrating a standard source using Python

## Getting started
Read the [Get_Quantal_Vals Jupyter notebook](./Get_Quantal_Vals.ipynb). 
This has a complete description of the procedure along with results. 

The function in `get_calib_data.py` is just to condense some of those analyses into something that can be run at the iPython CLI. 
It assumes that you are the raw data folder.
The easiest way to use it is just to add this code folder to your Python path. 
In iPython do, for example:

```python
sys.path.append('/Users/rob/work/Code/python/standard_source_to_photons/python')
```

Then:
```python
from get_calib_data import get_calib_data
get_calib_data(channel=4,gain=695,count_weight_gamma=0.8)
```

A plot is produced of the structured source fit.
The photons/pixel calculated from the standard source is returned to the CLI. 
