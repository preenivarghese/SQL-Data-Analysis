# SQL-Data-Analysis
This repository contains a SQL file that performs various operations on a dataset named nashville_housing_data. The dataset is cleaned and standardized to make it ready for further analysis.
Dataset
The nashville_housing_data dataset contains information about the properties sold in Nashville. It contains various columns like parcelid, propertyaddress, owneraddress, saleprice, saledate, legalreference, and soldasvacant.

Operations Performed: 
The SQL file contains the following operations performed on the dataset:
* Selecting all the rows from the imported dataset
* Standardizing the data format by converting saledate to a date format
* Populating missing Property Address data using a view named propertyaddress_view
* Breaking out property address column into individual columns (Address, City)
* Breaking out owner address column into individual columns (Address, City, State)
* Updating SoldAsVacant column to have only Yes/No values
* Deleting duplicates based on certain criteria
* Deleting unused columns to clean up the final data

Usage: 
To use this SQL file, you need to have access to the nashville_housing_data dataset and a SQL client. You can copy and paste the code into your SQL client and execute it.
Alternatively, you can import the SQL file into your database and execute it. Make sure to update the database name and table name according to your dataset before executing the queries.

Conclusion: 
This SQL file provides a comprehensive approach to cleaning and standardizing the nashville_housing_data dataset. You can further use this dataset for exploratory data analysis, building predictive models, or any other data-driven tasks.

