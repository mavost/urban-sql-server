#!/bin/bash

echo "Restoring WideWorldImporters..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "RESTORE DATABASE [WideWorldImporters] FROM DISK = '/var/opt/mssql/backup/WideWorldImporters-Full.bak' WITH MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImporters.mdf', MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImporters_userdata.ndf', MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImporters.ldf'"

echo "Restoring WideWorldImportersDW..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "RESTORE DATABASE [WideWorldImportersDW] FROM DISK = '/var/opt/mssql/backup/WideWorldImportersDW-Full.bak' WITH MOVE 'WWIDW_Primary' TO '/var/opt/mssql/data/WideWorldImportersDW.mdf', MOVE 'WWIDW_Log' TO '/var/opt/mssql/data/WideWorldImportersDW.ldf'"

echo "Restore complete."
