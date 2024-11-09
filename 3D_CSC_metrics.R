# Load packages
library(lidR)
library(raster)


# Compute Rumple index

las_dir <- "input_dir" # Replace input_dir with path to las files
# retrieve DTM-normalized point clouds
las_files <- list.files(las_dir, pattern = "norm\\.las$", full.names = TRUE) 
rumples <- matrix(nrow = 0, ncol = 2) # matrix for storing rumple values of each plot

for (las_file in las_files) {
  las <- readLAS(files = las_file)
  las_filename <- tools::file_path_sans_ext(basename(las_file))
  plotnum <- gsub("_norm", "", las_filename)
  ri_res <- 10 # Specify grid resolution (m)
  plot_res <- 40  # Initial value of plot resolution

  repeat {
    surf_las <- filter_surfacepoints(las, ri_res) # filter surface points at specified resolution
    # Run the rumple_index function 
    ri <- pixel_metrics(las = surf_las, ~rumple_index(X,Y,Z), res = plot_res)
    # Check dimensions of ri
    size <- nrow(ri)*ncol(ri)
    # If dimensions are equal to 1, break the loop
    if (size == 1) {
      rumples <- rbind(rumples, c(plotnum, ri[1][1]))
      break
    } else {
      # Increment n by 5
      plot_res <- plot_res + 5
    }
  }
}

# Write output to csv
write.csv(rumples, file = "output_dir") # Path to output directory

# Specify input directory containing las files and output path for rasters

out_dir <- "output_dir" # replace output_dir with path to output directory
las_dir <- "input_dir" # replace input_dir with path to las files
las_files <- list.files(path = las_dir, pattern = "\\.las$", full.names = TRUE)
las_files <- las_files[!grepl("norm\\.las$", las_files)]

# Generate grids of highest hits for computing Top Rugosity

n <- 1 # specify grid resolution (m)

for (file in las_files) {
  las <- readLAS(files = file)
  file_name <- tools::file_path_sans_ext(basename(file))
  metrics <- pixel_metrics(las, .stdmetrics, n) # calculate metrics at n m
  hmax <- metrics['zmax'] 
  out_path <- file.path(out_dir, paste0(file_name, "_hmax_", n, "m.tif"))
  writeRaster(hmax, filename = out_path, overwrite=TRUE)
}

# Generate grids of mean heights for computing Mean Rugosity

n <- 1 # specify grid resolution (m)

for (file in las_files) {
  las <- readLAS(files = file)
  hmean <- pixel_metrics(las, ~mean(Z), n) # calculate mean at n m
  file_name <- tools::file_path_sans_ext(basename(file))
  out_path <- file.path(out_dir, paste0(file_name, "_hmean_", n, "m.tif"))
  writeRaster(hmean, filename = out_path, overwrite=TRUE)
}

# Generate grids of 25th and 75th height percentiles for computing Lower and Upper Rugosity

for (file in las_files) {
  las <- readLAS(files = file)
  file_name <- tools::file_path_sans_ext(basename(file))
  metrics <- pixel_metrics(las, .stdmetrics, n) # calculate metrics at n m
  hp75 <- metrics['zq75'] # Upper rugosity
  out_path <- file.path(out_dir, paste0(file_name, "_hp75_", n, "m.tif"))
  writeRaster(hp75, filename = out_path, overwrite=TRUE)
  hp25 <- metrics['zq25'] # Lower rugosity
  out_path <- file.path(out_dir, paste0(file_name, "_hp25_", n, "m.tif"))
  writeRaster(hp25, filename = out_path, overwrite=TRUE)
}

# Generate grids of height entropy, standard deviation of heights, and percentage of hits above mean for computing Entropy Variability, Canopy Heterogeneity, and Percent Hits Above Mean Height Variability

for (file in las_files) {
  # print(file)
  las <- readLAS(files = file)
  las <- filter_poi(las, Classification != 2L) # filter out ground points
  file_name <- tools::file_path_sans_ext(basename(file))
  metrics <- pixel_metrics(las, .stdmetrics, n) # calculate metrics at n m

  z_ent <- metrics['zentropy'] # Entropy of height distribution
  out_path <- file.path(out_dir, paste0(file_name, "_zent_", n, "m.tif"))
  writeRaster(z_ent, filename = out_path, overwrite=TRUE)

  pz_abovem <- metrics['pzabovezmean'] # Percentage of hits above mean
  out_path <- file.path(out_dir, paste0(file_name, "_pzabovem_", n, "m.tif"))
  writeRaster(pz_abovem, filename = out_path, overwrite=TRUE)

  las <- readLAS(files = file) # include ground points for zsd
  metrics <- pixel_metrics(las, .stdmetrics, n) # calculate metrics at n m
  z_sd <- metrics['zsd'] # Std of heights
  out_path <- file.path(out_dir, paste0(file_name, "_zsd_", n, "m.tif"))
  writeRaster(z_sd, filename = out_path, overwrite=TRUE)
}

# Generate voxel hit grids for computing Canopy Rugosity 

n <- 10 # specify voxel x and y dimension

for (file in las_files) {
  las <- readLAS(files = file)
  las <- filter_poi(las, Classification != 2L) # filter out ground points 
  file_name <- tools::file_path_sans_ext(basename(file))
  vox_hits <- voxel_metrics(las, ~list(N = length(Z)), c(n,1)) # number of hits in nxnx1 m voxels
  out_path <- file.path(out_dir, paste0(file_name, "_", m, ".RData"))
  save(vox_hits, file = out_path)
}
