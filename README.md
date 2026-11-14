# Data-Cleaning-with-SQL
Handling data to be more concise and useful

## Data Cleaning Process

### 1. Removing Duplicate Records
Identified and removed duplicate records using the `ROW_NUMBER()` window function. I partitioned the data based on all relevant columns to identify duplicates, assigning a sequential number to each row. Records with a `row_num` greater than 1 were removed, and the helper column was no longer needed afterward.

### 2. Standardizing the Data
Improved data consistency by performing several standardization steps:
- **Industry:** Standardized similar industry names by removing redundant words and consolidating variations.
- **Country:** Removed unnecessary punctuation (e.g., trailing periods in "USA") and eliminated leading and trailing spaces using the `TRIM()` function.
- **Date:** Converted the `date` column from the `TEXT` data type to the proper `DATE` data type.

### 3. Handling NULL Values
Filled missing `industry` values by matching records with the same `company` and `location`. When one record contained an industry value and another matching record had a NULL value, I used the available information to populate the missing value.
