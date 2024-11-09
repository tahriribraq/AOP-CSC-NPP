# AOP-CSC-NPP
This repository contains:
1) The code to derive 3D CSC metrics from small-footprint, discrete-return airborne LiDAR data.
2) The code for implementing the PLS-CV + RFE approach for modeling net primary production (NPP) using CSC metrics. 
3) The preprocessed plot point cloud dataset used for estimating NPP in the study by Siddiqui et al. (2024) and the field-measured NPP of each plot.

# Description

The lidR package (Roussel et al., 2020) was used to compute Rumple and generate grids for all other 3D CSC metrics using R version 4.3.1. Python 3.10.11 was used to compute the three variants of each metric from the generated rasters and implement the PLS-CV + RFE approach for identifying top-performing CSC-NPP models. Due to size constraints, the preprocessed plot point clouds are provided in three separate folders, and field-measured NPP data is provided in the "plot_NPP" CSV file.

## R code

The $3D_CSC_metrics.R$ file contains the code for: 
1) Computing the Rumple index of each plot and writing it to a csv file.
2) Generating rasters for each metric at the user-specified resolution and writing the raster to the output path as a tif file with the naming format "plotID_metric_res" where the plot number of the forest plot is given by "plotID, the metric derived from the raster is given by "metric", and the grid resolution is given by "res".
3) Generating voxelized hit grids for computing Canopy Rugosity at 1m vertical resolution and user-specified horizontal resolution, and writing the output to the specified path as an RData file.

The R packages necessary for running $3D_CSC_metrics.R$ are provided in the R_dependencies.txt file.

## Python code

The python code is provided as iPython notebook
