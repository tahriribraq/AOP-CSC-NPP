# AOP-CSC-NPP
This repository contains:
1) The code to derive 3D CSC metrics from small-footprint, discrete-return airborne LiDAR data.
2) The code for implementing the PLS-CV + RFE approach for modeling net primary production (NPP) using CSC metrics. 
3) The preprocessed plot point cloud dataset used for estimating NPP in the study by Siddiqui et al. (2024) and the field-measured NPP of each plot.

# Description

The lidR package (Roussel et al., 2020) was used to compute Rumple and generate grids for all other 3D CSC metrics using R version 4.3.1. Python 3.10.11 was used to compute three variants for each metric from the generated rasters and implement the PLS-CV + RFE approach for identifying top-performing CSC-NPP models. Due to size constraints, the preprocessed plot point clouds are provided in three separate folders, and field-measured NPP data is provided in the "plot_NPP" CSV file.
