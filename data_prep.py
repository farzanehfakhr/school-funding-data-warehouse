# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd


# Define the Excel file path
excel_file = "/Users/farzanehfakhr/Documents/cs779/nerds_report.xlsx"  # Change this to your actual file name

# Read the Excel file
df = pd.read_excel(excel_file)

# Define the output CSV file name
csv_file = "/Users/farzanehfakhr/Documents/cs779/funding.csv"

# Save as CSV
df.to_csv(csv_file, index=False)

print(f"✅ Successfully converted '{excel_file}' to '{csv_file}'!")



# Define the CSV file path
csv_file = "/Users/farzanehfakhr/Documents/cs779/funding.csv"  # Change this to your actual CSV file

# Read the CSV file
df = pd.read_csv(csv_file)

# Replace "NRD" with NULL (NaN in Pandas, which is NULL in databases)
df.replace("NRD", None, inplace=True)

# Save the cleaned CSV file
cleaned_csv_file = "/Users/farzanehfakhr/Documents/cs779/cleaned_output.csv"
df.to_csv(cleaned_csv_file, index=False)

print(f"✅ 'NRD' replaced with NULL and saved as '{cleaned_csv_file}'")



# Define file paths
txt_file = "/Users/farzanehfakhr/Documents/cs779/sb_ca2022_1_csv_v1.txt"  # Change this to your actual text file
csv_file = "/Users/farzanehfakhr/Documents/cs779/performance.csv"  # Output CSV file name

# Read the text file (assuming it's tab- or comma-separated)
df = pd.read_csv(txt_file, delimiter="\t")  # Change delimiter if needed

# Save as CSV
df.to_csv(csv_file, index=False)

print(f"✅ Successfully converted '{txt_file}' to '{csv_file}'!")



# Define the input and output file names
txt_file = "/Users/farzanehfakhr/Documents/cs779/sb_ca2022_1_csv_v1.txt"  # Change this to your actual file name
csv_file =  "/Users/farzanehfakhr/Documents/cs779/performance.csv"   # Output CSV file

# Read the caret-delimited file
df = pd.read_csv(txt_file, delimiter="^", engine="python")

# Save as a comma-separated CSV
df.to_csv(csv_file, index=False)

print(f"✅ Successfully converted '{txt_file}' to '{csv_file}'!")


import pandas as pd

# Define file paths
txt_file = "/Users/farzanehfakhr/Documents/cs779/sb_ca2022entities_csv.txt"  # Change this to your actual file
csv_file = "/Users/farzanehfakhr/Documents/cs779/entity1.csv"  # Output CSV file

# Read the caret-delimited file with correct encoding
df = pd.read_csv(txt_file, delimiter="^", encoding="latin1", engine="python")

# Save as a comma-separated CSV
df.to_csv(csv_file, index=False, encoding="utf-8")

print(f"✅ Successfully converted '{txt_file}' to '{csv_file}' with proper encoding!")

# Define the input and output file names
txt_file = "/Users/farzanehfakhr/Documents/cs779/tests.txt"  # Change this to your actual file name
csv_file =  "/Users/farzanehfakhr/Documents/cs779/tests.csv"   # Output CSV file

# Read the caret-delimited file
df = pd.read_csv(txt_file, delimiter="^", engine="python")

# Save as a comma-separated CSV
df.to_csv(csv_file, index=False)

print(f"✅ Successfully converted '{txt_file}' to '{csv_file}'!")



