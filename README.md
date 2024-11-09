# AOP-CSC-NPP
This repository contains:
1) The code to derive 3D CSC metrics from small-footprint, discrete-return airborne LiDAR data.
2) The code for implementing the PLS-CV + RFE approach for modeling net primary production (NPP) using CSC metrics. 
3) The preprocessed plot point cloud dataset used for estimating NPP in the study by Siddiqui et al. (2024) and the field-measured NPP of each plot.

# Description

The lidR package (Roussel et al., 2020) was used to compute *Rumple* and generate grids for all other 3D CSC metrics using R version 4.3.1. Python 3.10.11 was used to compute the three variants of each metric from the generated rasters and implement the PLS-CV + RFE approach for identifying top-performing CSC-NPP models. Due to size constraints, the preprocessed plot point clouds are provided in three separate zip folders. Field-measured NPP data are provided in the "plot_NPP" CSV file.

## R code

The `3D_CSC_metrics.R` file contains code for: 
1) Computing the *Rumple* index for each plot and exporting the results to a csv file.
2) Generating rasters for each metric at a user-specified resolution and saving them as `.tif` files in the specified output path. Raster files follow the naming format *plotID_metric_res.tif* where *plotID* corresponds to the plot number of the NEON forest plot, *metric* corresponds to the metric derived from the raster, and *res* corresponds to the grid resolution chosen by the user.
3) Generating voxelized hit grids for computing *Canopy Rugosity* at 1m vertical resolution and a user-specified horizontal resolution. The output is saved as an RData file to the specified output path.

The R packages necessary for running `3D_CSC_metrics.R` are provided in the `Dependencies.txt` file.

## Python code

The Python code for performing the aforementioned tasks is provided in three iPython notebook files:

1) `Compute_metrics.ipynb`:
Contains code for computing the three variants of raster-based metrics via the *Compute_Vars" function, which takes the following arguments:
- `dir_path`: path containing the raster files.
- `metric`: the metric name used in the raster file name, formatted *plotID_metric_res.tif*.
- `res`: the grid resolution of the raster as found in the raster file name, formatted *plotID_metric_res.tif*.

The metric values are returned in a Pandas DataFrame, which can then be saved as a csv file. The notebook also contains the `replace_nans` function for handling NaN values in the raster, occurring where no hits were recorded. The function replaces NaNs with 0 for *Entropy Variability* and *Percent Hits Above Mean Height Variability*. For all other metrics, the function replaces NaNs with the average of all neighboring non-NaN cells. If all neighboring pixels are also empty, the gap is set to the value of the nearest non-NaN pixel.

2) `CanRug_3D.ipynb`:
Contains code for computing the three *Canopy Rugosity* variants. The `get_Std_arr` function takes the RData file containing the grid of voxel hits and returns the grid of *StdBin* values, as computed in the *ForestR* package (Atkins et al., 2018), as a numpy array. NaN values are set to 0. The metric values are returned in a Pandas DataFrame, which can then be saved as a csv file. 

3) `PLS_CV_RFE.ipynb`:
Contains code for running the PLS-CV + RFE approach for modeling NPP using CSC metrics and identifying the top-performing CSC-NPP model, as described by Siddiqui et al. (2024). The `pls_rfe_cv` function takes the following arguments:
- `X_df`: pandas DataFrame containing metric names as columns and metric values in the corresponding rows.
- `X`: numpy array containing metric values.
- `y`: list containing field-measured NPP values.
- `max_comp`: maximum number of components to be used in PLS regression.
- `cv_fold`: cross-validation folds used in PLS-CV.

The function returns the list coefficient of determination, cross-validated $R^{2}$, mean squared error, name and coefficients of selected metrics, and number of PLS components used in the best-performing model.

The Python packages necessary for running all functions are provided in the `Dependencies.txt` file.

## Plot point cloud data

All 49 preprocessed plot point clouds used in the study by Siddiqui et al. (2024) are provided in the three zipped files. The unnormalized point clouds are named in the format *site_plotID* and the DTM-normalized point clouds are named in the format *site_plotID_norm* where *site* corresponds to the four-letter NEON site code and *plotID* corresponds to the plot number of the NEON forest plot.

## NPP data

NPP data for all 49 NEON forest plots used in the study by Siddiqui et al. (2024) are provided in the plot_NPP.csv file.

## References
1. Roussel J, Auty D, Coops NC, Tompalski P, Goodbody TR, Meador AS, Bourdon J, de Boissieu F, Achim A (2020). “lidR: An R package for analysis of Airborne Laser Scanning (ALS) data.” Remote Sensing of Environment, 251, 112061. ISSN 0034-4257, doi:10.1016/j.rse.2020.112061, https://www.sciencedirect.com/science/article/pii/S0034425720304314.
2. Atkins, J.W.; Bohrer, G.; Fahey, R.T.; Hardiman, B.S.; Morin, T.H.; Stovall, A.E.L.; Gough, C.M. Quantifying vegetation and canopy structural complexity from TLS data using the forestr r package. Methods Ecol. Evol. 2018, 9, 2057–2066.
