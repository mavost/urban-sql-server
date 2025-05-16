#!/bin/bash
set -e

echo "$(date) Restoring WideWorldImporters..."

# Restore WideWorldImporters
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "
RESTORE DATABASE WideWorldImporters
FROM DISK = '/var/opt/mssql/backup/WideWorldImporters-Full.bak'
WITH MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImporters.mdf',
     MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImporters_UserData.ndf',
     MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImporters.ldf',
     MOVE 'WWI_InMemory_Data_1' TO '/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1',
     REPLACE
"

echo "$(date) Restoring WideWorldImportersDW..."

# Restore WideWorldImportersDW
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "
RESTORE DATABASE WideWorldImportersDW
FROM DISK = '/var/opt/mssql/backup/WideWorldImportersDW-Full.bak'
WITH MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImportersDW.mdf',
     MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImportersDW_UserData.ndf',
     MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImportersDW.ldf',
     MOVE 'WWIDW_InMemory_Data_1' TO '/var/opt/mssql/data/WideWorldImportersDW_InMemory_Data_1',
     REPLACE
"

echo "$(date) Restore complete."
