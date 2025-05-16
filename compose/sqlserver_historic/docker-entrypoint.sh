#!/bin/bash
set -e

/opt/mssql/bin/sqlservr &

# Wait until SQL Server is ready to accept connections
echo "Waiting for SQL Server to start..."
for i in {1..30}; do
    if /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1; then
        echo "SQL Server is up!"
        break
    fi
    echo "Still waiting..."
    sleep 2
done

# Run optimization script
echo "Running optimization script..."
/usr/src/app/optimize-sqlserver.sh

# Optionally restore databases
if [ "$SQL_RESTORE_ON_START" = "true" ]; then
    echo "Restoring sample databases..."
    /usr/src/app/restore-databases.sh
fi

# Bring sqlservr process to foreground
wait
