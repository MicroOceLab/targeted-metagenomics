#!/usr/bin/env Rscript

# Packages
options(warn=-1)
library(ggplot2)
library(glue)
set.seed(2025)


# Input
argv <- commandArgs(TRUE)
project_dir <- getwd() 

input_path <- argv[1]
output <- argv[2]
width_cm <- as.numeric(argv[3])
height_cm <- as.numeric(argv[4])


### Main ###
# Read CSV
dataframe_combined <- read.csv(input_path, sep = ",")

# Plot the combined dataframe
plot <- ggplot(dataframe_combined) + geom_bar(
  aes(x = ID, y = Relative.Frequency, fill = Taxonomic.Identity), position = "stack", stat = "identity")

# Export plot
ggsave(glue("{project_dir}/{output}.pdf"),
       plot = plot,
       width = width_cm,
       height = height_cm,
       units = "cm", limitsize = FALSE, dpi = 100, device = "pdf")
