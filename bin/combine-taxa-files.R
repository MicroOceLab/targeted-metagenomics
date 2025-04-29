#!/usr/bin/env Rscript

# Packages
options(warn=-1)
library(glue)


# Input
argv <- commandArgs(TRUE)
project_dir <- getwd() 

file <- argv[1]
taxa_level <- argv[2]
taxa_limit <- as.numeric(argv[3])

print(project_dir)
print(file)
print(taxa_level)
print(taxa_limit)

paths <- list.files(glue("{project_dir}/{file}"), pattern = glue("*{taxa_level}.csv"), full.names = TRUE)
print(glue("{project_dir}/{file}"))
print(paths)


# Functions
fix_format <- function(matrix) {
  # Transpose rows and columns
  matrix <- t(matrix)
  
  # Fix headers
  id <- matrix[1, 1:2][2]
  length <- nrow(matrix)
  matrix <- matrix[2:length,1:2]
  colnames(matrix) <- c("Taxonomic.Identity", "Relative.Frequency")
  
  # Add ID to all rows
  dataframe <- as.data.frame(matrix)
  dataframe["ID"] <- id
  
  # Convert observations to relative frequency
  dataframe["Relative.Frequency"] <- as.numeric(unlist(dataframe["Relative.Frequency"]))
  total_frequency <- sum(dataframe["Relative.Frequency"])
  dataframe["Relative.Frequency"] <- lapply(dataframe["Relative.Frequency"], function(x) x / total_frequency)
  
  # Sort taxa by relative frequency
  dataframe <- dataframe[order(dataframe$"Relative.Frequency", decreasing = TRUE), ]
  
  return(dataframe)
}

trim_taxa <- function(dataframe) {
  # Separate lesser observed taxa based on set taxa limit 
  length <- nrow(dataframe)
  dataframe_included <- dataframe[1:taxa_limit, 1:3]
  dataframe_excluded <- dataframe[(taxa_limit + 1):length, 1:3]
  
  # Combine separated taxa into 'others'
  others <- data.frame()
  others[1, 1:3] <- head(dataframe_excluded, n = 1)
  others[1, 2] <- (1 - sum(dataframe_included$"Relative.Frequency"))
  others[1, 1] <- "Others"
  
  # Merge included taxa with others
  dataframe <- merge(dataframe_included, others, all = TRUE)
  
  return(dataframe)
}


### Main ###
# Prepare formatted dataframes for each CSV file
csv_files <- lapply(paths, read.csv, header = FALSE)
dataframes <- lapply(csv_files, fix_format)
dataframes <- lapply(dataframes, trim_taxa)

# Merge all dataframes into one 
dataframe_combined <- dataframes[1]
for (i in 2:length(dataframes)) {
  dataframe_combined <- merge(dataframe_combined, dataframes[i], all = TRUE)
}

# Sort rows based on ID and decreasing Relative Frequency 
dataframe_combined <- dataframe_combined[order(dataframe_combined$"Relative.Frequency", decreasing = TRUE), ]
dataframe_combined <- dataframe_combined[order(dataframe_combined$"ID"), ]

# Export combined dataframe as CSV
write.csv(dataframe_combined, glue("{project_dir}/{file}.csv"))
