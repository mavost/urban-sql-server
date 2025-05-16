#!/bin/bash

echo "Applying SQL Server performance optimizations..."

# Wait for SQL Server to be ready
until /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" &> /dev/null
do
  echo "Waiting for SQL Server to start..."
  sleep 2
done

# Configure max memory usage
if [ -n "$SQLSERVER_MAX_MEMORY_MB" ]; then
  echo "Setting max memory to ${SQLSERVER_MAX_MEMORY_MB} MB..."
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "EXEC sys.sp_configure 'show advanced options', 1; RECONFIGURE;"
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "EXEC sys.sp_configure 'max server memory (MB)', ${SQLSERVER_MAX_MEMORY_MB}; RECONFIGURE;"
fi

# Optional: disable telemetry-related features (lightweight pooling or diagnostics)
echo "Disabling lightweight pooling..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "EXEC sp_configure 'lightweight pooling', 0; RECONFIGURE;"

echo "Optimization complete."
