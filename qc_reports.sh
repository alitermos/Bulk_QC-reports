#!/bin/bash

##########################################################################################
# Usage Instructions:
#
# To process specific .fastq files within the directory:
# 	./qc_reports.sh <filename-1>.fastq <filename-2>.fastq ... <filename-N>.fastq
#
# To process all .fastq files in the current directory:
# 	./qc_reports.sh *.fastq
#
# * Description:
# 	This script streamlines the processing of .fastq files in bulk by utilizing the 'fastqc' command,
# 	organizing the output into a specifically designated folder named 'qc_reports_pretrim'. This
# 	facilitates efficient sequence data management and analysis for quality control processes.
#
# * Prerequisites:
# 	Ensure the 'fastqc' module/program is preloaded on your HPC or computing environment before
# 	initiating this script to avoid execution errors.
#
# Author: Ali A. Termos
# Date: Sep 19, 2023
# Version: 1.0
##########################################################################################

# get all arguments from user as <filename>.fastq each
files=($@)

# define output directory
dfiles="./"

# define file extension
extension="fastq"

# initialize an empty array to store files to be processed
files_process=()

# check if files meet specified conditions in directory before processing 
# and process files that do meet specified conditions
for file in "${files[@]}"; do
 # check if a file does not exist and has an invalid extension
 if [ ! -e "$dfiles$file" ] && [ ${file##*.} != $extension ]; then 
  # inform the user that a file does not exist and has an invalid extension
  echo -e "[ $file ] does NOT EXIST in [ $dfiles ] and has INVALID EXTENSION [ ${file##*.} ]. NOT PROCESSED.\n" 
  # skip current file and continue checking
  continue
 # check if a file doe not exist
 elif [ ! -e "$dfiles$file" ]; then
  # inform the user that a file does not exist but has a valid extension 
  echo -e "[ $file ] does NOT EXIST in [ $dfiles ] but has VALID EXTENSION [ ${file##*.} ]. NOT PROCESSED.\n"
  # skip current file and continue checking
  continue
 # check if a file does not have a valid extension 
 elif [ ${file##*.} != $extension ]; then
  # inform user that a file exists but does not have a valid extension
  echo -e "[ $file ] EXISTS in [ $dfiles ] but has INVALID EXTENSION [ ${file##*.} ]. NOT PROCESSED.\n"
  # skip current file and continue checking
  continue
 else
  # inform user that a file exists and its extension is valid 
  echo -e "[ $file ] EXISTS in [ $dfiles ] and has VALID EXTENSION [ ${file##*.} ]. PROCESSING...\n"
  files_process+=("$file") 
 fi
done

# make a directory to store pre-trimmed QC reports for processed files
mkdir qc_reports_pretrim

for file_process in ${files_process[@]}; do 
 # run fastqc and output processed files to the pre-trim directory 
 fastqc -o "${dfiles}qc_reports_pretrim" $file_process
done
