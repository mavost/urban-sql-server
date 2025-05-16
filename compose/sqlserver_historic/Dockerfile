ARG BASEIMAGE=mcr.microsoft.com/mssql/server:2022-latest
FROM ${BASEIMAGE}

ENV ACCEPT_EULA=Y \
    MSSQL_PID=Developer \
    DEBIAN_FRONTEND=noninteractive \
    PATH="$PATH:/opt/mssql-tools/bin"

USER root

RUN mkdir -p /var/opt/mssql/backup /usr/src/app && chown -R mssql /var/opt/mssql

# Install tools and download sample databases
RUN apt-get update && \
    apt-get install -y curl gnupg unixodbc-dev && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    apt-get install -y mssql-tools && \
    curl -L -o /var/opt/mssql/backup/WideWorldImporters-Full.bak https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak && \
    curl -L -o /var/opt/mssql/backup/WideWorldImportersDW-Full.bak https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImportersDW-Full.bak && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy scripts
COPY restore-databases.sh optimize-sqlserver.sh docker-entrypoint.sh /usr/src/app/
RUN chmod +x /usr/src/app/*.sh

# Health check: ensure SQL Server is responding
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" || exit 1

ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]
