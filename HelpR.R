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
rm(start_time)

# ==============================================================================
# 1 Download data
# ==============================================================================

# ==============================================================================
# 1.1 Download a compressed archive
# ==============================================================================

# Set variables
destfile <- "data/iris.zip"
url      <- "https://github.com/TheAviationDoctor/HelpR/blob/main/data/iris.zip"

# Download data only if not already downloaded
if(!file.exists(destfile)) { download.file(url = url, destfile = destfile) }

# Remove variables
rm(destfile, url)

# ==============================================================================
# 1.2 Unzip a compressed archive
# ==============================================================================

# Set variables
zipfile <- "data/iris.zip"
pth     <- "data/iris"

# Unzip a compressed archive
suppressWarnings(
  unzip(
    zipfile   = zipfile, # Compressed file to unzip
    exdir     = pth,     # Extract to a sub folder
    overwrite = FALSE    # Overwrite if already exists
  )
)

# Remove variables
rm(zipfile, pth)

# ==============================================================================
# 1.3 Download an uncompressed file
# ==============================================================================

# Set variables
destfile <- "data/iris.csv"
url      <- "https://github.com/TheAviationDoctor/HelpR/blob/main/data/iris.csv"

# Download data only if not already downloaded
if(!file.exists(destfile)) { download.file(url = url, destfile = destfile) }

# Remove variables
rm(destfile, url)

# ==============================================================================
# 3 Read data
# ==============================================================================

# ==============================================================================
# 3.1 Read and concatenate all files inside a compressed archive
# ==============================================================================

# Set variables
zipfile <- "data/iris.zip"
pth     <- "data/iris"
sep     <- ","

# List files inside the compressed archive
all <- paste(pth, unzip(zipfile = zipfile, list = TRUE)$Name, sep = "/")

# Base R
df <- do.call(
  rbind,
  lapply(
    X          = as.list(all),
    FUN        = read.table,
    sep        = sep,
    header     = TRUE, # Change this if first row of data is not a header
    colClasses = c("NULL", rep("numeric", 4L), "factor"), # Change as needed
  )
)

# vroom
df <- lapply(
  X          = as.data.frame(all),
  FUN        = vroom::vroom,
  delim      = sep,
  col_select = c(2:6),     # Change as needed
  col_types  = c("innnnf") # Change as needed
)

# Tidyverse
df <- as.list(all) |>
  purrr::map(
    .f         = readr::read_delim,
    delim      = sep,
    col_select = c(2:6),     # Change as needed
    col_types  = c("innnnf") # Change as needed
  ) |>
  dplyr::bind_rows()

# data.table
dt <- data.table::rbindlist(
  lapply(
    X          = as.list(all),
    FUN        = data.table::fread,
    sep        = ",",
    header     = TRUE, # Change this if first row of data is not a header
    select     = c(2:6),                                  # Change as needed
    colClasses = c("NULL", rep("numeric", 4L), "factor"), # Change as needed
  )
)

# Remove variables
rm(all, zipfile, pth, sep, df, dt)

# ==============================================================================
# 3.2 Read and concatenate several specific files inside a compressed archive
# ==============================================================================

# ==============================================================================
# 3.3 Read a single file inside a compressed archive
# ==============================================================================

