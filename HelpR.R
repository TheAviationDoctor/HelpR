# ==============================================================================
# 0 Housekeeping
# ==============================================================================

# Load libraries
library(data.table)
library(dplyr)
library(purrr)
library(readr)
library(vroom)

# Clear the environment
rm(list = ls())

# Clear the console
cat("\014")

# Start a script timer
# Place this at the start of your script
start_time <- Sys.time()

# Stop the script timer
# Place this at the end of your script
Sys.time() - start_time

# ==============================================================================
# 1 Download data
# ==============================================================================

# ==============================================================================
# 1.1 Download a compressed archive
# ==============================================================================

# Define a data source
zip <- "data/iris.zip"
url <- "https://github.com/TheAviationDoctor/HelpR/blob/main/data/iris.zip"

# Download data only if not already downloaded
if(!file.exists(zip)) { download.file(url = url, destfile = zip) }

# ==============================================================================
# 1.2 Unzip a compressed archive
# ==============================================================================

# Set a path for the decompressed files
pth <- "data/iris"

# Unzip a compressed archive
suppressWarnings(
  unzip(
    zipfile   = zip,  # Compressed file to unzip
    exdir     = pth,  # Extract to a subfolder
    overwrite = FALSE # Overwrite if already exists
  )
)

# ==============================================================================
# 1.3 Download an uncompressed file
# ==============================================================================

# Define a data source
csv <- "data/iris.csv"
url <- "https://github.com/TheAviationDoctor/HelpR/blob/main/data/iris.csv"

# Download data only if not already downloaded
if(!file.exists(csv)) { download.file(url = url, destfile = csv) }

# ==============================================================================
# 3 Read data
# ==============================================================================

# ==============================================================================
# 3.1 Read and concatenate all files inside a compressed archive
# ==============================================================================

# List files inside the compressed archive
all <- paste(pth, unzip(zipfile = zip, list = TRUE)$Name, sep = "/")

# Base R
df <- do.call(
  rbind,
  lapply(
    X          = as.list(all),
    FUN        = read.table,
    sep        = ",",        # Change this if not comma-separated
    header     = TRUE,       # Change this if first row of data is not a header
    colClasses = c("NULL", rep("numeric", 4L), "factor"), # Change as needed
  )
)

# vroom
df <- lapply(
  X          = as.data.frame(all),
  FUN        = vroom::vroom,
  delim = ",",             # Change as needed
  col_select = c(2:6),     # Change as needed
  col_types  = c("innnnf") # Change as needed
)

# Tidyverse
df <- as.list(all) |>
  purrr::map(
    .f = readr::read_delim,
    delim = ",",             # Change as needed
    col_select = c(2:6),     # Change as needed
    col_types  = c("innnnf") # Change as needed
  ) |>
  dplyr::bind_rows()

# data.table (WIP)
# dt <- do.call(
#   data.table::rbindlist,
#   lapply(
#     X          = as.list(all),
#     FUN        = data.table::fread,
#     sep = ","
#   )
# )

# ==============================================================================
# 3.2 Read and concatenate several specific files inside a compressed archive
# ==============================================================================

# ==============================================================================
# 3.3 Read a single file inside a compressed archive
# ==============================================================================

