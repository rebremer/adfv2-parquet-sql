## AAD authentication from ADFv2 to Azure Function using Managed Identity  ##

Added a parquet file to a SQLDB using the following steps

- New message added to Azure Queue
- Azure Function triggered by queue trigger
- Azure Function creates new file on ADLSgen2 (either a parquet file or csv file)
- Azure Data Factory is triggered upon new file creation
- Azuze Data Factory adds data to new staging table
- Azure Data Factory triggers Stored Procedure that only adds new data to final table to serve customers

Architecture is depicted below.

![Architecture](https://github.com/rebremer/adfv2-parquet-sql/_pictures/parquet2sql.png "Architecture")

Steps to be executed

1. Create Storage queue, Azure Function in Python with Queue trigger, ADLSgen2, SQLDB and ADFv2 instance
2. Add code of _Azure Function in this git repo to your Funtion, configure it with your storage queue
3. Execute SQL script this git repo on your SQLDB, add Managed Instance as user of your SQLDB (see also script)
4. Setup File System on ADLS gen 2, add Managed Instance as Storage Blob Data Contributer of your ADLSgen2
5. Creat new pipeline in your ADFv2 instance by connecting to this git repo
